module.exports = {
	postView: async (req, res) => {
		res.render("post/index");
	},
	uploadPost: async (req, res) => {
		console.log(req.body);
	},
	postDetail: async (req, res) => {},
};
