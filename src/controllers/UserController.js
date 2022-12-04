const Users = require('../models/users');
const sequelize = require('../config/database');
const SavePosts = require('../models/savePosts');
const Posts = require('../models/posts');
const Medias = require('../models/medias');

module.exports = {
    detail: async (req, res) => {
        try {
            const { userID } = req.params;
            const user = await Users.findByPk(userID, { raw: true });
            res.render('user/index', { user });
        } catch (err) {
            res.render('user/index', { toast: err.message });
        }
    },
    detailApi: async (req, res) => {
        try {
            const { userID } = req.params;
            const user = await Users.findByPk(userID, { raw: true });
            res.status(200).json({ success: true, body: user });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
        }
    },
    edit: async (req, res) => {
        try {
            const { name, phone } = req.body;
            const { userID } = req.params;
            const user = await sequelize.query(
                `CALL sp_Edit_User(:pr_userid ,:pr_name , :pr_phone)`,
                {
                    replacements: {
                        pr_userid: userID,
                        pr_name: name,
                        pr_phone: phone,
                    },
                }
            );
            res.render('user/index', {
                user: user[0],
                toast: 'Cập nhật thông tin thành công',
            });
        } catch (err) {
            res.render('error/index', {
                error: err.message,
            });
        }
    },
    myPost: async (req, res) => {
        try {
            const { userID } = req.params;
            const posts = await Posts.findAll({
                where: {
                    userid: userID,
                    rented: 0,
                },
                include: [Medias],
            });
            res.render('user/mypost', { posts: posts });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
        }
    },
    updateRentedPost: async (req, res) => {
        const { userID } = req.params;
        const { postID } = req.body;
        const posts = await Posts.findAll({
            where: {
                userid: userID,
                rented: 0,
            },
            include: [Medias],
        });

        try {
            await sequelize.query(`CALL sp_update_status_post (:pr_id_user , :pr_id_post)`, {
                replacements: {
                    pr_id_user: userID,
                    pr_id_post: postID,
                },
            });

            res.render('user/mypost', {
                posts,
                toast: 'Cập nhật trạng thái post thành công',
            });
        } catch (err) {
            res.render('user/mypost', { posts, toast: err.message });
        }
    },
    bookmark: async (req, res) => {
        try {
            const { userID } = req.params;
            const arrPost = [];
            const bookmark = await SavePosts.findAll({
                where: {
                    userid: userID,
                },
                include: [{ model: Posts, include: [Medias] }],
            });
            bookmark.forEach((book) => {
                const post = book.dataValues.post;
                arrPost.push(post);
            });
            res.render('user/bookmark', { posts: arrPost });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
        }
    },
};
