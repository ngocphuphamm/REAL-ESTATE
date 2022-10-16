const { Sequelize } = require("sequelize");
const sequelize = new Sequelize("real_estate", "root", "123456", {
	host: "localhost",
	dialect: "mysql",
});

module.exports = sequelize;
