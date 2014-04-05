module ApplicationHelper

  def bootstrap_flash(options = {})
    ret = []
    flash.each do |key, value|
      puts flash.inspect
      if key.to_s == 'alert'
        klass = "flash alert alert-danger global"
      else
        klass = "flash alert alert-#{key} global"
      end
      ret << content_tag( :div, {class: klass, id: "flash-#{key}"}) do
        content = haml_tag "a.close", "data-dismiss" => "alert" 
        haml_concat value
      end
    end
    return_string = ret.join("\n")
    return return_string.respond_to?(:html_safe) ? return_string.html_safe : return_string

  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(:filter_html => true, 
    :hard_wrap => true)
    options = {
    :fenced_code_blocks => true,
    :no_intra_emphasis => true,
    :autolink => true,
    :superscript => true,
    :strikethrough => true,
    :no_styles => true
    } 
    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end
end
