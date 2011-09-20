ReportViewer.UI = (function(){
  var canvas_size = {
    width: 505,
    height: 314
  }
  var plot_rect_size = {
    width: 5,
    height: 2
  };

  var data_source;
  var contour_list;
  var current_route_index = 0;
  var current_route = {};
  var x_data = [];
  var y_data = [];
  var z_data = [];
  var z_min;
  var z_max;

  var marker;

  var crosshairs = {
    x: 0, 
    y: 0
  };
  
  var raphaels = []; 
  var three_d_plot_click_state = (function(){
    var _state = "empty",
        first_x = 0,
        first_y = 0;

    function reset() {
      _state = "empty";
    }

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

        // If user selected within the
        // same column/row, we want to ignore
        // this click and keep the state at
        // "one point"
        if(max_x != min_x && max_y != min_y) {
          ui.reframe({ x: [min_x, max_x], y: [min_y, max_y] });
          _state = "empty";
        }
      }
    }

    return {
      click: click,
      reset: reset
    };
  })();

  function reframe(newBounds) {
    data_source.setBounds(
      'x',
      x_data.relative('x',newBounds.x[0]), 
      x_data.relative('x',newBounds.x[1])
    );
    data_source.setBounds('y',
      y_data.relative('y',newBounds.y[0]), 
      y_data.relative('y',newBounds.y[1])
    );
    populateGraphs(null);
  }

  function adjustNodeMarker(val) {
    var nodeIndex = Math.floor(val * current_route.nodes.length / y_data.length);
    var node = current_route.nodes[nodeIndex];
    marker.setPosition(new google.maps.LatLng(node[0], node[1]));
  }

  function adjustX(event, ui) {
    plotWrap2D("#yz-chart", 
               y_data.boundedBy('y'), 
               z_data.getColumn(x_data.relative('x',ui.value)));
  }

  function adjustY(event, ui) {
    var rowVal = y_data.relative('y',ui.value);
    plotWrap2D("#xz-chart", 
               x_data.boundedBy('x'), 
               z_data.getRow(rowVal));
    adjustNodeMarker(rowVal);
  }

  function weave(a1, a2) {
    var outputArr = [];
    var l = a1.length;
    for(var i = 0; i < l; i++)
      outputArr.push([a1[i],a2[i]]);
    return outputArr;
  }

  function plotWrap2D(placeholder, xdata, ydata) 
  {
    $.plot(placeholder, 
      [{
        data: weave(xdata, ydata)
      }], 
      {
        series: {
          lines: { show: true },
        },
        ticks: 5,
        xaxis: { labelWidth: null },
        yaxis: { labelWidth: 25, min: z_min, max: z_max }
      }
    );
  }

  function handleContours(contourList) {
    contour_list = contourList;
    var count = contour_list.count();
    var options = "";
    for(var i = 0; i < count; i++) {
      options += ( "<option value='" + i + "'>" +
                   contour_list.atIndex(i).title +
                   "</option>" );
    }
    $("#contour-select").html(options);
    $("#contour-select").change(function() {
      populateGraphs(contour_list.atIndex(($(this).val())));
    });
    populateGraphs(contour_list.first());
  }

  function populateGraphs(contourInfo) {
    raphaels.r1.clear();

    if(contourInfo != null) {
      $("#contour_plot_name").text(contourInfo.title);
      $(".x-label").text(contourInfo.xLabel);
      $(".y-label").text(contourInfo.yLabel);
      $(".z-label").text(contourInfo.zLabel);
      data_source = contourInfo.loadXYZ();
    }
    z_data = data_source.getVector('z');
    z_min = z_data.min();
    z_max = z_data.max();
    x_data = data_source.getVector('x');
    y_data = data_source.getVector('y');

    function floatToColor(f)
    {
      if(f > -1) {
        return 'hsb( ' + f.toFixed(4)*100.0/359.0 + ', .78, .93)';
      }
      else {
        return "black";
      }
    }

    var xl = x_data.boundedBy('x').length;
    var yl = y_data.boundedBy('y').length;
    var zl = xl * yl;

    $("#x-axis-slider").slider("option", "max", xl - 1);
    $("#y-axis-slider").slider("option", "max", yl - 1);

    $("#xz-chart").css("left", (canvas_size.width + 120) + "px");
    $("#yz-chart").css("left", (canvas_size.width + 120) + "px");
    
    $("#x-axis-slider").css("width", canvas_size.width + "px");
    $("#y-axis-slider").css("height", canvas_size.height + "px");

    var rects = new Array(zl);

    var yBounds = data_source.getBounds()['y'],
        yMin = yBounds.min,
        yMax = yBounds.max;

    var xBounds = data_source.getBounds()['x'],
        xMin = xBounds.min,
        xMax = xBounds.max;

    plot_rect_size.width = canvas_size.width / xl;
    plot_rect_size.height = canvas_size.height / yl;

    for(var row = yMin; row < yMax; row++) {
      var z_data_row = z_data.getRow(row);
      for(var col = 0; col < z_data_row.length; col++) {
        var i = (row * xl) + col;
        var rect = raphaels['r1'].rect(
          plot_rect_size.width*col,
          plot_rect_size.height*(yl-row),
          plot_rect_size.width,
          plot_rect_size.height
        );
        rect.blockx = col;
        rect.blocky = row;
        rect.intensity = z_data_row[col];
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

    plotWrap2D("#xz-chart", x_data.boundedBy('x'), z_data.getRow(0));
    plotWrap2D("#yz-chart", y_data.boundedBy('y'), z_data.getColumn(0)); 
  }

  function plotPath(nodeArray, path) {
    path.clear();
    for(var i = 0; i < current_route.nodes.length; i++) {
      var node = current_route.nodes[i];
      path.push(new google.maps.LatLng(node[0],node[1]));
    }
  }

  function initialize() {
    $("#x-axis-slider").slider({
      slide: adjustX,
    });
    $("#y-axis-slider").slider({
      slide: adjustY,
      orientation: 'vertical'
    });
    $("#reset-zoom").click(function() {
      data_source.resetBounds();
      populateGraphs(null);
    });

    current_route = nodes_array[current_route_index];
    raphaels.r1 = Raphael("three-d-graph", 
                          canvas_size.width, 
                          canvas_size.height);

    var latlng = new google.maps.LatLng(
      current_route.nodes[0][0],
      current_route.nodes[0][1]
    );
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
      position: new google.maps.LatLng(current_route.nodes[0][0], 
                                       current_route.nodes[0][1]),
      map: map
    };

    marker = new google.maps.Marker(
      markerOptions
    );

    poly = new google.maps.Polyline(polyOptions);
    poly.setMap(map);

    var path = poly.getPath();
    plotPath(current_route.nodes, path);

    var route_option_html = "";
    for(var i = 0; i < nodes_array.length; i++) {
      route_option_html += 
        ("<option value='"+i+"'>" + 
         nodes_array[i].title +
         "</option>");
    }
    $("#route-select").html(route_option_html);
    $("#route-select").change(function() {
      current_route_index = ($(this).val());
      current_route = nodes_array[current_route_index];
      plotPath(current_route.nodes, poly.getPath());
    });

    return this;
  }

  return {
    initialize: initialize,
    populateGraphs: populateGraphs,
    handleContours: handleContours,
    reframe: reframe
  }
})();

$(function() {
  ReportViewer.UI.initialize();
  ReportViewer.DataLoader.xmlLoad(
    report_url,
    ReportViewer.UI.handleContours
  );
});
