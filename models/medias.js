const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('medias', {
    mediaid: {
      type: DataTypes.CHAR(40),
      allowNull: false,
      primaryKey: true
    },
    url: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    reid: {
      type: DataTypes.CHAR(40),
      allowNull: false,
      references: {
        model: 'posts',
        key: 'reid'
      }
    }
  }, {
    sequelize,
    tableName: 'medias',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "mediaid" },
        ]
      },
      {
        name: "reid",
        using: "BTREE",
        fields: [
          { name: "reid" },
        ]
      },
    ]
  });
};
