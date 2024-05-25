const mongoose = require("mongoose");

const projectSchema = new mongoose.Schema({
  project_name: {
    type: String,
    required: [true, "Please insert name"],
    trim: true,
    unique: [true, " project name already exists"],
    minlength: 3,
  },

  description: { type: String },

  main_image: { type: String },

  video_url: { type: String },

  owner: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },

  investors: [
    {
      id: { type: mongoose.Schema.Types.ObjectId, required: true, ref: "User" },
      amount: { type: Number },
      username: { type: String },
    },
  ],

  gift: {
    package: { type: { enum: ["Basic", "Standard", "Premium"] } },
    basic: { type: String },
    standard: { type: String },
    premium: { type: String },
  },

  img_list: [{ type: String }],

  project_qa: [
    {
      questions: { type: String },
      answers: { type: String },
    },
  ],

  goal: { type: Number },

  correntMoney: { type: Number, default: 0 },

  expirationDate: { type: Date, default: new Date() },

  status: { type: String, default: "Live" },
  project_url: { type: String, default: "" },
});

module.exports = mongoose.model("Project", projectSchema);
