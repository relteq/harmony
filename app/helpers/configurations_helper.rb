module ConfigurationsHelper
  def js_callback_redirect(url_options)
    %Q{
      callback: function() {
        window.location = "#{url_for(url_options)}";
      }
    }
  end
end
