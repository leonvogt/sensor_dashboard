module ApplicationHelper
  def class_for_flash(type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-primary"
    }[type.to_sym] || type.to_s
  end

  def icon(style, name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class
    html_options['aria-hidden'] ||= true

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end

  def menu_link_active_class(link)
    if request.url.include?(link) || link == '/dashboard' && controller_name == 'dashboard'
      'side-menu--active'
    end
  end
end
