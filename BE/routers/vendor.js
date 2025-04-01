const express = require('express');
const Vendor = require('../models/vendor');
const VendorRouter = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const authVendor = require('../middlewares/authVendorMiddleware');

// Signup API
VendorRouter.post('/api/vendor/signup', async (req, res) => {
  try {
    const { fullName, email, phone, password, image, address } = req.body;

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
      image: image || "",
      address: address || "",
      password: hashedPassword,
    });

    vendor = await vendor.save();

    return res.json({ vendor });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

VendorRouter.post('/api/vendor/signup', async (req, res) => {
  try {
    const { fullName, email, phone, password, image, address } = req.body;

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
      image: image || "",
      address: address || "",
      password: hashedPassword,
      role: "vendor"  
    });

    vendor = await vendor.save();

    return res.json({ vendor });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// ✅ API lấy thông tin Vendor từ token
VendorRouter.get('/api/vendor/profile', authVendor, async (req, res) => {
  try {
    const vendor = await Vendor.findById(req.vendorId).select('-password'); // bỏ mật khẩu

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
