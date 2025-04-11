const express = require('express');
const ProductReview = require('../models/product_review');
const productReviewRouter = express.Router();
const Product = require('../models/product');
// Tạo đánh giá sản phẩm
productReviewRouter.post('/api/product-review', async (req, res) => {
    try {
        
        const { buyerId, email, fullName, productId, rating, review } = req.body;
        const reviews = new ProductReview({ buyerId, email, fullName, productId, rating, review });
        await reviews.save();

       // Tìm sản phẩm bằng productId
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
        }

        product.totalRatings += 1;
        product.averageRating = ((product.averageRating * (product.totalRatings - 1)) + rating) / product.totalRatings;
        await product.save();

        console.log("✅ Đánh giá sản phẩm thành công và lưu lại.");
        return res.status(201).send(reviews);

    } catch (e) {
        console.error("❌ Lỗi:", e.message);
        res.status(500).json({ "error": e.message });
    }
});


// Lấy tất cả các đánh giá
productReviewRouter.get('/api/reviews', async (req, res) => {
    try {
        const reviews = await ProductReview.find();
        console.log("✅ Lấy danh sách đánh giá thành công.");
        return res.status(201).json(reviews);
    } catch (e) {
        console.error("❌ Lỗi xảy ra khi lấy đánh giá:", e.message);
        res.status(500).json({ "error": e.message });
    }
});

module.exports = productReviewRouter;
