const express = require('express');
const Vendor = require('../models/vendor');
const VendorRouter = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

const { auth,vendorAuth } = require('..//middlewares/auth');

// Signup API
VendorRouter.post('/api/v2/vendor/signup', async (req, res) => {
  try {
    const { fullName, email, phone, password, storeName, storeImage, storeDescription , address =""} = req.body;

    const  exitstingUserEmail = await User.findOne({ email });
    if (exitstingUserEmail) {
      return res.status(400).json({ msg: "Email này đã được sử dụng" });
    }

    const existingEmail = await Vendor.findOne({ email });
    if (existingEmail) {
      return res.status(400).json({ msg: "Email này đã được sử dụng" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    let vendor = new Vendor({
      fullName,
      email,
      phone,
      address: address || "",
      password: hashedPassword,
      storeName,
      storeImage,
      storeDescription,
    });

    vendor = await vendor.save();

    return res.json({ vendor });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// Login API 
VendorRouter.post('/api/v2/vendor/signin', async (req, res) => {
  try {
    const { loginInput, password } = req.body;

    // Tìm vendor theo email hoặc số điện thoại
    const vendor = await Vendor.findOne({
      $or: [{ email: loginInput }, { phone: loginInput }]
    });

    if (!vendor) {
      return res.status(400).json({ msg: "Không tìm thấy tài khoản." });
    }

    const isMatch = await bcrypt.compare(password, vendor.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Sai mật khẩu." });
    }

    // Xóa password khỏi object trả về
    const { password: _, ...vendorWithoutPassword } = vendor._doc;

    // Tạo token
    const token = jwt.sign({ id: vendor._id }, "passwordKey", { expiresIn: "1m" });

    res.json({ token,vendorWithoutPassword });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// API KIỂM TRA TOKEN 
VendorRouter.post('/api/vendor-tokenIsValid', async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const vendor = await Vendor.findById(verified.id);
    if (!vendor) return res.json(false);

    return res.json(true);
  } catch (e) {
    console.log("❌ Lỗi xác thực token:", e);
    return res.status(500).json({
      error: "Đã xảy ra lỗi trong quá trình xác thực token. Vui lòng thử lại sau.",
    });
  }
});

// Xác định một tuyến đường lấy cho roter xác thực
VendorRouter.get('/get-vendor', auth, async(req, res) => {
  try {
  
    const vendor = await Vendor.findById(req.user); 
  
   return  res.json({...vendor._doc, token: req.token}); // Trả về thông tin người dùng và token
    
  } catch (e) {
    console.error("❌ Lỗi xác thực:", e);
    return res.status(500).json({ error: "Đã xảy ra lỗi trong quá trình xác thực. Vui lòng thử lại sau." });  
    
  }
  
  });

// ✅ API lấy thông tin Vendor từ token
VendorRouter.get('/api/vendor/profile', auth, vendorAuth , async (req, res) => {
  try {
    const vendor = await Vendor.findById(req.user._id).select('-password');

    if (!vendor) {
      return res.status(404).json({ msg: "Không tìm thấy vendor." });
    }

    res.json(vendor);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


//fetch all vendors(exclude password)
VendorRouter.get('/api/vendors',async(req,res)=>{
  try {
    const vendors = await Vendor.find().select('-password'); 
    res.status(200).json(vendors);
  } catch (e) {
      res.status(500).json({error:e.message});
  }
});


module.exports = VendorRouter;
