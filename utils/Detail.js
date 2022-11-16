const sequelize = require("../config/database");

const getDetail = async (id) => {
	const convenients = await sequelize.query(
		"CALL sp_get_convenient(:pr_reid)",
		{
			replacements: {
				pr_reid: id,
			},
		}
	);
	const detail = await sequelize.query(
		"CALL sp_show_detail_info(:pr_reid)",
		{
			replacements: {
				pr_reid: id,
			},
		}
	);
	const medias = await sequelize.query("CALL sp_get_listMedias(:pr_reid)", {
		replacements: {
			pr_reid: id,
		},
	});
	return {
		convenients: convenients[0],
		detail: detail[0],
		medias,
	};
};

module.exports = getDetail;
