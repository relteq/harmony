ReportViewer.UI = (function(){
  var plot_rect_size = {
    width: 6,
    height: 3
  };

  var debug = true;
  var z_data = {};
  var crosshairs = {
    x: 0, 
    y: 0
  };

  function adjustX(event, ui) {
    if(debug) {
      $("#crosshair_x").text(ui.value || 0);
    }
  }

  function adjustY(event, ui) {
    if(debug) {
      $("#crosshair_y").text(ui.value || 0);
    }
  }

  function populateGraphs(dataSource) {
    console.log(this);
    z_data = dataSource.nonAxisData();

    function floatToColor(f)
    {
      return 'hsb( ' + f.toFixed(4)*100.0/359.0 + ', .78, .93)';
    }

    var xl = dataSource.getVectorLength('x');
    var yl = dataSource.getVectorLength('y');
    var zl = dataSource.getVectorLength('z');

    $("#x-axis-slider").slider("option", "max", xl - 1);
    $("#y-axis-slider").slider("option", "max", yl - 1);

    var total_width = plot_rect_size.width * xl;
    var total_height = plot_rect_size.height * yl;
    
    $("#x-axis-slider").css("width", total_width + "px");
    $("#y-axis-slider").css("height", total_height + "px");

    var raphaels = {
      r1: Raphael("three-d-graph", total_width, total_height)
    };
    console.log(xl,yl,zl);
    var rects = new Array(zl);

    for(var row = 0; row < yl; row++) {
      for(var col = 0; col < xl; col++) {
        var i = (row * xl) + col;
        var rect = raphaels['r1'].rect(
          plot_rect_size.width*col,
          plot_rect_size.height*row,
          plot_rect_size.width,
          plot_rect_size.height
        );
        rect.blockx = col;
        rect.blocky = row;
        rect.intensity = z_data[i];
        var color = floatToColor(rect.intensity);
        rect.attr('fill', color);
        rect.attr('stroke', color);
        rect.click(function(event) {
          $("#debug-log").append("(" + this.blockx + ", "
                               + this.blocky + ") = "
                               + this.intensity + "; ");

        });
        rects[i] = rect;
      }
    }

    $.plot("#xz-chart", [[[0,0],[1,1],[2,0.5]]]);
    $.plot("#yz-chart", [[[0,0],[1,1],[2,0.5]]]);
  }

  function initialize() {
    $("#x-axis-slider").slider({
      slide: this.adjustX,
    });
    $("#y-axis-slider").slider({
      slide: this.adjustY,
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

    return this;
  }

  return {
    initialize: initialize,
    populateGraphs: populateGraphs
  }
})();

$(function() {
  ReportViewer.UI.initialize();
  ReportViewer.DataLoader.xmlLoad(
    report_url,
    ReportViewer.UI.populateGraphs
  );
});
