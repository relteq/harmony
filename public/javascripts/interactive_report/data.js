ReportViewer.DataLoader = (function(){
  var the_data = "",
      x_data = [],
      y_data = [],
      z_data = [];

  var DataSource = (function() {
    function plotData() {
      var vArray = this.vArray,
          coll = [];
      for(var name in vArray) {
        if(!vArray[name].axis) {
          coll[name] = vArray[name];
        }
      }
      return coll;
    }

    function getVector(name) {
      return this.vArray[name].contents;
    }

    function getVectorLength(name) {
      return this.vArray[name].length;
    }

    function newBounds(axis, min, max) {
      this.bounds[axis] = { 
        min: min, 
        max: max,
        universal_min: min,
        universal_max: max
      };
    }

    function setBounds(axis, min, max) {
      this.bounds[axis] = { min: min, max: max };
    }
    
    function getBounds() {
      return this.bounds;
    }

    function getRow(y) {
      /* This should be added to array */
      var xBounds = this.dataSource.getBounds()['x'],
          xStart = xBounds['min'],
          xEnd = xBounds['max'],
          rowSize = xBounds['universal_max'] - xBounds['universal_min'];

      var rowArr = this.slice(rowSize * y + xStart, rowSize * y + xEnd);
      return rowArr;
    }

    function getColumn(x) {
      /* This should be added to array */
      var yBounds = this.dataSource.getBounds()['y'],
          xBounds = this.dataSource.getBounds()['x'],
          yStart = yBounds['min'],
          yEnd = yBounds['max'],
          rowSize = xBounds['universal_max'] - xBounds['universal_min'];

      var rowArr = [];
      for(var i = (yStart * rowSize) + x; 
              i < yEnd * rowSize; 
              i += rowSize) {
        rowArr.push(this[i]);
      }
      return rowArr;
    }

    function addPlotFunctions(array) {
      array.dataSource = this;
      array.getRow = getRow;
      array.getColumn = getColumn;
    }

    function fromArrayOfVector(array_of_vectors) {
      this.vArray = [];
      this.bounds = [];
      this.plotData = plotData;
      this.getVector = getVector;
      this.getVectorLength = getVectorLength;
      this.newBounds = newBounds;
      this.setBounds = setBounds;
      this.getBounds = getBounds;
      this.addPlotFunctions = addPlotFunctions;
      for(var name in array_of_vectors) {
        this.vArray[name] = array_of_vectors[name];
        if(array_of_vectors[name].axis) {
          this.newBounds(name, 0, array_of_vectors[name].length);
        } else {
          this.addPlotFunctions(this.vArray[name].contents);
        }
      }
    }

    return {
      fromArrayOfVector: fromArrayOfVector
    };
  })();


  function getContours() {
    /* 
       This should probably be more robust - it just finds 
       every 3d graph by looking for data with a z-axis.
     */
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
