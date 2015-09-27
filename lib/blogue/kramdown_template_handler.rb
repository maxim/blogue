module Blogue
  class KramdownTemplateHandler
    def initialize(options = {})
      @options = options
    end

    def call(template)
      mdown = ActionView::Template.registered_template_handler(:erb).(template)
      "Kramdown::Document.new(begin;#{mdown};end, #{@options.inspect}).to_html"
    end
  end
end
