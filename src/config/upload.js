const multer = require("multer");
const path = require('path');

const uploadFolder = path.resolve(__dirname, '..', 'upload');

const storage = multer.diskStorage({
  destination: uploadFolder,
  filename: function (req, file, cb) {
    //const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    //cb(null, uniqueSuffix + '-' + file.originalname);
    const ext = file.mimetype.split('/')[1];

    const uniqueSuffix = Date.now().toString();
    cb(null, uniqueSuffix + `.${ext}`);
  }
})

module.exports = multer({ storage: storage });;

