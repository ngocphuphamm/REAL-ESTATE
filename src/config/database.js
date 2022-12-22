const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('bds', 'root', '123456@', {
    host: '194.163.180.21',
    port: 13306,
    dialect: 'mysql',
});

module.exports = sequelize;
