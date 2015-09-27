module Blogue
  class KramdownTemplateHandler
    def initialize(options = {})
      @kramdown_options = options[:kramdown] || {}
      @preprocessor = options[:preprocessor]
    end

    def call(template)
      @preprocessor.call(template) if @preprocessor.respond_to?(:call)
      mdown = ActionView::Template.registered_template_handler(:erb).(template)
      "Kramdown::Document.new(begin;#{mdown};end, "\
        "#{@kramdown_options.inspect}).to_html"
    end
  end
end
