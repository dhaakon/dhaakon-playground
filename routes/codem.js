(function() {
  exports.codem = function(req, res) {
    var obj;
    obj = {
      title: 'Dev'
    };
    return res.render('codem');
  };

}).call(this);
