const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Posts = require("../models/posts");
const Medias = require("../models/medias");
module.exports = {
	getHome: async (req, res) => {
		try {
			const posts = await Posts.findAll({
				include: Medias,
			});
			res.render("home/index", { posts });
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
};
