var mongoose   = require('mongoose');
var Schema     = mongoose.Schema;

var ResourceSchema = new Schema({
	name: String,
	summary: String,
	url: String,
	is_swift: Boolean
});

module.exports = mongoose.model('Resource', ResourceSchema);
