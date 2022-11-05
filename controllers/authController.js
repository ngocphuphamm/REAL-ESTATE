module.exports = {
	login: async (req, res) => {
		res.render("auth/login");
	},

	register: async (req, res) => {
		res.render("auth/register");
	},
};
