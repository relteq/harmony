// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//  ******************* tree menu
<!--//--><![CDATA[//><!--
	 jQuery(document).ready(function() {
		jQuery("#root ul").each(function() {jQuery(this).css("display", "none");});
		jQuery("#root .category").click(function() {
			var childid = "#" + jQuery(this).attr("childid");
			if (jQuery(childid).css("display") == "none") {jQuery(childid).css("display", "block");}
			else {jQuery(childid).css("display", "none");}
			if (jQuery(this).hasClass("cat_close")) {jQuery(this).removeClass("cat_close").addClass("cat_open");}
			else{jQuery(this).removeClass("cat_open").addClass("cat_close");}
		});
	});
//--><!]]>

