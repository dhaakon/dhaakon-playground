(function() {
  exports.loaders = function(req, res) {
    var obj;
    obj = {
      title: 'Loaders',
      amount: 10
    };
    return res.render('loaders', obj);
  };

}).call(this);
