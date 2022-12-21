const sequelize = require('../config/database');
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
                  :pr_direction, :pr_balconyDirection, :pr_furniture, :pr_fontageArea)`,
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
                },
            }
        );
        if (files.length > 0) {
            files.forEach(async (file) => {
                await sequelize.query(`CALL sp_insert_medias (:pr_reid, :pr_url)`, {
                    replacements: {
                        pr_reid: newPost[0].id_post,
                        pr_url: file.path,
                    },
                });
            });
        }
    },
};
