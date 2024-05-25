const express = require("express");
const router = express.Router();
const path = require("path");
const multer = require("multer");

// Define the maximum size for uploading
// picture i.e. 1 MB. it is optional
const maxSize = 1 * 1000 * 1000;
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Uploads is the Upload_folder_name
    cb(null, "images");
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + ".jpg");
  },
});
const upload = multer({
  storage: storage,
  fileFilter: function (req, file, cb) {
    // Set the filetypes, it is optional
    var filetypes = /jpeg|jpg|png/;
    var mimetype = filetypes.test(file.mimetype);

    var extname = filetypes.test(path.extname(file.originalname).toLowerCase());

    if (mimetype && extname) {
      return cb(null, true);
    }

    cb(
      "Error: File upload only supports the " +
        "following filetypes - " +
        filetypes
    );
  },

  // mypic is the name of file attribute
});
router.post("/upload", upload.single("file"), function (req, res) {
  const title = req.body.title;
  const file = req.file;

  console.log(title);
  console.log(file);

  res.status(200).json({ file: file.filename });
});

// const {
//     getImgeFile,
//     setImgeFile,
//   } = require('../controllers/imageFileController')

// // Getting one
// router.route('/:id').get( upload, getImgeFile)

// // Creating one - become Owner
// router.route('/').post( upload, setImgeFile)

module.exports = router;
