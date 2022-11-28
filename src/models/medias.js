const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Posts = require("./posts");

const Medias = sequelize.define(
	"medias",
	{
		mediaid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			primaryKey: true,
		},
		url: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		reid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			references: {
				model: "posts",
				key: "reid",
			},
		},
	},
	{
		sequelize,
		tableName: "medias",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "mediaid" }],
			},
			{
				name: "reid",
				using: "BTREE",
				fields: [{ name: "reid" }],
			},
		],
	}
);
module.exports = Medias;
