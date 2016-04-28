//server.js

var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mongodb = require('mongodb');
var valid = require('valid-url');
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

		if(req.body.is_swift != undefined) {
			if(req.body.is_swift) r.is_swift = true;
			else r.is_swift = false;
		} else {
			r.is_swift = false;
		}
		console.log(req.body);
		r.createDate = new Date();
		if (!(req.body.name || req.body.url || req.body.summary)) {
			handleError(res, "Invalid user input", "Must provide a name, url, and summary", 400);
		} else {
			if(valid.isUri(req.body.url)) {
				db.collection(RESOURCES_COLLECTION).insertOne(r, function(err, doc) {
					if(err) {
						handleError(res, err.message, "Failed to create new resource.");
					} else {
						res.status(201).json(doc.ops[0]);
					}
				});
			} else {
				handleError(res, "Invalid user input", "Please update your url to a valid url. Include http:// or https:// if need be.", 400);
			}
		}
		// r.name = req.body.name;
		// r.url = req.body.url;
		// r.summary = req.body.summary

		// r.save(function(err) {
		// 	if(err)
		// 		res.send(err);
		// 	res.json({message: 'Resource created'});
		// });
	})
	.get(function(req, res) {
		db.collection(RESOURCES_COLLECTION).find({}).toArray(function(err, docs) {
			if(err) {
				handleError(res, err.message, "Failed to get resources.");
			} else {
				res.status(200).json(docs);
			}
		})
	})
	// .get("/:id", function(req, res) {
	// 	db.collection(RESOURCES_COLLECTION).findOne({ _id: new ObjectID(req.params.id) }, function(err, doc) {
	// 		if (err) {
	// 			handleError(res, err.message, "Failed to get resource");
	// 		} else {
	// 		    res.status(200).json(doc);
	// 		}
	// 	});
	// })

	.put("/:id", function(req, res) {
	  var updateDoc = req.body;
	  delete updateDoc._id;

	  db.collection(RESOURCES_COLLECTION).updateOne({_id: new ObjectID(req.params.id)}, updateDoc, function(err, doc) {
	    if (err) {
	      handleError(res, err.message, "Failed to update resource");
	    } else {
	      res.status(204).end();
	    }
	  });
	})

	.delete("/:id", function(req, res) {
	  db.collection(RESOURCES_COLLECTION).deleteOne({_id: new ObjectID(req.params.id)}, function(err, result) {
	    if (err) {
	      handleError(res, err.message, "Failed to delete resource");
	    } else {
	      res.status(204).end();
	    }
	  });
	});

router.get('/', function(req, res) {
	res.json({message: "horrary"});
});

app.use('/api', router);
console.log('Magic is happening on port');