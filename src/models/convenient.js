const { Sequelize, Model, DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Convenients = sequelize.define(
	"convenient",
	{
		convenientid: {
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
		bedroom: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		bathroom: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		floor: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		direction: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		balconyDirection: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		furniture: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		fontageArea: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		createdat: {
			type: DataTypes.DATE,
			allowNull: false,
			defaultValue: Sequelize.Sequelize.literal("CURRENT_TIMESTAMP"),
		},
		updatedat: {
			type: DataTypes.DATE,
			allowNull: true,
		},
	},
	{
		sequelize,
		tableName: "convenient",
		timestamps: false,
		indexes: [
			{
				name: "PRIMARY",
				unique: true,
				using: "BTREE",
				fields: [{ name: "convenientid" }],
			},
			{
				name: "reid",
				using: "BTREE",
				fields: [{ name: "reid" }],
			},
		],
	}
);

module.exports = Convenients;
