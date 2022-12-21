const sequelize = require('../config/database');
const moment = require('moment');
const Comments = require('../models/comment');
const Users = require('../models/users');
const getDetail = require('../utils/detail');
const { excPost } = require('../utils/post');
module.exports = {
    postView: async (req, res) => {
        res.render('post/index');
    },
    uploadPost: async (req, res) => {
        try {
            const {
                categoryid,
                title,
                description,
                price,
                area,
                address,
                phone,
                projectid,
                streetid,
                wardid,
                districtid,
                provinceid,
                bedroom,
                bathroom,
                floor,
                direction,
                balconyDirection,
                furniture,
                fontageArea,
            } = req.body;
            const models = {
                categoryid,
                title,
                description,
                price,
                area,
                address,
                phone,
                projectid,
                streetid,
                wardid,
                districtid,
                provinceid,
                bedroom,
                bathroom,
                floor,
                direction,
                balconyDirection,
                furniture,
                fontageArea,
                userID: req.cookies.userID,
                files: req.files,
            };
            await excPost(models);
            res.redirect('/');
        } catch (err) {
            res.status(400).json({ message: err.message });
        }
    },
    detail: async (req, res) => {
        try {
            const { id } = req.params;
            const post = await getDetail(id);
            res.render('post/detail', {
                post,
                moment,
            });
        } catch (err) {
            res.status(400).json({ message: err.message });
        }
    },
    sendBookMark: async (req, res) => {
        try {
            const { reid, userid } = req.body;
            if (!reid || !userid) throw new Error('Bạn càn phải đăng nhập để lưu tin');
            const sendBookmark = await sequelize.query('CALL sp_savePosts(:pr_reid , :pr_userid)', {
                replacements: {
                    pr_reid: reid,
                    pr_userid: userid,
                },
            });
            res.status(200).json(sendBookmark);
        } catch (err) {
            res.status(400).json({ message: err.message });
        }
    },
    addComment: async (req, res) => {
        try {
            const { id } = req.params;
            const { userid, content } = req.body;
            if (!id || !userid || !content) throw new Error('Bạn cần phải đăng nhập để bình luận');
            const sendComment = await sequelize.query(
                'CALL sp_Comment(:pr_reid , :pr_userid , :pr_content)',
                {
                    replacements: {
                        pr_reid: id,
                        pr_userid: userid,
                        pr_content: content,
                    },
                }
            );
            res.status(200).json({ success: true, body: sendComment });
        } catch (err) {
            res.status(400).json({ success: false, message: err.message });
        }
    },
    sendReport: async (req, res) => {
        const { id } = req.params;
        const { email, phone, content } = req.body;
        if (!id || !email || !phone || !content)
            return res.render('post/detail', { post, moment, comments, toast: err.message });
        const post = await getDetail(id);
        const comments = await Comments.findAll({
            include: Users,
        });
        try {
            const report = await sequelize.query(
                `CALL sp_Report(:pr_reid , :pr_phone , :pr_email , :pr_contentrp)`,
                {
                    replacements: {
                        pr_reid: id,
                        pr_email: email,
                        pr_phone: phone,
                        pr_contentrp: content,
                    },
                }
            );
            const response = report[0];
            if (response[0] === 0) {
                return res.render('post/detail', {
                    post,
                    moment,
                    comments,
                    toast: 'Nội dung tố cáo quá ngắn hoặc người dùng đã gửi tố cáo',
                });
            }
            res.render('post/detail', {
                post,
                moment,
                comments,
                toast: 'Tố cáo thành công !',
            });
        } catch (err) {
            res.render('post/detail', { post, moment, comments, toast: err.message });
        }
    },
};
