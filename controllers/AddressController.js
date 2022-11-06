const sequelize = require("../config/database");

module.exports = {
	categories: async (req, res) => {
		const categories = await sequelize.query("SELECT * FROM categories");
		res.status(200).json(categories.flat());
	},
	provinces: async (req, res) => {
		const provinces = await sequelize.query("SELECT * FROM province");
		res.status(200).json(provinces.flat());
	},
	districts: async (req, res) => {
		const { provinceID } = req.query;
		const districts = await sequelize.query(
			`SELECT * FROM district WHERE provinceid = '${provinceID}'`
		);
		res.status(200).json(districts.flat());
	},
	wards: async (req, res) => {
		const { districtID, provinceID } = req.query;
		const wards = await sequelize.query(
			`SELECT * FROM ward WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`
		);
		res.status(200).json(wards.flat());
	},
	streets: async (req, res) => {
		const { districtID, provinceID } = req.query;
		const wards = await sequelize.query(
			`SELECT * FROM street WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`
		);
		res.status(200).json(wards.flat());
	},
	projects: async (req, res) => {
		const { districtID, provinceID } = req.query;
		const projects = await sequelize.query(
			`SELECT * FROM project WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`
		);
		res.status(200).json(projects.flat());
	},
};
