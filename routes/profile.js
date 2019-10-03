const db = require('../config/mysql')();
const fs = require('fs');

module.exports = function (app) {

	app.use('/profile', (req, res, next) => {
		if (!req.session.user) {
			res.redirect('/login');
			return;
		} else {
			next();
		}
	});

	//se egne opskrifter via profilsiden
	app.get('/profile', (req, res, next) => {
		
		db.query('SELECT * FROM users WHERE id = ?', [req.session.user], (err, userinfo) => {
			if (err) return next(`${err} at db.query (${__filename}:15:5)`);
			db.query(`SELECT id, description, recipes.procedure, published FROM recipes WHERE author = ?`, [req.session.user], (err, recipes) => {
				if (err) return res.send(err);
				console.log(recipes);
				res.render('profile', {'title': 'Opskrifter', 'recipes': recipes, 'user': userinfo[0] } );
			});
		});
	});

    //Her skal man kunne slette en opskrift på sin profil
	app.delete('/profile/:id', function (req, res, next) {
        db.query(`DELETE FROM recipes WHERE id = ?`, [req.params.id], function(err, results) {
            if (err) return res.send(err);
            res.status(200);
            res.end();
        });
    });

	app.patch('/profile', (req, res, next) => {
		db.query('UPDATE profiles SET firstname = ?, lastname = ?, bio = ? WHERE users_id = ?', [req.fields.firstname, req.fields.lastname, req.fields.bio, req.session.user], (err, result) => {
			if (err) return next(`${err} at db.query (${__filename}:23:5)`);
			res.status(204);
			res.end();
		})
	});

	app.patch('/profile/image', (req, res, next) => {
		if (!req.files || !req.files.photo) {
			return next(`File not found (${__filename}:29:5)`);
		}
		const file = req.files.photo;
		const renamedFilename = `${Date.now()}_${file.name}`;
		fs.readFile(file.path, (err, data) => {
			if (err) return next(`${err} at fs.readFile (${__filename}:35:5)`);
			fs.writeFile(`./public/uploads/${renamedFilename}`, data, err => {
				if (err) return next(`${err} at fs.writeFile (${__filename}:37:7)`);
				db.query('INSERT INTO photos SET name = ?', [renamedFilename], (err, result) => {
					if (err) return next(`${err} at db.query (${__filename}:39:9)`);
					db.query('UPDATE profiles SET photos_id = ? WHERE users_id = ?', [result.insertId, req.session.user], (err, result) => {
						if (err) return next(`${err} at db.query (${__filename}:41:11)`);
						res.status(200);
						res.json({
							photo: renamedFilename
						});
					});
				});
			});
		});
	});

};
