const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please insert name"],
    trim: true,
    unique: true,
    minlength: 3,
  },

  email: {
    type: String,
    required: [true, "Please insert an email"],
    unique: true,
  },

  password: { type: String, required: [true, "Please insert a password"] },

  invsting: [
    {
      projectRef: { type: String, ref: "project_Name" },
      amount: { type: Number },
    },
  ],

  admin: { type: Boolean, default: false }, // 1 admin 0 not-admin
});

module.exports = mongoose.model("User", userSchema);
