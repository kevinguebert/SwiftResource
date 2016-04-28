//server.js

var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mongoose   = require('mongodb');
var ObjectID = mongo.ObjectID;
// Create a database variable outside of the database connection callback to reuse the connection pool in your app.
var db;

// Connect to the database before starting the application server.
mongodb.MongoClient.connect(process.env.MONGODB_URI, function (err, database) {
  if (err) {
    console.log(err);
    process.exit(1);
  }

  // Save database object from the callback for reuse.
  db = database;
  console.log("Database connection ready");

  // Initialize the app.
  var server = app.listen(process.env.PORT || 8080, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
  });
});

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