const sequelize = require('../config/database');
module.exports = {
    home: async (req, res) => {
        try {
            const posts = await sequelize.query(`CALL sp_get_post`);
            res.render('home/index', { posts: posts });
        } catch (err) {
            res.render('home/index', { toast: err.message });
        }
    },
    search: async (req, res) => {
        try {
            const { provinceid, districtid, wardid, streetid, projectid, keyword } = req.query;
            let posts;
            if (keyword && !provinceid && !districtid && !wardid && !streetid && !projectid) {
                if (!keyword) return;
                posts = await sequelize.query(`CALL sp_search_keyword(:pr_keyword)`, {
                    replacements: {
                        pr_keyword: keyword,
                    },
                });
            } else if (provinceid && !districtid && !wardid && !streetid) {
                posts = await sequelize.query(`CALL sp_Province_Posts(:pr_province_id)`, {
                    replacements: {
                        pr_province_id: provinceid,
                    },
                });
            } else if (provinceid && districtid && !wardid && !streetid) {
                posts = await sequelize.query(
                    `CALL sp_Province_District_Posts(:pr_province_id, :pr_district_id)`,
                    {
                        replacements: {
                            pr_province_id: provinceid,
                            pr_district_id: districtid,
                        },
                    }
                );
            } else if (provinceid && districtid && wardid && !streetid) {
                posts = await sequelize.query(
                    `CALL sp_Province_District_Ward_Posts(:pr_province_id, :pr_district_id , :pr_ward_id)`,
                    {
                        replacements: {
                            pr_province_id: provinceid,
                            pr_district_id: districtid,
                            pr_ward_id: wardid,
                        },
                    }
                );
            } else if (provinceid && districtid && wardid && streetid) {
                posts = await sequelize.query(
                    `CALL sp_Province_District_Ward_Street_Posts(:pr_province_id, :pr_district_id, :pr_ward_id, :pr_street_id)`,
                    {
                        replacements: {
                            pr_province_id: provinceid,
                            pr_district_id: districtid,
                            pr_ward_id: wardid,
                            pr_street_id: streetid,
                        },
                    }
                );
            } else if (provinceid && districtid && projectid && !wardid && !streetid) {
                posts = await sequelize.query(
                    `CALL sp_Project_Province_District(:pr_province_id, pr_district_id, pr_project_id)`,
                    {
                        replacements: {
                            pr_province_id: provinceid,
                            pr_district_id: districtid,
                            pr_project_id: projectid,
                        },
                    }
                );
            } else if (provinceid && projectid && !districtid && !wardid && !streetid) {
                posts = await sequelize.query(
                    `CALL sp_Project_Province(:pr_project_id,:pr_province_id) `,
                    {
                        replacements: {
                            pr_province_id: provinceid,
                            pr_project_id: projectid,
                        },
                    }
                );
            }
            if (!posts || !posts[0] || posts[0][0] === 0 || !posts[0] || !posts[0].reid) {
                return res.render('home/index', { posts: [] });
            }
            res.render('home/index', { posts: posts });
        } catch ({ message }) {
            res.render('home/index', { toast: message });
        }
    },
    error: async (req, res) => {
        const error = 'There is no error';
        res.render('error/index', { error: error });
    },
};
