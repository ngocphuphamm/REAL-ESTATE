const Users = require("../models/users");
const sequelize = require("../config/database");
const SavePosts = require("../models/savePosts");
const Posts = require("../models/posts");

module.exports = {
	detail: async (req, res) => {
		try {
			const { userID } = req.params;
			const user = await Users.findByPk(userID, { raw: true });
			res.status(200).json({ success: true, body: user });
		} catch (err) {
			res.status(400).json({ success: false, message: err.message });
		}
	},
	bookmark: async (req, res) => {
		try {
			const { userID } = req.params;
			const bookmark = await SavePosts.findAll({
				where: {
					userid: userID,
				},
				include: Posts,
			});
			res.status(200).json({ success: true, body: bookmark });
		} catch (err) {
			res.status(400).json({ success: false, message: err.message });
		}
	},
};
