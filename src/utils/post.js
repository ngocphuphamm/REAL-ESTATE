const sequelize = require('../config/database');
const Posts = require('../models/posts');
const Medias = require('../models/medias');

module.exports = {
    excPost: async ({
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
        userID,
        files,
    }) => {
        const user = await sequelize.query(`SELECT * FROM users WHERE userid = '${userID}'`, {
            type: sequelize.QueryTypes.SELECT,
        });
        const newPost = await sequelize.query(
            `CALL sp_postFeed (:pr_categoryid, :pr_title, :pr_description,
                  :pr_price, :pr_area, :pr_phone , :pr_address, :pr_userid,
                  :pr_projectid, :pr_streetid , :pr_wardid, :pr_districtid,
                  :pr_provinceid,:pr_bedroom, :pr_bathroom,:pr_floor, 
                  :pr_direction, :pr_balconyDirection, :pr_furniture, :pr_fontageArea, :pr_firstImage , :pr_secondImage , :pr_thirdImage)`,
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
                    pr_projectid: projectid == 0 ? null : projectid,
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
                    pr_firstImage: files[0].path,
                    pr_secondImage: files[1].path,
                    pr_thirdImage: files[2].path,
                },
            }
        );
    },
    getListPostOfUser: async (userID) => {
        const posts = await Posts.findAll({
            where: {
                userid: userID,
                rented: 0,
            },
            include: [Medias],
        });
        const rentedPosts = await Posts.findAll({
            where: {
                userid: userID,
                rented: 1,
            },
            include: [Medias],
        });
        return { posts, rentedPosts };
    },
};
