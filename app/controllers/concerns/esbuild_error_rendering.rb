module EsbuildErrorRendering
  ESBUILD_ERROR = Rails.root.join("esbuild_error_#{Rails.env}.txt") # see esbuild.config.js

  def self.included(base)
    base.before_action :render_esbuild_error, if: :render_esbuild_error?
  end

  private
  def render_esbuild_error
    heading, errors = ESBUILD_ERROR.read.split("\n", 2)

    # Render error as HTML so rack-livereload can inject its code into <head>
    # and refresh the error page when assets are modified.
    render html: <<~HTML.html_safe, layout: false
      <html>
        <head></head>
        <body>
          <h1>#{ERB::Util.html_escape(heading)}</h1>
          <pre>#{ERB::Util.html_escape(errors)}</pre>
        </body>
      </html>
    HTML
  end

  def render_esbuild_error?
    ESBUILD_ERROR.exist? && ESBUILD_ERROR.size > 0
  end
end
