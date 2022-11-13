const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('project', {
    projectid: {
      type: DataTypes.CHAR(20),
      allowNull: false,
      primaryKey: true
    },
    districtid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'district',
        key: 'districtid'
      }
    },
    provinceid: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'district',
        key: 'provinceid'
      }
    },
    nameproject: {
      type: DataTypes.STRING(200),
      allowNull: true
    },
    lat: {
      type: DataTypes.DOUBLE,
      allowNull: true
    },
    lng: {
      type: DataTypes.DOUBLE,
      allowNull: true
    }
  }, {
    sequelize,
    tableName: 'project',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "projectid" },
        ]
      },
      {
        name: "districtid",
        using: "BTREE",
        fields: [
          { name: "districtid" },
          { name: "provinceid" },
        ]
      },
    ]
  });
};
