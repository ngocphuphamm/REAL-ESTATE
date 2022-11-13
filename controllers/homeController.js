const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Posts = require("../models/posts");
const Medias = require("../models/medias");
module.exports = {
	getHome: async (req, res) => {
		const posts = await Posts(sequelize, DataTypes).findAll({
			raw: true,
		});
		console.log(posts);
		res.render("home/index");
	},
};
