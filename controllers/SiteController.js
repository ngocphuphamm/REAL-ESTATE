const Posts = require("../models/posts");
const Medias = require("../models/medias");
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
	error: async (req, res) => {
		const error = "There is no error";
		res.render("error/index", { error: error });
	},
};
