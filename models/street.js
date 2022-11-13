const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Streets = sequelize.define(
	"street",
	{
		streetid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			primaryKey: true,
		},
		districtid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			references: {
				model: "district",
				key: "districtid",
			},
		},
		provinceid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			references: {
				model: "district",
				key: "provinceid",
			},
		},
		namestreet: {
			type: DataTypes.STRING(100),
			allowNull: true,
		},
		prefixstreet: {
			type: DataTypes.STRING(20),
			allowNull: true,
		},
	},
	{
		sequelize,
		tableName: "street",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "streetid" }],
			},
			{
				name: "districtid",
				using: "BTREE",
				fields: [{ name: "districtid" }, { name: "provinceid" }],
			},
		],
	}
);

module.exports = Streets;
