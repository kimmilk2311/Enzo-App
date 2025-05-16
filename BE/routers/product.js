const express = require('express');
const Product = require('../models/product');
const {auth,vendorAuth} = require('../middlewares/auth');
const mongoose = require('mongoose');
const Vendor = require('../models/vendor');
const subCategory = require('../models/sub_category');

const productRouter = express.Router();

// API thêm sản phẩm mới
productRouter.post('/api/add-products',async (req, res) => {
    try {
        const { productName, productPrice, quantity, description, category,vendorId, fullName, subCategory, images } = req.body;

        // Kiểm tra nếu thiếu dữ liệu quan trọng
        if (!productName || !productPrice || !quantity || !category || !subCategory || !images) {
            return res.status(400).json({ error: "Vui lòng cung cấp đầy đủ thông tin sản phẩm!" });
        }

        const product = new Product({ productName, productPrice, quantity, description, category,vendorId, fullName, subCategory, images });
        await product.save();
        
        return res.status(201).json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
  // API lấy tất cả sản phẩm
productRouter.get('/api/products', async (req, res) => {
    try {
        const products = await Product.find();

        if (!products || products.length === 0) {
            return res.status(404).json({ msg: "Không tìm thấy sản phẩm nào!" });
        }

        return res.status(200).json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get('/api/popular-products',async(req, res)=>{
    try{
      const product =  await Product.find({popular: true});
      if(!product || product.length === 0){ 

        return res.status(404).json({msg:"không tìm thấy sản phẩm"});
      }else{
        return res.status(200).json(product);
      }
    }catch(e){
        res.status(500).json({error:e.message});
    }
});

productRouter.get('/api/recommended-products',async(req, res)=>{
    try{
      const product =  await Product.find({recommend: true});
      if(!product || product.length === 0){ 
        return res.status(404).json({msg:"không tìm thấy sản phẩm"});
      }else{
        return res.status(200).json(product);
      }
    }catch(e){
        res.status(500).json({error:e.message});
    }
});

productRouter.get('/api/products-by-category/:category', async (req, res) => {
  try {
    const { category } = req.params;

    // Kiểm tra nếu category rỗng
    if (!category || category.trim() === "") {
      return res.status(400).json({ error: "Danh mục không hợp lệ!" });
    }

    // Truy vấn danh mục trong MongoDB (Không phân biệt chữ hoa/thường)
    const products = await Product.find({ category});

    // Kiểm tra nếu không có sản phẩm nào trong danh mục
    if (!products || products.length === 0) {
      return res.status(404).json({ msg: `Không tìm thấy sản phẩm trong danh mục '${category}'` });
    }

    // Trả về danh sách sản phẩm
    return res.status(200).json(products);
  } catch (e) {
    console.error(`Lỗi khi truy vấn danh mục '${req.params.category}':`, e);
    return res.status(500).json({ error: "Lỗi server, vui lòng thử lại sau!" });
  }
});

// Lấy sản phẩm theo subcategory
productRouter.get('/api/related-products-by-subcategory/:productId', async (req, res) => {
  try {
    const { productId } = req.params;

    if (!productId || productId.trim() === "") {
      return res.status(400).json({ error: "ID sản phẩm không hợp lệ!" });
    }

    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ msg: `Không tìm thấy sản phẩm với ID '${productId}'` });
    }

    const relatedProducts = await Product.find({
      subCategory: product.subCategory,
      _id: { $ne: productId }
    }).limit(10);

    if (!relatedProducts || relatedProducts.length === 0) {
      return res.status(404).json({ msg: `Không tìm thấy sản phẩm nào liên quan trong subcategory '${product.subCategory}'` });
    }

    return res.status(200).json(relatedProducts);
  } catch (e) {
    console.error(`Lỗi khi truy vấn sản phẩm liên quan:`, e);
    return res.status(500).json({ error: "Lỗi server, vui lòng thử lại sau!" });
  }
});


// 10 sản phẩm được đánh giá cao nhất
productRouter.get('/api/top-rated-products', async (req, res) => {
    try {
        const topRatedProducts = await Product.find().sort({ averageRating: -1 }).limit(10);
        if (!topRatedProducts || topRatedProducts.length == 0) {
            return res.status(404).json({ msg: "Không tìm thấy sản phẩm" });
        } else {
            return res.status(200).json(topRatedProducts);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get("/api/products-by-subcategory/:subcategoryId", async (req, res) => {
try {
  const { subcategoryId } = req.params;
  const products = await Product.find({ subCategory: subcategoryId });
  if (!products || products.length === 0)
    {
  return res.status(404).json({msg:"Không tìm thấy sản phẩm theo danh mục con"});
}
return res.status(200).json(products);
} catch (e) {
  res.status(500).json({ error: e.message });
}
});

// timf kiếm sản phẩm theo tên hoac mô tả
productRouter.get('/api/search-products', async (req, res) => {
    try {
        const { query } = req.query;
        if (!query) {
            return res.status(400).json({ msg: "Vui lòng cung cấp từ khóa tìm kiếm!" });
        }

       // tìm kiếm bộ sưu tập Sản phẩm cho docy=ument trong đó 'productName' hoặc 'description' chứa chuỗi truy vấn  
       const products = await Product.find({
        $or: [
          { productName: { $regex: query, $options: 'i' } },
          { description: { $regex: query, $options: 'i' } }
        ]
      });
      
      if (!products || products.length === 0) {
        return res.status(404).json({ msg: "Không tìm thấy sản phẩm nào!" });
      }
      
      return res.status(200).json(products);
      
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.put('/api/edit-product/:productId', async (req, res) => {
  try {
      const { productId } = req.params;

      // Kiểm tra xem sản phẩm có tồn tại trong cơ sở dữ liệu không
      const product = await Product.findById(productId);
      if (!product) {
          return res.status(404).json({ msg: "Không tìm thấy sản phẩm" });
      }

      // Lấy dữ liệu cần cập nhật từ req.body và loại bỏ vendorId (nếu có)
      const { vendorId, ...updateData } = req.body;

      // Cập nhật sản phẩm với dữ liệu mới
      const updatedProduct = await Product.findByIdAndUpdate(
          productId, 
          { $set: updateData }, 
          { new: true }
      );

      // Trả về sản phẩm đã cập nhật
      res.status(200).json(updatedProduct);
  } catch (e) {
      // Lỗi server
      res.status(500).json({ error: e.message });
  }
});



// fetch products by vendor id
productRouter.get('/api/products/vendor/:vendorId',async(req,res)=>{
    try {
      const { vendorId } = req.params;

      const vendorExists = await Vendor.findById(vendorId); 
      if(!vendorExists) {
        return res.status(404).json({ msg: "Không tìm thấy vendor" });
      }
      const products = await Product.find({ vendorId });

      res.status(200).json(products);
    
  } catch (e) {
    return res.status(500).json({ error: e.message });  
  }
   
  });

module.exports = productRouter;