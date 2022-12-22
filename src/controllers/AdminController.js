const sequelize = require('../config/database');

module.exports = {
    user: async (req, res) => {
        try {
            const { userID } = req.cookies;
            const users = await sequelize.query(
                `SELECT * FROM users WHERE userid NOT LIKE '${userID}'`
            );
            res.render('admin/user', { users: users[0] });
        } catch (err) {
            res.render('admin/user', { toast: err.message });
        }
    },
    post: async (req, res) => {
        try {
            const posts = await sequelize.query(`SELECT * FROM posts`);
            res.render('admin/post', { posts: posts[0] });
        } catch (err) {
            res.render('admin/user', { toast: err.message });
        }
    },
    blockUser: async (req, res) => {
        try {
            const { userID } = req.cookies;
            const { userToBlock, userToRecovery } = req.body;
            let spName;
            if (userToBlock && !userToRecovery) {
                spName = `sp_block_user`;
            } else {
                spName = `sp_recovery_user`;
            }
            if (!spName) return res.render('admin/user', { toast: err.message });
            await sequelize.query(`CALL ${spName}(:pr_id_user , :pr_id_user_block)`, {
                replacements: {
                    pr_id_user: userID,
                    pr_id_user_block: spName === 'sp_block_user' ? userToBlock : userToRecovery,
                },
            });
            res.redirect('/admin/user');
        } catch (err) {
            res.render('admin/user', { toast: err.message });
        }
    },
    blockPost: async (req, res) => {
        try {
            const { userID } = req.cookies;
            const { postToBlock, postToRecovery } = req.body;
            let spName;
            if (postToBlock && !postToRecovery) {
                spName = `sp_bans_post`;
            } else {
                spName = `sp_recovery_post`;
            }
            if (!spName) return res.render('admin/user', { toast: err.message });
            await sequelize.query(`CALL ${spName}(:pr_id_user , :pr_id_post)`, {
                replacements: {
                    pr_id_user: userID,
                    pr_id_post: spName === 'sp_bans_post' ? postToBlock : postToRecovery,
                },
            });
            return res.redirect('/admin/post');
        } catch (err) {
            res.render('admin/post', { toast: err.message });
        }
    },
};
