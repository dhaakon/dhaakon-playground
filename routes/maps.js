(function() {
  exports.index = function(req, res) {
    var options, renderer;
    renderer = req.params['renderer'];
    options = {
      renderer: {
        name: renderer,
        isCanvas: renderer === 'canvas'
      },
      title: renderer.toUpperCase() + ' Map'
    };
    return res.render('maps', options);
  };

}).call(this);
