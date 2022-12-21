const mainRoute = require('../routes/index');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const express = require('express');
const app = express();
const { PORT } = require('../config/env');
const compression = require('compression');
const methodOverride = require('method-override');

module.exports = () => {
    app.use(methodOverride('_method'));
    app.use(logger('dev'));
    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use(cookieParser());
    app.set('view engine', 'pug');
    app.use('/public', express.static('public'));
    app.use('/', mainRoute);
    app.use(compression());

    app.listen(PORT, () =>
        console.log(`HB Real-Estate service listening on http://localhost:${PORT}`)
    );
};
