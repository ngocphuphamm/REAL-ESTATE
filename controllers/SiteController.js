const Posts = require("../models/posts");
const Medias = require("../models/medias");
const sequelize = require("../config/database");
const { response } = require("express");
module.exports = {
	home: async (req, res) => {
		try {
			const posts = await Posts.findAll({
				include: Medias,
			});
			res.render("home/index", { posts });
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	search: async (req, res) => {
		try {
			const { provinceid, districtid, wardid, streetid, projectid } =
				req.query;
			if (provinceid) {
				const estates = await sequelize.query(
					`CALL sp_Province_Posts(:pr_province_id)`,
					{
						replacements: {
							pr_province_id: provinceid,
						},
					}
				);
			}
		} catch ({ message }) {
			res.render("error", { error: message });
		}
	},
	error: async (req, res) => {
		const error = "There is no error";
		res.render("error/index", { error: error });
	},
};
