const express = require("express");
const router = express.Router();
const controller = require('../controllers/typeController');

router.post('/addtype', controller.addType)
router.post('/', controller.getType)
router.post('/edittype', controller.editType)
router.post('/deletetype', controller.deleteType)
router.post('/resulttype', controller.getResultType)
router.post('/getpoints', controller.getPoints)

module.exports = router