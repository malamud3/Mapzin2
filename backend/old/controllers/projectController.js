const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const Project = require("../models/project");
const User = require("../models/user");
const path = require("path");
const multer = require("multer");
const maxSize = 1 * 10000 * 10000;

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
}).single("file");

//  Get Projects
// access:  Guest
const getProjects = asyncHandler(async (req, res) => {
  const projects = await Project.find();

  res.status(200).json(projects);
});

// Get Project
// access:  Guest
const getProject = asyncHandler(async (req, res, next) => {
  try {
    let id = mongoose.Types.ObjectId(req.params.id);
    const project = await Project.findById(id);
    res.status(200).json(project);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
});

//  Set Project
//  access: Any registered user
const setProject = asyncHandler(async (req, res) => {
  const newDate = new Date(req.body.expirationDate);
  console.log(newDate);
  try {
    const project = await Project.create({
      project_name: req.body.project_name,
      description: req.body.description,
      main_image: req.body.main_image ? req.body.main_image : "notfound.png",
      video_url: req.body.video_url,
      owner: req.user.id, /// Current user - will be the Owner
      img_list: req.body.Img_list,
      investors: req.body.investors,
      project_qa: req.body.project_qa,
      goal: req.body.goal,
      expirationDate: newDate,
      correntMoney: 0,
      project_url: req.body.project_url,
    });
    res.status(200).json(project);
  } catch (err) {
    console.log(err);
  }
});

// Update project
// access:  Owner
const updateProject = asyncHandler(async (req, res) => {
  const project = await Project.findById(req.params.id);

  if (!project) {
    res.status(400);
    throw new Error("project not found");
  }

  // Check for user
  if (!req.user) {
    res.status(401);
    throw new Error("User not found");
  }
  const updatedProject = await Project.findByIdAndUpdate(
    req.params.id,
    req.body,
    {
      new: true,
    }
  );

  res.status(200).json(updatedProject);
});

//   Delete project
//   access:  Admin
const deleteProject = asyncHandler(async (req, res) => {
  let id = mongoose.Types.ObjectId(req.params.id);
  const project = await Project.findById(id);
  if (!project) {
    res.status(400);
    throw new Error("Project not found");
  }

  // Check for user
  if (!req.user) {
    res.status(401);
    throw new Error("User not found");
  }

  // Make sure the logged in user is Admin
  if (req.user.admin !== true) {
    res.status(401);
    throw new Error("Operation approved only for the owner");
  }
  await project.remove();
  res.status(200).json({ id: req.params.id });
});

//   Donate project
//   access:  Any registered user
const donateProject = asyncHandler(async (req, res) => {
  const project = await Project.findById(req.params.id);
  const user = await User.findById(req.user.id);
  const amount = req.body.amount;
  console.log(amount);
  if (!project) {
    res.status(400);
    throw new Error("project not found");
  }

  // Check for user
  if (!req.user) {
    res.status(401);
    throw new Error("User not found");
  }
  const newUserInvestor = {
    id: req.user.id,
    amount: amount,
    username: req.user.name,
  };
  const newUserInvesting = {
    projectRef: project.project_name,
    amount: amount,
  };
  const newInvestorsArray = [...project.investors, newUserInvestor];
  const correctMoney = newInvestorsArray.reduce(
    (previousValue, currentValue) =>
      previousValue + parseInt(currentValue.amount),
    0
  );
  let status = "Live";
  if (correctMoney >= project.goal) {
    status = "Financed";
  }
  console.log(correctMoney);
  const newInvestingArray = [...user.invsting, newUserInvesting];
  const donatedProject = await Project.findByIdAndUpdate(
    req.params.id,
    {
      investors: newInvestorsArray,
      correntMoney: correctMoney,
      status: status,
    },
    {
      new: true,
    }
  );
  const donatedUser = await User.findByIdAndUpdate(
    req.user.id,
    { invsting: newInvestingArray },
    {
      new: true,
    }
  );

  res.status(200).json(donatedProject);
});

//    Get expiration date
//    access:  Guest
const getExpirationDate = asyncHandler(async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);
    res.status(200).json(project.body.expirationDate.toString());
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
});

//  Get Top 5 project
//   access:  Any registered user
const getLiveProject = asyncHandler(async (req, res) => {
  const projects = await Project.find({});
  res.status(200).json(projects);
});

//  Get Top Live project
//   access:  Any registered user
const getLiveProjects = asyncHandler(async (req, res) => {
  const projects = await Project.find({ status: "Live" });
  res.status(200).json(projects);
});

const getDeadProjects = asyncHandler(async (req, res) => {
  const projects = await Project.find({ status: "Dead" });
  res.status(200).json(projects);
});

const getFinancedProjects = asyncHandler(async (req, res) => {
  const projects = await Project.find({ status: "Financed" });
  res.status(200).json(projects);
});

const setProjectToDead = async () => {
  const projects = await Project.find({ status: "Live" });
  const today = new Date();
  for (let i = 0; i < projects.length; i++) {
    if (projects[i].expirationDate < today) {
      let proj = await Project.findOneAndUpdate(
        { _id: projects[i]._id },
        { status: "Dead" },
        {
          new: true,
        }
      );
    }
  }
};
module.exports = {
  getProject,
  setProject,
  updateProject,
  deleteProject,
  donateProject,
  getProjects,
  getExpirationDate,
  getLiveProject,
  getLiveProjects,
  getDeadProjects,
  getFinancedProjects,
  setProjectToDead,
};
