const multer = require("multer");
const path = require('path');

const uploadFolder = path.resolve(__dirname, '..', 'upload');

const storage = multer.diskStorage({
  destination: uploadFolder,
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  }
})

module.exports = multer({ storage: storage });;

