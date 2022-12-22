const { Sequelize, Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Posts = require('./posts');

const savePosts = sequelize.define(
    'savePosts',
    {
        savePostId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            primaryKey: true,
        },
        createdat: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: Sequelize.Sequelize.literal('CURRENT_TIMESTAMP'),
        },
        reid: {
            type: DataTypes.CHAR(40),
            allowNull: false,
            references: {
                model: 'posts',
                key: 'reid',
            },
        },
        userid: {
            type: DataTypes.CHAR(40),
            allowNull: false,
            references: {
                model: 'users',
                key: 'userid',
            },
        },
    },
    {
        sequelize,
        tableName: 'savePosts',
        timestamps: false,
        indexes: [
            {
                name: 'PRIMARY',
                unique: true,
                using: 'BTREE',
                fields: [{ name: 'streetid' }],
            },
            {
                name: 'reid',
                using: 'BTREE',
                fields: [{ name: 'reid' }],
            },
            {
                name: 'userid',
                using: 'BTREE',
                fields: [{ name: 'userid' }],
            },
        ],
    }
);
savePosts.belongsTo(Posts, { foreignKey: 'reid' });
module.exports = savePosts;
