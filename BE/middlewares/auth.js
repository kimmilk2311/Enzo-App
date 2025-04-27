const jwt = require('jsonwebtoken');
const User = require('../models/user'); 
const Vendor = require('../models/vendor');


// User authentioncation middleware
const auth = async (req, res, next) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) {
      return res.status(401).json({ msg: "Không xác thực được token. Truy cập bị từ chối." });
    }

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.status(401).json({ msg: "Token không hợp lệ. Truy cập bị từ chối." });
    }

   const user =  await User.findById(verified.id) || await Vendor.findById(verified.id); 

    if(!user) return res.status(401).json({msg:"Người dùng hoặc nhà cung cấp không hợp lệ"});

    req.user = user;
    req.token = token;
    next();

} catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// vendor authentioncation middleware
const vendorAuth = async (req, res, next) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) {
      return res.status(401).json({ msg: 'No token, authorization denied' });
    }

    const verified = jwt.verify(token, 'passwordKey'); // 'passwordKey' là key của bạn
    if (!verified) {
      return res.status(401).json({ msg: 'Token verification failed' });
    }

    // Kiểm tra role có phải là 'vendor' không
    if (verified.role !== 'vendor') {
      return res.status(403).json({ msg: 'You are not authorized as a vendor' });
    }

    req.user = verified; // Gán thông tin user vào request
    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

 module.exports = {auth, vendorAuth};
