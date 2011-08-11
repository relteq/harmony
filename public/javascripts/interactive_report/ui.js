$(function() {
  $("#x-axis-slider").slider();
  $("#y-axis-slider").slider({ 
    orientation: 'vertical' 
  });
  var latlng = new google.maps.LatLng(37.795467, -122.400341);
  var myOptions = {
    zoom: 16,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var polyOptions = {
    strokeColor: '#000000',
    strokeOpacity: 0.5,
    strokeWeight: 3
  };

  var map = new google.maps.Map(
    document.getElementById("map-view"),
    myOptions
  );
  
  function floatToColor(f)
  {
    return 'hsb( ' + f*100/359.0 + ', .78, .93)';
  }
  
  var raphaels = {
    r1: Raphael("three-d-graph", 950, 450)
  };
  var x = new Array(22500);
  var rects = new Array(22500);
  for(var i = 0; i < 22500; i++) {     
     x[i] = Math.random();
  }

  for(var row = 0; row < 150; row++) {
    for(var col = 0; col < 150; col++) {
      var i = (row * 150) + col;
      var rect = raphaels['r1'].rect(6*col,3*row,6,3);
      rect.blockx = col;
      rect.blocky = row;
      rect.intensity = x[i];
      var color = floatToColor(rect.intensity);
      rect.attr('fill', color);
      rect.attr('stroke', color);
      rect.click(function(event) {
        $("#debug-log").append("(" + this.blockx + ", "
                             + this.blocky + ") = "
                             + Math.floor(this.intensity*100)/100 + "; ");
      });
      rect.hover(function(event) {
        this.toFront();
        this.scale(5,5);
      }, function(event) {
        this.scale(1,1);
      });
      rects[i] = rect;
    }
  }
});
