const sequelize = require("../config/database");
module.exports = {
	loginView: async (req, res) => {
		res.render("auth/login");
	},

	registerView: async (req, res) => {
		res.render("auth/register");
	},
	register: async (req, res) => {
		const { Name, Username, Email, Password, Phone } = req.body;
		
		try {
			const newUser = await sequelize.query(
				"CALL sp_Register (:pr_username, :pr_password, :pr_name, :pr_email, :pr_phone, :pr_avatar)",
				{
					replacements: {
						pr_username: Username,
						pr_password: Password,
						pr_name: Name,
						pr_email: Email,
						pr_phone: Phone,
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
