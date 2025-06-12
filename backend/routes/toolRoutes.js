const express = require("express");
const router = express.Router();
const controller = require("../controllers/toolController.js");
const inspection = require("../controllers/inspectionController.js");

router.post("/", controller.getTools);
router.post("/add", controller.addTool);
router.post("/edit", controller.editTool);
router.post("/delete", controller.deleteTool);
router.post("/data", controller.getData);
router.post("/updatedata", controller.updateData);
router.post("/getcollumn", controller.getColumn);
router.post("/dailycheckinit", controller.dailyCheckInit);
router.post("/getimage", controller.reqImage);
router.post("/dailychecksubmit", controller.dailychecksubmit);
router.post("/abnormalreportinit", controller.abnormalityInit);
router.post("/signweeklyreport", controller.signweeklyreport);
router.post("/getmonthlyreports", controller.getMonthlyReports);
router.post("/monthlyinspection", inspection.monthlyInit);
router.post("/monthlysign", inspection.monthlySign);
router.post("/abnormals", controller.getAbnormality);

module.exports = router;
