module Blogue
  class KramdownTemplateHandler
    attr_writer :preprocessor

    def initialize(options = {})
      @options = options
    end

    def call(template)
      @preprocessor.call(template) if @preprocessor.respond_to?(:call)
      mdown = ActionView::Template.registered_template_handler(:erb).(template)
      "Kramdown::Document.new(begin;#{mdown};end, #{@options.inspect}).to_html"
    end
  end
end
