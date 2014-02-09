(function() {
  exports.demos = function(req, res) {
    var demoType, obj, title;
    demoType = req.params['type'];
    obj = title = demoType;
    return res.render('demos/' + demoType, obj);
  };

}).call(this);
