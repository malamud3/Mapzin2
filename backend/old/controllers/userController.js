const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const asyncHandler = require("express-async-handler");
const User = require("../models/user");
const Project = require("../models/project");
const mongoose = require("mongoose");

//     Register new user
//     access:  Guest
const registerUser = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    res.status(400);
    throw new Error("Please add all fields");
  }

  // Check if user exists
  const userExists = await User.findOne({ name });

  if (userExists) {
    res.status(400);
    throw new Error("User already exists");
  }

  // Hash password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);

  // Create user
  const user = await User.create({
    name,
    email,
    password: hashedPassword,
  });

  if (user) {
    res.status(201).json({
      _id: user.id,
      name: user.name,
      email: user.email,
      token: generateToken(user._id),
    });
  } else {
    res.status(400);
    throw new Error("Invalid user data");
  }
});

// @desc    Authenticate a user
// @route   POST /users/login
// @access  Public
const loginUser = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;

  // Check for user email
  const user = await User.findOne({ name });

  if (user && (await bcrypt.compare(password, user.password))) {
    res.json({
      _id: user.id,
      name: user.name,
      email: user.email,
      token: generateToken(user._id),
    });
  } else {
    res.status(400);
    throw new Error("Invalid credentials");
  }
});

// @desc    Get user data
// @route   GET /users/me
// @access  Private
const getMe = asyncHandler(async (req, res) => {
  console.log(req.user);
  res.status(200).json(req.user);
});

// Generate JWT
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {});
};

const getProfile = asyncHandler(async (req, res) => {
  const id = mongoose.Types.ObjectId(req.params.id);
  const user = await User.findById(id, { password: 0 });
  res.status(200).json(user);
});

//   Deleting a user
//   Access:  Admin
const deletingUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id);
  if (req.user.admin !== true) {
    res.status(401);
    throw new Error("Operation approved only for admin");
  }
  await user.remove();
});

module.exports = {
  registerUser,
  loginUser,
  getMe,
  getProfile,
  deletingUser,
};
