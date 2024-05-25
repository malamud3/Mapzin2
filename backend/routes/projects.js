const express = require("express");
const router = express.Router();
const {
  getProject,
  setProject,
  updateProject,
  deleteProject,
  donateProject,
  getLiveProjects,
  getProjects,
  getDeadProjects,
  getFinancedProjects,
} = require("../controllers/projectController");

const { protect } = require("../middleware/authMiddleware");

// Getting all
router.route("/").get(getProjects);

// Getting one
router.route("/project/:id").get(getProject);

// Creating one - become Owner
router.route("/").post(protect, setProject);

// Updating One
router.route("/:id").put(protect, updateProject);

// Deleting One -Admin only
router.route("/delete/:id").delete(protect, deleteProject);

// Donate Project
router.route("/donate/:id").post(protect, donateProject);

router.route("/live").get(getLiveProjects);
router.route("/dead").get(getDeadProjects);
router.route("/financed").get(getFinancedProjects);
module.exports = router;
