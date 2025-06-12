const express = require("express");
const router = express.Router();
const controller = require('../controllers/rankController');

router.post('/', controller.getRanks)
router.post('/addrank', controller.addRank)
router.post('/deleterank', controller.deleteRank)
router.post('/editrank', controller.editRank)
router.post('/collumns', controller.getCollumn)


module.exports = router