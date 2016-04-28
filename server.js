//server.js

var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mongodb = require('mongodb');
var ObjectID = mongodb.ObjectID;
// Create a database variable outside of the database connection callback to reuse the connection pool in your app.

var RESOURCES_COLLECTION = "resources";
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

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var router = express.Router();

function handleError(res, reason, message, code) {
  console.log("ERROR: " + reason);
  res.status(code || 500).json({"error": message});
}

router.use(function(req, res, next) {
	console.log("Sittin', Waitin', Wishin'");
	next();
});

router.route( '/resources')
	.post(function(req, res) {
		var r = req.body;

		r.createDate = new Date();
		 // if (!(req.body.firstName || req.body.lastName)) {
		 //    handleError(res, "Invalid user input", "Must provide a first or last name.", 400);
		 //  }

		db.collection(RESOURCES_COLLECTION).insertOne(r, function(err, doc) {
			if(err) {
				handleError(res, err.message, "Failed to create new resource.");
			} else {
				res.status(201).json(doc.ops[0]);
			}
		});
		// r.name = req.body.name;
		// r.url = req.body.url;
		// r.summary = req.body.summary
		// if(req.body.is_swift != undefined) {
		// 	if(req.body.is_swift) r.is_swift = true;
		// 	else r.is_swift = false;
		// } else {
		// 	r.is_swift = false;
		// }

		// r.save(function(err) {
		// 	if(err)
		// 		res.send(err);
		// 	res.json({message: 'Resource created'});
		// });
	})
	.get(function(req, res) {
		db.collection(RESOURCES_COLLECTION).find({}).toArray(function(err, docs) {
			if(err) {
				handleError(res, err.message, "Failed to get contacts.");
			} else {
				res.status(200).json(docs);
			}
		})
	});

router.get('/', function(req, res) {
	res.json({message: "horrary"});
});

app.use('/api', router);
console.log('Magic is happening on port');