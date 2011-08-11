ReportViewer.UI = {
  z_data: {},

  populateGraphs: function(xdata,ydata,zdata) {
    ReportViewer.UI.z_data = zdata;

    function floatToColor(f)
    {
      return 'hsb( ' + f.toFixed(4)*100.0/359.0 + ', .78, .93)';
    }

    var raphaels = {
      r1: Raphael("three-d-graph", 950, 450)
    };
    var xl = xdata.length;
    var yl = ydata.length;
    var zl = zdata.length;
    console.log(xl,yl,zl);
    var rects = new Array(zl);

    for(var row = 0; row < yl; row++) {
      for(var col = 0; col < xl; col++) {
        var i = (row * xl) + col;
        var rect = raphaels['r1'].rect(6*col,3*row,6,3);
        rect.blockx = col;
        rect.blocky = row;
        rect.intensity = zdata[i];
        var color = floatToColor(rect.intensity);
        rect.attr('fill', color);
        rect.attr('stroke', color);
        rect.click(function(event) {
          $("#debug-log").append("(" + this.blockx + ", "
                               + this.blocky + ") = "
                               + this.intensity + "; ");

        });
/*        rect.hover(function(event) {
          this.toFront();
          this.scale(5,5);
        }, function(event) {
          this.scale(1,1);
        });*/
        rects[i] = rect;
      }
    }
  },

  initialize: function() {
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
  }
}

$(function() {
  ReportViewer.Data.xmlLoad(report_url);
  ReportViewer.UI.initialize();
});
