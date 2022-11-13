const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Categories = sequelize.define(
	"categories",
	{
		categoryid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			primaryKey: true,
		},
		name: {
			type: DataTypes.STRING(255),
			allowNull: false,
		},
	},
	{
		sequelize,
		tableName: "categories",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "categoryid" }],
			},
		],
	}
);
