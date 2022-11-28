var DataTypes = require("sequelize").DataTypes;
var _categories = require("./categories");
var _comment = require("./comment");
var _convenient = require("./convenient");
var _district = require("./district");
var _medias = require("./medias");
var _posts = require("./posts");
var _project = require("./project");
var _province = require("./province");
var _report = require("./report");
var _street = require("./street");
var _users = require("./users");
var _ward = require("./ward");

function initModels(sequelize) {
  var categories = _categories(sequelize, DataTypes);
  var comment = _comment(sequelize, DataTypes);
  var convenient = _convenient(sequelize, DataTypes);
  var district = _district(sequelize, DataTypes);
  var medias = _medias(sequelize, DataTypes);
  var posts = _posts(sequelize, DataTypes);
  var project = _project(sequelize, DataTypes);
  var province = _province(sequelize, DataTypes);
  var report = _report(sequelize, DataTypes);
  var street = _street(sequelize, DataTypes);
  var users = _users(sequelize, DataTypes);
  var ward = _ward(sequelize, DataTypes);

  district.belongsToMany(district, { as: 'provinceid_districts', through: ward, foreignKey: "districtid", otherKey: "provinceid" });
  district.belongsToMany(district, { as: 'districtid_districts', through: ward, foreignKey: "provinceid", otherKey: "districtid" });
  posts.belongsTo(categories, { as: "category", foreignKey: "categoryid"});
  categories.hasMany(posts, { as: "posts", foreignKey: "categoryid"});
  project.belongsTo(district, { as: "district", foreignKey: "districtid"});
  district.hasMany(project, { as: "projects", foreignKey: "districtid"});
  project.belongsTo(district, { as: "province", foreignKey: "provinceid"});
  district.hasMany(project, { as: "province_projects", foreignKey: "provinceid"});
  street.belongsTo(district, { as: "district", foreignKey: "districtid"});
  district.hasMany(street, { as: "streets", foreignKey: "districtid"});
  street.belongsTo(district, { as: "province", foreignKey: "provinceid"});
  district.hasMany(street, { as: "province_streets", foreignKey: "provinceid"});
  ward.belongsTo(district, { as: "district", foreignKey: "districtid"});
  district.hasMany(ward, { as: "wards", foreignKey: "districtid"});
  ward.belongsTo(district, { as: "province", foreignKey: "provinceid"});
  district.hasMany(ward, { as: "province_wards", foreignKey: "provinceid"});
  comment.belongsTo(posts, { as: "re", foreignKey: "reid"});
  posts.hasMany(comment, { as: "comments", foreignKey: "reid"});
  convenient.belongsTo(posts, { as: "re", foreignKey: "reid"});
  posts.hasMany(convenient, { as: "convenients", foreignKey: "reid"});
  medias.belongsTo(posts, { as: "re", foreignKey: "reid"});
  posts.hasMany(medias, { as: "media", foreignKey: "reid"});
  report.belongsTo(posts, { as: "re", foreignKey: "reid"});
  posts.hasMany(report, { as: "reports", foreignKey: "reid"});
  posts.belongsTo(project, { as: "project", foreignKey: "projectid"});
  project.hasMany(posts, { as: "posts", foreignKey: "projectid"});
  district.belongsTo(province, { as: "province", foreignKey: "provinceid"});
  province.hasMany(district, { as: "districts", foreignKey: "provinceid"});
  posts.belongsTo(street, { as: "street", foreignKey: "streetid"});
  street.hasMany(posts, { as: "posts", foreignKey: "streetid"});
  comment.belongsTo(users, { as: "user", foreignKey: "userid"});
  users.hasMany(comment, { as: "comments", foreignKey: "userid"});
  posts.belongsTo(users, { as: "user", foreignKey: "userid"});
  users.hasMany(posts, { as: "posts", foreignKey: "userid"});
  posts.belongsTo(ward, { as: "ward", foreignKey: "wardid"});
  ward.hasMany(posts, { as: "posts", foreignKey: "wardid"});
  posts.belongsTo(ward, { as: "district", foreignKey: "districtid"});
  ward.hasMany(posts, { as: "district_posts", foreignKey: "districtid"});
  posts.belongsTo(ward, { as: "province", foreignKey: "provinceid"});
  ward.hasMany(posts, { as: "province_posts", foreignKey: "provinceid"});

  return {
    categories,
    comment,
    convenient,
    district,
    medias,
    posts,
    project,
    province,
    report,
    street,
    users,
    ward,
  };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
