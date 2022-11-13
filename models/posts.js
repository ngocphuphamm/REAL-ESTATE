const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"posts",
		{
			reid: {
				type: DataTypes.CHAR(40),
				allowNull: false,
				primaryKey: true,
			},
			categoryid: {
				type: DataTypes.CHAR(40),
				allowNull: false,
				references: {
					model: "categories",
					key: "categoryid",
				},
			},
			title: {
				type: DataTypes.STRING(255),
				allowNull: false,
			},
			description: {
				type: DataTypes.TEXT,
				allowNull: false,
			},
			price: {
				type: DataTypes.DECIMAL(15, 2),
				allowNull: false,
			},
			area: {
				type: DataTypes.STRING(100),
				allowNull: false,
			},
			viewCount: {
				type: DataTypes.INTEGER,
				allowNull: false,
				defaultValue: 0,
			},
			approve: {
				type: DataTypes.BOOLEAN,
				allowNull: false,
				defaultValue: 0,
			},
			phone: {
				type: DataTypes.STRING(20),
				allowNull: false,
			},
			address: {
				type: DataTypes.STRING(255),
				allowNull: false,
			},
			rented: {
				type: DataTypes.BOOLEAN,
				allowNull: false,
				defaultValue: 0,
			},
			createdat: {
				type: DataTypes.DATE,
				allowNull: false,
				defaultValue:
					Sequelize.Sequelize.literal("CURRENT_TIMESTAMP"),
			},
			updatedat: {
				type: DataTypes.DATE,
				allowNull: true,
			},
			userid: {
				type: DataTypes.CHAR(40),
				allowNull: false,
				references: {
					model: "users",
					key: "userid",
				},
			},
			projectid: {
				type: DataTypes.CHAR(20),
				allowNull: true,
				references: {
					model: "project",
					key: "projectid",
				},
			},
			streetid: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "street",
					key: "streetid",
				},
			},
			wardid: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "ward",
					key: "wardid",
				},
			},
			districtid: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "ward",
					key: "districtid",
				},
			},
			provinceid: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "ward",
					key: "provinceid",
				},
			},
		},
		{
			sequelize,
			tableName: "posts",
			timestamps: false,
			indexes: [
				{
					name: "PRIMARY",
					unique: true,
					using: "BTREE",
					fields: [{ name: "reid" }],
				},
				{
					name: "userid",
					using: "BTREE",
					fields: [{ name: "userid" }],
				},
				{
					name: "categoryid",
					using: "BTREE",
					fields: [{ name: "categoryid" }],
				},
				{
					name: "wardid",
					using: "BTREE",
					fields: [
						{ name: "wardid" },
						{ name: "districtid" },
						{ name: "provinceid" },
					],
				},
				{
					name: "projectid",
					using: "BTREE",
					fields: [{ name: "projectid" }],
				},
				{
					name: "streetid",
					using: "BTREE",
					fields: [{ name: "streetid" }],
				},
			],
		}
	);
};
