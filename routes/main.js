module.exports = function (app) {
	app.get('/', (req, res, next) => {
		res.render('page', { title: 'Hello, World!', content: '' });
	});
};
