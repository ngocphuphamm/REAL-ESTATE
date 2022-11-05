const sequelize = require("../config/database");
module.exports = {
	loginView: async (req, res) => {
		res.render("auth/login");
	},

	registerView: async (req, res) => {
		res.render("auth/register");
	},
	register: async (req, res) => {
		const { name, username, email, password, phone, avatar } = req.body;
		try {
			const newUser = await sequelize.query(
				"CALL sp_Register (:pr_username, :pr_password, :pr_name, :pr_email, :pr_phone, :pr_avatar)",
				{
					replacements: {
						pr_username: name,
						pr_password: username,
						pr_name: email,
						pr_email: password,
						pr_phone: phone,
						pr_avatar: "",
					},
				}
			);
			console.log(newUser);
			res.redirect("/");
		} catch (err) {
			console.log(err);
		}
	},
};
