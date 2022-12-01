const { json } = require('express/lib/response');
const sequelize = require('../config/database');
const Users = require('../models/users');
module.exports = {
    loginView: async (req, res) => {
        if (req.cookies.userID) return res.redirect('/');
        res.render('auth/login');
    },
    login: async (req, res) => {
        try {
            const { username, password } = req.body;
            const user = await sequelize.query('CALL sp_Login (:pr_username, :pr_password)', {
                replacements: {
                    pr_username: username,
                    pr_password: password,
                },
            });
            res.cookie('userID', user[0].userid, {
                // expires: new Date(Date.now() + 900000),
            });
            return res.redirect('/');
        } catch (err) {
            res.status(400).json({ message: err.message });
        }
    },
    registerView: async (req, res) => {
        res.render('auth/register');
    },
    register: async (req, res) => {
        try {
            const { name, username, password, email, phone } = req.body;

            const newUser = await sequelize.query(
                'CALL sp_Register (:pr_username, :pr_password, :pr_name, :pr_email, :pr_phone)',
                {
                    replacements: {
                        pr_username: username,
                        pr_password: password,
                        pr_name: name,
                        pr_email: email,
                        pr_phone: phone,
                    },
                }
            );
            res.redirect('/auth/login');
        } catch (err) {
            res.status(400).json({ message: err.message });
        }
    },
    async logout(req, res) {
        res.clearCookie('userID');
        res.redirect('/');
    },
};
