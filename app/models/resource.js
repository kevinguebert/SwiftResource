var mongodb   = require('mongodb');
var Schema     = mongodb.Schema;

var ResourceSchema = new Schema({
	name: String,
	summary: String,
	url: String,
	is_swift: Boolean
});

module.exports = mongodb.model('Resource', ResourceSchema);
