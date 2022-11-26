const sequelize = require("../config/database");
const moment = require("moment");
const Comments = require("../models/comment");
const Posts = require("../models/posts");
const Users = require("../models/users");
const getDetail = require("../utils/Detail");
const Toast = require("../utils/Toast");
module.exports = {
	postView: async (req, res) => {
		res.render("post/index");
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
			const { userID } = req.cookies;
			const user = await sequelize.query(
				`SELECT * FROM users WHERE userid = '${userID}'`,
				{ type: sequelize.QueryTypes.SELECT }
			);
			const newPost = await sequelize.query(
				`CALL sp_postFeed (:pr_categoryid, :pr_title , :pr_description ,
					  :pr_price , :pr_area , :pr_phone , :pr_address, :pr_userid ,
					  :pr_projectid , :pr_streetid , :pr_wardid , :pr_districtid , :pr_provinceid)`,
				{
					replacements: {
						pr_categoryid: categoryid,
						pr_title: title,
						pr_description: description,
						pr_price: price,
						pr_area: area,
						pr_phone: phone,
						pr_address: address,
						pr_userid: user[0].userid,
						pr_projectid: projectid,
						pr_streetid: streetid,
						pr_wardid: wardid,
						pr_districtid: districtid,
						pr_provinceid: provinceid,
					},
				}
			);

			await sequelize.query(
				`CALL sp_insert_convenient (:pr_reid , :pr_bedroom , :pr_bathroom ,
					  :pr_floor , :pr_direction , :pr_balconyDirection , :pr_furniture ,:pr_fontageArea)`,
				{
					replacements: {
						pr_reid: newPost[0].id_post,
						pr_bedroom: bedroom,
						pr_bathroom: bathroom,
						pr_floor: floor,
						pr_direction: direction,
						pr_balconyDirection: balconyDirection,
						pr_furniture: furniture,
						pr_fontageArea: fontageArea,
					},
				}
			);
			if (req.files.length > 0) {
				req.files.forEach(async (file) => {
					await sequelize.query(
						`CALL sp_insert_medias (:pr_reid, :pr_url)`,
						{
							replacements: {
								pr_reid: newPost[0].id_post,
								pr_url: file.path,
							},
						}
					);
				});
			}

			res.redirect("/");
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	detail: async (req, res) => {
		try {
			const { id } = req.params;
			const post = await getDetail(id);
			const comments = await Comments.findAll({
				include: Users,
			});
			res.render("post/detail", {
				post,
				moment,
				comments,
			});
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	sendBookMark: async (req, res) => {
		try {
			const { reid, userid } = req.body;
			const sendBookmark = await sequelize.query(
				"CALL sp_savePosts(:pr_reid , :pr_userid)",
				{
					replacements: {
						pr_reid: reid,
						pr_userid: userid,
					},
				}
			);
			res.status(200).json(sendBookmark);
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	addComment: async (req, res) => {
		try {
			const { id } = req.params;
			const { userid, content } = req.body;
			const sendComment = await sequelize.query(
				"CALL sp_Comment(:pr_reid , :pr_userid , :pr_content)",
				{
					replacements: {
						pr_reid: id,
						pr_userid: userid,
						pr_content: content,
					},
				}
			);
			res.status(200).json(sendComment);
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	sendReport: async (req, res) => {
		try {
			const { id } = req.params;
			const { email, phone, content } = req.body;

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
			if (report[0][0] === 0) {
				res.render("error/index", {
					error: "Nội dung tố cáo quá ngắn",
				});
			} else if (report[0][1] === 1) {
				res.render("error/index", {
					error: "Bạn đã tố cáo bài viết này rồi",
				});
			} else {
				res.redirect(`/post/${id}`);
			}
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
};
