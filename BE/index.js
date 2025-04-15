const express = require('express');
const mongoose = require('mongoose'); 
const authRouter = require('./routers/auth');
const bannerRouter = require('./routers/banner');
const categoryRouter = require('./routers/category');
const subcategoryRouter = require('./routers/sub_category');
const productRouter = require('./routers/product');
const productReviewRouter = require('./routers/product_review');
const VendorRouter = require('./routers/vendor'); 
const orderRouter = require('./routers/order');
const cors = require('cors');
require('dotenv').config();

// Define the port number the server will listen on
const PORT = process.env.PORT || 3000;

// Create an instance of an express application
const app = express();
// mongodb string

app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subcategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(VendorRouter);
app.use(orderRouter);

mongoose.connect(process.env.DATABASE).then(() =>{
    console.log('Mongodb Connected');
});

// Start the server and listen on the specified port
app.listen(PORT, "0.0.0.0", function(){
    // Log the port number
    console.log(`Server is running on port ${PORT}`);
});
