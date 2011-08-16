ReportViewer.DataLoader = (function(){
  var the_data = "",
      x_data = [],
      y_data = [],
      z_data = [];

  var DataSource = (function() {
    function nonAxisData() {
      var vArray = this.vArray;
      for(var name in vArray) {
        if(!vArray[name].axis) {
          return vArray[name].contents;
        }
      }
    }

    function getVector(name) {
      return this.vArray[name].contents;
    }

    function getVectorLength(name) {
      return this.vArray[name].length;
    }

    function fromArrayOfVector(array_of_vectors) {
      this.vArray = [];
      this.nonAxisData = nonAxisData;
      this.getVector = getVector;
      this.getVectorLength = getVectorLength;
      var name;
      for(name in array_of_vectors) {
        this.vArray[name] = array_of_vectors[name];
      }
    }

    return {
      fromArrayOfVector: fromArrayOfVector
    };
  })();


  function getContours() {
    return the_data.find('plot[zlabel]');
  }

  function getOneContour() {
    return getContours().first();
  }

  function normalizeArray(arr) {
    var maxArr = Math.max.apply(null, arr);
    for(var i = 0; i < arr.length; i++) {
      arr[i] /= maxArr;
      if(arr[i] > 1 || arr[i] < 0) {
        console.log("Bad condition for arr[i], i = " 
                    + i + ", arr[i] = " + arr[i]);
      }
    }
    return arr;
  }

  function loadXYZ(contour) {
    var xdata = contour.find('xdata').text().split(/[,;]/),
        ydata = contour.find('ydata').text().split(/[,;]/),
        zdata = contour.find('zdata').text().split(/[,;]/);
    var xl = xdata.length;
    var yl = ydata.length;
    var zl = zdata.length;
    var minZ = Math.min.apply(null, zdata);
    var maxZ = Math.max.apply(null, zdata);
    zdata = normalizeArray(zdata);
    var data_array = {
      x: {
        contents: xdata,
        length: xl,
        axis: true
      },
      y: {
        contents: ydata,
        length: yl,
        axis: true
      },
      z: {
        contents: zdata,
        length: zl,
        axis: false
      }
    };
    return new DataSource.fromArrayOfVector(data_array);
  }

  function xmlLoad(url, post) {
    $.ajax({
      url: report_url,
      dataType: 'jsonp',
      success: function(data) {
        the_data = $($.parseXML(data.xml));
        var contour = getOneContour();
        var axes_data = loadXYZ(contour);
        post(axes_data);
      }
    });
  }

  return {
    xmlLoad: xmlLoad,
  };
})();
