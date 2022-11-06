module.exports = async = (req, res, next) => {
	if (!req.cookies.userID) {
		res.redirect("/auth/login");
	}
	next();
};
