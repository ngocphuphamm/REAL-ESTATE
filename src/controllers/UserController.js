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
            res.status(200).json({ success: true, body: user });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
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
            res.render('post/bookmark', { posts: arrPost });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
        }
    },
};
