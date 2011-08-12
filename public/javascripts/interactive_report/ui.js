ReportViewer.UI = {
  plot_rect_size:  {
    width: 6,
    height: 4
  },

  debug: true,
  z_data: {},
  crosshairs: {x: 0, y: 0},

  adjustX: function(event, ui) {
    if(ReportViewer.UI.debug) {
      $("#crosshair_x").text(ui.value || 0);
    }
  },

  adjustY: function(event, ui) {
    if(ReportViewer.UI.debug) {
      $("#crosshair_y").text(ui.value || 0);
    }
  },

  populateGraphs: function(xdata,ydata,zdata) {
    console.log(this);
    this.z_data = zdata;

    function floatToColor(f)
    {
      return 'hsb( ' + f.toFixed(4)*100.0/359.0 + ', .78, .93)';
    }

    var xl = xdata.length;
    var yl = ydata.length;
    var zl = zdata.length;

    $("#x-axis-slider").slider("option", "max", xl - 1);
    $("#y-axis-slider").slider("option", "max", yl - 1);

    var total_width = this.plot_rect_size.width * xl;
    var total_height = this.plot_rect_size.height * yl;
    
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
          this.plot_rect_size.width*col,
          this.plot_rect_size.height*row,
          this.plot_rect_size.width,
          this.plot_rect_size.height
        );
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
        rects[i] = rect;
      }
    }

    $.plot("#xz-chart", [[[0,0],[1,1],[2,0.5]]]);
  },

  initialize: function() {
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
  }
}

$(function() {
  ReportViewer.Data.xmlLoad(report_url);
  ReportViewer.UI.initialize();
});
