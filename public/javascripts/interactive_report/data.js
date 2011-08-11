ReportViewerData = {
  the_data: "",

  xmlLoad: function(url) {
    $.ajax({
      url: report_url,
      dataType: 'jsonp',
      success: function(data) {
        ReportViewerData['the_data'] = $.parseXML(data);
      }
    });
  }
}
