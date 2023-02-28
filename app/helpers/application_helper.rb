module ApplicationHelper
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

  def sensor_types_for_select
    SensorConfiguration::SENSOR_TYPES.map { |sensor_type| [I18n.t(sensor_type, scope: 'sensors.sensor_types'), sensor_type] }
  end

  def chart_types_for_select
    SensorConfiguration::CHART_TYPES.map { |chart_type| [I18n.t(chart_type, scope: 'sensors.chart_types'), chart_type] }
  end
end
