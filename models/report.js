const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Reports = sequelize.define(
	"report",
	{
		reportid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			primaryKey: true,
		},
		reid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			references: {
				model: "posts",
				key: "reid",
			},
		},
		phone: {
			type: DataTypes.STRING(20),
			allowNull: true,
		},
		email: {
			type: DataTypes.STRING(255),
			allowNull: true,
		},
		contentrp: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		createdat: {
			type: DataTypes.DATE,
			allowNull: false,
			defaultValue: Sequelize.Sequelize.literal("CURRENT_TIMESTAMP"),
		},
	},
	{
		sequelize,
		tableName: "report",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "reportid" }],
			},
			{
				name: "reid",
				using: "BTREE",
				fields: [{ name: "reid" }],
			},
		],
	}
);

module.exports = Reports;
