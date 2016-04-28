//server.js

var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mongoose   = require('mongoose');
mongoose.connect('mongodb://heroku_qh2b8v0v:a82n9agad4vl158c0u8atbs3cf@ds021741.mlab.com:21741/heroku_qh2b8v0v'); // connect to our database

var Resource = require('./app/models/resource');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;

var router = express.Router();

router.use(function(req, res, next) {
	console.log("Sittin', Waitin', Wishin'");
	next();
});

router.route( '/resources')
	.post(function(req, res) {
		var r = new Resource();
		r.name = req.body.name;
		r.url = req.body.url;
		r.summary = req.body.summary
		if(req.body.is_swift != undefined) {
			if(req.body.is_swift) r.is_swift = true;
			else r.is_swift = false;
		} else {
			r.is_swift = false;
		}

		r.save(function(err) {
			if(err)
				res.send(err);
			res.json({message: 'Resource created'});
		});
	})
	.get(function(req, res) {
		Resource.find(function(err, resources) {
			if(err)
				res.send(err)

			res.send(resources)
		});
	});

router.get('/', function(req, res) {
	res.json({message: "horrary"});
});

app.use('/api', router);

app.listen(port);
console.log('Magic is happening on port ' + port);