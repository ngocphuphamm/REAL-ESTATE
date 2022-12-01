const sequelize = require('../config/database');

module.exports = {
    categories: async (req, res) => {
        let categories = await sequelize.query('SELECT * FROM categories', {
            type: sequelize.QueryTypes.SELECT,
        });
        res.status(200).json(categories.flat());
    },
    provinces: async (req, res) => {
        const provinces = await sequelize.query('SELECT * FROM province', {
            type: sequelize.QueryTypes.SELECT,
        });
        res.status(200).json(provinces.flat());
    },
    districts: async (req, res) => {
        const { provinceID } = req.query;
        const districts = await sequelize.query(
            `SELECT * FROM district WHERE provinceid = '${provinceID}'`,
            { type: sequelize.QueryTypes.SELECT }
        );
        res.status(200).json(districts.flat());
    },
    wards: async (req, res) => {
        const { districtID, provinceID } = req.query;
        const wards = await sequelize.query(
            `SELECT * FROM ward WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`,
            { type: sequelize.QueryTypes.SELECT }
        );
        res.status(200).json(wards.flat());
    },
    streets: async (req, res) => {
        const { districtID, provinceID } = req.query;
        const wards = await sequelize.query(
            `SELECT * FROM street WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`,
            { type: sequelize.QueryTypes.SELECT }
        );
        res.status(200).json(wards.flat());
    },
    projectsByProvince: async (req, res) => {
        const { provinceID } = req.query;
        const projects = await sequelize.query(
            `SELECT * FROM project WHERE provinceid = '${provinceID}'`,
            { type: sequelize.QueryTypes.SELECT }
        );
        res.status(200).json(projects.flat());
    },
    projectsByDistrictAndProvince: async (req, res) => {
        const { districtID, provinceID } = req.query;
        const projects = await sequelize.query(
            `SELECT * FROM project WHERE districtid = '${districtID}' AND provinceid = '${provinceID}'`,
            { type: sequelize.QueryTypes.SELECT }
        );
        res.status(200).json(projects.flat());
    },
};
