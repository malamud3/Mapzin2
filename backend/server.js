require("dotenv").config();
const express = require("express");
const app = express();
const mongoose = require("mongoose");
const { errorHandler } = require("./middleware/errorMiddleware");
const { setProjectToDead } = require("./controllers/projectController");
const cors = require("cors");
app.use(
  cors({
    origin: "*",
  })
);

const bodyParser = require("body-parser");
app.use(bodyParser.json()); // to support JSON-encoded bodies
app.use(
  bodyParser.urlencoded({
    // to support URL-encoded bodies
    extended: true,
  })
);

const fs = require("fs");
const path = require("path");

//DATABASE
mongoose.connect(
  "mongodb+srv://amir:amir@bestsites.mtxy2.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",
  { useNewUrlParser: true, useUnifiedTopology: true }
);
const db = mongoose.connection;
db.on("error", (error) => console.error(error));
db.once("open", () => {
  console.log("Connected to Database");
  setInterval(() => {
    setProjectToDead();
  }, 5000);
});

app.use(express.json());

const projectsRouter = require("./routes/projects");
const useresRouter = require("./routes/users");
const imageFileRouter = require("./routes/imageFile");
app.use("/projects", projectsRouter);
app.use("/users", useresRouter);
app.use("/imageFile", imageFileRouter);
app.use(express.static("images"));
app.use(errorHandler);

// // Serve frontend
//   app.use(express.static(path.join(__dirname, '../frontend/build')))

//   app.get('*', (req, res) =>
//     res.sendFile(
//       path.resolve(__dirname, '../', 'frontend', 'build', 'index.html')
//     )
//   )
//

app.listen(process.env.PORT || 3000, () => console.log("server Started"));
