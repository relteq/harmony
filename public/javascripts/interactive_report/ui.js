ReportViewer.UI = (function(){
  var plot_rect_size = {
    width: 6,
    height: 3
  };

  var debug = true;

  var x_data = [];
  var y_data = [];
  var z_data = [];

  var marker;

  var crosshairs = {
    x: 0, 
    y: 0
  };

  function adjustNodeMarker(val) {
    var nodeIndex = Math.floor(val * nodes_array.length / y_data.length);
    var node = nodes_array[nodeIndex];
    marker.setPosition(new google.maps.LatLng(node[0], node[1]));
  }

  function adjustX(event, ui) {
    if(debug) {
      $("#crosshair_x").text(ui.value || 0);
    }
    $.plot("#yz-chart", [weave(y_data, z_data.getColumn(ui.value))]);
  }

  function adjustY(event, ui) {
    if(debug) {
      $("#crosshair_y").text(ui.value || 0);
    }
    $.plot("#xz-chart", [weave(x_data, z_data.getRow(ui.value))]);
    adjustNodeMarker(ui.value);
  }

  function weave(a1, a2) {
    var outputArr = [];
    var l = a1.length;
    for(var i = 0; i < l; i++)
      outputArr.push([a1[i],a2[i]]);
    return outputArr;
  }

  function populateGraphs(contourInfo, dataSource) {
    $("#contour_plot_name").text(contourInfo.title);
    z_data = dataSource.getVector('z');
    x_data = dataSource.getVector('x');
    y_data = dataSource.getVector('y');

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
        var color = floatToColor(rect.intensity / z_data.max());
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

    $.plot("#xz-chart", [{
      data: weave(x_data, z_data.getRow(0)),
      xaxis: { label: "X" },
      yaxis: { label: "Y" }
    }]);
    $.plot("#yz-chart", [weave(y_data, z_data.getColumn(0))]);
  }

  function initialize() {
    $("#x-axis-slider").slider({
      slide: adjustX,
    });
    $("#y-axis-slider").slider({
      slide: adjustY,
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

    var markerOptions = {
      position: new google.maps.LatLng(nodes_array[0][0], 
                                       nodes_array[0][1]),
      map: map
    };

    marker = new google.maps.Marker(
      markerOptions
    );

    poly = new google.maps.Polyline(polyOptions);
    poly.setMap(map);

    var path = poly.getPath();
    for(var i = 0; i < nodes_array.length; i++) {
      var node = nodes_array[i];
      path.push(new google.maps.LatLng(node[0],node[1]));
    }

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
