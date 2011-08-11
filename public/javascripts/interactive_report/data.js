ReportViewer.Data = {
  the_data: "",
  x_data: [],
  y_data: [],
  z_data: [],

  getContours : function() {
    return ReportViewer.Data.the_data.find('plot[zlabel]');
  },

  getOneContour : function() {
    return ReportViewer.Data.getContours().first();
  },

  normalizeArray : function(arr) {
    var maxArr = Math.max.apply(null, arr);
    for(var i = 0; i < arr.length; i++) {
      arr[i] /= maxArr;
      if(arr[i] > 1 || arr[i] < 0) {
        console.log("Bad condition for arr[i], i = " 
                    + i + ", arr[i] = " + arr[i]);
      }
    }
    return arr;
  },

  loadXYZ : function(contour) {
    var xdata = contour.find('xdata').text().split(/[,;]/),
        ydata = contour.find('ydata').text().split(/[,;]/),
        zdata = contour.find('zdata').text().split(/[,;]/);
    var xl = xdata.length;
    var yl = ydata.length;
    var zl = zdata.length;
    var minZ = Math.min.apply(null, zdata);
    var maxZ = Math.max.apply(null, zdata);
    console.log("minZ = " + minZ);
    console.log("maxZ = " + maxZ);
    console.log(xl);
    console.log(yl);
    console.log(zl);
    zdata = ReportViewer.Data.normalizeArray(zdata);
    return [xdata,ydata,zdata];
  },

  xmlLoad: function(url) {
    $.ajax({
      url: report_url,
      dataType: 'jsonp',
      success: function(data) {
        ReportViewer.Data.the_data = $($.parseXML(data.xml));
        console.log(ReportViewer.Data.the_data);
        var contour = ReportViewer.Data.getOneContour();
        console.log(contour);
        var axes_data = ReportViewer.Data.loadXYZ(contour);
        ReportViewer.UI.populateGraphs(
          axes_data[0], 
          axes_data[1], 
          axes_data[2]
        );
      }
    });
  }
}
