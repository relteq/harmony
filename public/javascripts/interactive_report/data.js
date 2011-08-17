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

      var colArr = [];
      for(var i = (yStart * rowSize) + x; 
              i < yEnd * rowSize; 
              i += rowSize) {
        colArr.push(this[i]);
      }
      return colArr;
    }

    function getMax() {
      if(!this.cachedMax) {
        this.cachedMax = Math.max.apply(null, this);
      }
      return this.cachedMax;
    }
    
    function getMin() {
      return Math.min.apply(null, this);
    }

    function addPlotFunctions(array) {
      array.dataSource = this;
      array.getRow = getRow;
      array.getColumn = getColumn;
      array.min = getMin;
      array.max = getMax;
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

  var Contour = (function() {
    function numberizeArray(arr) {
      for(var i = 0; i < arr.length; i++)
        arr[i] = Number(arr[i]);
    }

    function loadAsXYZ() {
      var xdata = this.rawXData.split(/[,;]/),
          ydata = this.rawYData.split(/[,;]/),
          zdata = this.rawZData.split(/[,;]/);
      var xl = xdata.length;
      var yl = ydata.length;
      var zl = zdata.length;
      numberizeArray(zdata);
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

    function Individual(xmlData) {
      var dataWrapped = $(xmlData).parent();
      this.loadXYZ = loadAsXYZ;
      this.title = dataWrapped.attr('title');
      this.xLabel = dataWrapped.find('plot').attr('xlabel');
      this.yLabel = dataWrapped.find('plot').attr('ylabel');
      this.zLabel = dataWrapped.find('plot').attr('zlabel');
      this.rawXData = dataWrapped.find('plot > element > xdata').text();
      this.rawYData = dataWrapped.find('plot > element > ydata').text();
      this.rawZData = dataWrapped.find('plot > element > zdata').text();
    }

    function List(xmlData) {
      this.dataList = [];
      this.first = function() {
        return this.dataList[0];
      };
      for(var i = 0; i < xmlData.length; i++) {
        this.dataList.push(new Individual(xmlData[i]));
      }
    }

    return {
      List: List
    };
  })();


  function getContours() {
    /* 
       This should probably be more robust - it just finds 
       every 3d graph by looking for data with a z-axis.
     */
    return new Contour.List(the_data.find('plot[zlabel]'));
  }

  function getOneContour() {
    return getContours().first();
  }


  function xmlLoad(url, post) {
    $.ajax({
      url: report_url,
      dataType: 'jsonp',
      success: function(data) {
        the_data = $($.parseXML(data.xml));
        var contour = getOneContour();
        var axes_data = contour.loadXYZ();
        post(contour, axes_data);
      }
    });
  }

  return {
    xmlLoad: xmlLoad,
  };
})();
