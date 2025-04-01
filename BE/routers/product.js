const express = require('express');
const Product = require('../models/product');
const {auth,vendorAuth} = require('../middlewares/auth');
const mongoose = require('mongoose');
const subCategory = require('../models/sub_category');

const productRouter = express.Router();

// API thêm sản phẩm mới
productRouter.post('/api/add-products', auth, vendorAuth,async (req, res) => {
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
    const products = await Product.find({ category,popular:true });

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
        const topRatedroducts = await Product.find().sort({ averageRating: -1 }).limit(10);
        if (!topRatedroducts || topRatedroducts.length == 0) {
            return res.status(404).json({ msg: "Không tìm thấy sản phẩm" });
        } else {
            return res.status(200).json(topRatedroducts);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = productRouter;