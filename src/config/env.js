require("dotenv").config();
const env = process.env;

const envConf = (env) => {
	return {
		PORT: 3000 || env.PORT,
	};
};

module.exports = envConf(env);
