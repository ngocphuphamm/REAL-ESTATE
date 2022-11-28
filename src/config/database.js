const { Sequelize } = require("sequelize");
const sequelize = new Sequelize("BDS", "root", "123456", {
	host: "localhost",
	dialect: "mysql",
});

module.exports = sequelize;
