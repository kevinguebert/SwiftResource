//server.js

var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mongoose   = require('mongoose');
mongoose.connect('mongodb://swift:WWDC2016@ds021741.mlab.com:21741/heroku_qh2b8v0v'); // connect to our database

var Resource = require('./app/models/resource');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;

var router = express.Router();

router.use(function(req, res, next) {
	console.log("Sittin', Waitin', Wishin'");
	next();
});

router.get('/', function(req, res) {
	res.json({message: "horrary"});
});

app.use('/api', router);

app.listen(port);
console.log('Magic is happening on port ' + port);