const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Wards = sequelize.define(
	"ward",
	{
		wardid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			primaryKey: true,
		},
		nameward: {
			type: DataTypes.STRING(50),
			allowNull: true,
		},
		prefixward: {
			type: DataTypes.STRING(20),
			allowNull: true,
		},
		districtid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			primaryKey: true,
			references: {
				model: "district",
				key: "districtid",
			},
		},
		provinceid: {
			type: DataTypes.INTEGER,
			allowNull: false,
			primaryKey: true,
			references: {
				model: "district",
				key: "provinceid",
			},
		},
	},
	{
		sequelize,
		tableName: "ward",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [
					{ name: "wardid" },
					{ name: "districtid" },
					{ name: "provinceid" },
				],
			},
			{
				name: "districtid",
				using: "BTREE",
				fields: [{ name: "districtid" }, { name: "provinceid" }],
			},
		],
	}
);

module.exports = Wards;
