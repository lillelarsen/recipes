const db = require('../config/mysql')();
const fs = require('fs');

module.exports = function (app) {
    app.get('/update-recipe/:id', (req, res, next) => {
        console.log(req.data);
        db.query(`SELECT id, description, recipes.procedure, published FROM recipes WHERE id = ?`,[req.params.id], (err, results) => {
			if (err) return res.send(err);

			//Henter data frem fra databasen ingredients
			db.query(`SELECT id, name, amount, measure, recipes_id FROM ingredients WHERE recipes_id = ?`,[req.params.id], (err, ingredients) => {
				if (err) return res.send(err);
				res.render('update-recipe', { title: 'Hello, World!', 'recipe': results[0] , 'ingredients': ingredients });
			});
		});
	});

    //Her skal men kunne redigere sine opskrifter
    app.patch('/update-recipe/:id', (req, res) => {
		db.query(`UPDATE recipes SET description = ?, recipes.procedure = ?, published = ? WHERE id = ?`,
		[req.fields.opskrift, req.fields.procedure, req.fields.udgivet, req.params.id], (err, results) => {
			if (err) return res.send(err);
			//Opdatere data

			let ingredients = [];
			for (x in req.fields.ingredients) {
				ingredients.push(req.fields[x]);
			};
			console.log(req.fields);
		ingredients.forEach(record => {
			db.query(`UPDATE ingredients SET name = ?, amount = ?, measure = ? WHERE id = ?`,
			[ingredients[0]].id, (err, results) => {
				if (err) return res.send(err);
				res.status(200);
				res.end();
			});
		});
		});
	});

	app.get('/recipes', (req, res, next) => {
		res.render('recipes', { title: 'Opskrifter!', content: '' });
	});

	app.get('/add-recipe', (req, res, next) => {
		res.render('add-recipe', { title: 'Opskrifter!', content: 'Opret en opskrift' });
	});

	app.post('/add-recipe', function (req, res, next) {

		db.query(`INSERT INTO recipes (description, recipes.procedure, published, author) VALUES (?, ?, ?, ?)`,
		[req.fields.description, req.fields.procedure, parseInt(req.fields.publish), req.session.user], async (err, result) => {
			if (err) return next(err);
			console.log(req.fields);
			function ingredients() {
				return new Promise((resolve, reject) => {
					let records = [];
					for (x in req.fields) {
					if (x.substr(0, 4) == 'ingr') {
						records.push(req.fields[x]);
						}
					};
					
					records.forEach(record => {
						console.log(record);
						db.execute(`INSERT INTO ingredients SET name = ?, amount = ?, measure = ?, recipes_id = ?`,
						[record[0], record[1], record[2], result.insertId], (err, results, next) => {
							if (err) return next(err);
							resolve();
						});
					});
				});
			};

			function images() {
				return new Promise((resolve, reject) => {
					let imagelist = [];

					for (x in req.files.images) {
							imagelist.push(req.files.images[x]);
					};
					//const imgDefault = 'default.jpg';

					// if (imagelist == '') {
					// 	db.query(`INSERT INTO photos SET name = ?`, [imgDefault], (err, results, next) => {
					// 		if (err) return res.send(err);
					// 		resolve();
					// 	});
					// } else {
					imagelist.forEach(image => {
						const file = image.name;
						const renamedFilename = `${Date.now()}_${file}`;
						console.log(renamedFilename);
						db.query(`INSERT INTO photos SET name = ?`, [renamedFilename], (err, results, next) => {
							if (err) {return next(err);}
							fs.readFile(image.path, (err, data) => {
								if (err) {
									return next(new Error('Den midlertidige fil kunne ikke læses'));
								}
								fs.writeFile(`./public/uploads/${renamedFilename}`, data, (err) => {
									if (err) {
										return next(new Error('Filen kunne ikke gemmes'));
									}
									resolve();
								});
							});
						});
					});
				//	}
				});
			};
			await Promise.all([ingredients(), images()]);
			res.redirect(await 'profile');
		});
	});
	
};
