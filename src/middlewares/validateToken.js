module.exports = async = (req, res, next) => {
    if (!req.cookies.userID) {
        return res.redirect('/auth/login');
    }
    next();
};
