const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('district', {
    districtid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    provinceid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      references: {
        model: 'province',
        key: 'provinceid'
      }
    },
    namedistrict: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    prefixdistrict: {
      type: DataTypes.STRING(20),
      allowNull: true
    }
  }, {
    sequelize,
    tableName: 'district',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "districtid" },
          { name: "provinceid" },
        ]
      },
      {
        name: "provinceid",
        using: "BTREE",
        fields: [
          { name: "provinceid" },
        ]
      },
    ]
  });
};
