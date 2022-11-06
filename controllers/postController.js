const sequelize = require("../config/database");

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
				displayDistrict,
				price,
				area,
				address,
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
					 :pr_displayDistrict , :pr_price , :pr_area , :pr_phone , :pr_address , :pr_lat , :pr_lng , :pr_userid ,
					  :pr_projectid , :pr_streetid , :pr_wardid , :pr_districtid , :pr_provinceid , :pr_bedroom , :pr_bathroom ,
					  :pr_floor , :pr_direction , :pr_balconyDirection , :pr_furniture ,:pr_fontageArea)`,
				{
					replacements: {
						pr_categoryid: categoryid,
						pr_title: title,
						pr_description: description,
						pr_displayDistrict: displayDistrict,
						pr_price: price,
						pr_area: area,
						pr_phone: user[0].phone,
						pr_address: address,
						pr_lat: 123,
						pr_lng: 123,
						pr_userid: user[0].userid,
						pr_projectid: projectid,
						pr_streetid: streetid,
						pr_wardid: wardid,
						pr_districtid: districtid,
						pr_provinceid: provinceid,
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
			res.status(200).json({ success: true });
		} catch (err) {
			res.status(400).json({ message: err.message });
		}
	},
	postDetail: async (req, res) => {},
};
