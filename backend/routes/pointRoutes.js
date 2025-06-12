const express = require("express");
const router = express.Router();
const controller = require('../controllers/pointController')

router.post('/addpoint', controller.addPoint)
router.post('/', controller.getPoint)
router.post('/editpoint', controller.editPoint)
router.post('/deletepoint', controller.deletePoint)
router.post('/addmethod', controller.addMethod)
router.post('/editmethod', controller.editMethod)
router.post('/deletemethod', controller.deleteMethod)
router.post('/getmethods', controller.getMethods)


module.exports = router