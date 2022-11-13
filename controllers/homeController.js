const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const { Posts, Medias } = require("../models/posts");
module.exports = {
	getHome: async (req, res) => {
		try {
			const posts = await Posts.findAll({
				include: [{ model: Medias, as: "medias" }],
			});
			res.render("home/index", { posts });
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
};
