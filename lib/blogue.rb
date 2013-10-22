require "blogue/engine"

module Blogue
  mattr_accessor :posts_path
  mattr_accessor :assets_path
  mattr_accessor :markdown_format_handler
  mattr_accessor :kramdown_codeblock_handler
  mattr_accessor :author_name

  self.posts_path = 'app/posts'

  def self.setup_kramdown_for_handling_md_files
    require 'kramdown/converter/blogue'

    self.markdown_format_handler ||= -> template {
      mdown = ActionView::Template.registered_template_handler(:erb).(template)
      "Kramdown::Document.new(begin;#{mdown};end).to_blogue"
    }

    ActionView::Template.register_template_handler :md, markdown_format_handler
  end

  def self.use_rouge_codeblock_handler
    self.kramdown_codeblock_handler ||= -> el, indent {
      attr = el.attr.dup
      lang = extract_code_language!(attr)

      begin
        Rouge.highlight(el.value, lang || 'text', 'html')
      rescue RuntimeError
        Rouge.highlight(el.value, 'text', 'html')
      end
    }
  end
end
