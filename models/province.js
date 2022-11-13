const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('province', {
    provinceid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    nameprovince: {
      type: DataTypes.STRING(50),
      allowNull: true
    },
    codeprovince: {
      type: DataTypes.STRING(20),
      allowNull: true
    }
  }, {
    sequelize,
    tableName: 'province',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "provinceid" },
        ]
      },
    ]
  });
};
