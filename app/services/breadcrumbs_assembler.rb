class Breadcrumb
  attr_reader :name, :path

  def initialize(name, path = '#')
    @name = name
    @path = path
  end
end

class BreadcrumbsAssembler
  include Rails.application.routes.url_helpers
  attr_reader :crumbs

  def initialize(controller, action, params)
    @crumbs = assemble_crumbs(controller, action, params)
  end

  private
  def assemble_crumbs(controller, action, params)
    crumbs  = []
    id      = params[:id]

    case [controller, action].join('#')
    when 'dashboard#show'
      crumbs << { name: 'Dashboard' }
    when 'devices#index'
      crumbs << { name: Device.model_name.human(count: 2) }
    when 'devices#show'
      crumbs << { name: Device.model_name.human(count: 2), path: devices_path }
      crumbs << { name: Device.find(id).to_s }
    when 'devices#new'
      crumbs << { name: Device.model_name.human(count: 2), path: devices_path }
      crumbs << { name: I18n.t('new_title', model: Device.model_name.human) }
    when 'devices#edit'
      device = Device.find(id)
      crumbs << { name: Device.model_name.human(count: 2), path: devices_path }
      crumbs << { name: device.to_s, path: device_path(device) }
      crumbs << { name: I18n.t('edit_title', model: Device.model_name.human) }
    else
      puts "No breadcrumbs for #{[controller, action].join('#')}"
    end

    crumbs.map { |crumb| Breadcrumb.new(crumb[:name], crumb[:path]) }
  end
end
