const express = require("express");
const { addressController } = require("../controllers");
const router = express.Router();

router.get("/categories", addressController.categories);
router.get("/provinces", addressController.provinces);
router.get("/districts/", addressController.districts);
router.get("/wards/", addressController.wards);
router.get("/streets/", addressController.streets);
router.get("/projectsByProvince/", addressController.projectsByProvince);
router.get(
	"/projectsByDistrictAndProvince/",
	addressController.projectsByDistrictAndProvince
);

module.exports = router;
