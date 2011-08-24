ReportViewer.UI = (function(){
  var plot_rect_size = {
    width: 5,
    height: 2
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

  var three_d_plot_click_state = (function(){
    var _state = "empty",
        first_x = 0,
        first_y = 0;

    function click(cx, cy, ui) {
      if(_state === "empty") {
        first_x = cx;
        first_y = cy;
        _state = "one point";
      }
      else if(_state === "one point") {
        var min_x = Math.min(cx, first_x);
        var max_x = Math.max(cx, first_x);
        var min_y = Math.min(cy, first_y);
        var max_y = Math.max(cy, first_y);
        ui.reframe({ x: [min_x, max_x], y: [min_y, max_y] });
        _state = "empty";
      }
    }

    return {
      click: click
    };
  })();

  function reframe(newBounds) {
  }

  function adjustNodeMarker(val) {
    var nodeIndex = Math.floor(val * nodes_array.length / y_data.length);
    var node = nodes_array[nodeIndex];
    marker.setPosition(new google.maps.LatLng(node[0], node[1]));
  }

  function adjustX(event, ui) {
    if(debug) {
      $("#crosshair_x").text(ui.value || 0);
    }
    plotWrap2D("#yz-chart", y_data, z_data.getColumn(ui.value));
  }

  function adjustY(event, ui) {
    if(debug) {
      $("#crosshair_y").text(ui.value || 0);
    }
    plotWrap2D("#xz-chart", x_data, z_data.getRow(ui.value));
    adjustNodeMarker(ui.value);
  }

  function weave(a1, a2) {
    var outputArr = [];
    var l = a1.length;
    for(var i = 0; i < l; i++)
      outputArr.push([a1[i],a2[i]]);
    return outputArr;
  }

  function plotWrap2D(placeholder, xdata, ydata) {
    $.plot(placeholder, 
      [{
        data: weave(x_data, ydata)
      }], 
      {
        series: {
          lines: { show: true },
        },
        ticks: 5,
        xaxis: { labelWidth: null },
        yaxis: { labelWidth: 25 }
      }
    );
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

    $("#xz-chart").css("left", (total_width + 120) + "px");
    $("#yz-chart").css("left", (total_width + 120) + "px");
    
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
          plot_rect_size.height*(yl-row),
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
          three_d_plot_click_state.click(
            this.blockx, 
            this.blocky, 
            ReportViewer.UI
          );
        });
        rects[i] = rect;
      }
    }

    plotWrap2D("#xz-chart", x_data, z_data.getRow(0));
    plotWrap2D("#yz-chart", y_data, z_data.getColumn(0)); 
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
    populateGraphs: populateGraphs,
    reframe: reframe
  }
})();

$(function() {
  ReportViewer.UI.initialize();
  ReportViewer.DataLoader.xmlLoad(
    report_url,
    ReportViewer.UI.populateGraphs
  );
});
