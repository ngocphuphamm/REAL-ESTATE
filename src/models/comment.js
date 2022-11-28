const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Users = require("./users");

const Comments = sequelize.define(
	"comment",
	{
		commentid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			primaryKey: true,
		},
		createdat: {
			type: DataTypes.DATE,
			allowNull: false,
			defaultValue: Sequelize.Sequelize.literal("CURRENT_TIMESTAMP"),
		},
		content: {
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
		userid: {
			type: DataTypes.CHAR(40),
			allowNull: false,
			references: {
				model: "users",
				key: "userid",
			},
		},
	},
	{
		sequelize,
		tableName: "comment",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "commentid" }],
			},
			{
				name: "reid",
				using: "BTREE",
				fields: [{ name: "reid" }],
			},
			{
				name: "userid",
				using: "BTREE",
				fields: [{ name: "userid" }],
			},
		],
	}
);
Comments.belongsTo(Users, { foreignKey: "userid" });
module.exports = Comments;
