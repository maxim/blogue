require 'blogue/engine'
require 'kramdown/converter/blogue'
require 'digest'

module Blogue
  mattr_accessor :author_name
  mattr_accessor :assets_path

  mattr_accessor :posts_path
  self.posts_path = 'app/posts'

  mattr_accessor :checksum_calc
  self.checksum_calc = -> post do
    Digest::MD5.hexdigest([post.id, post.author_name, post.body].join)
  end

  mattr_accessor :blanket_checksum_calc
  self.blanket_checksum_calc = -> do
    Digest::MD5.hexdigest(checksums.values.sort.join)
  end

  mattr_accessor :default_markdown_format_handler
  self.default_markdown_format_handler = -> template {
    mdown = ActionView::Template.registered_template_handler(:erb).(template)
    "Kramdown::Document.new(begin;#{mdown};end).to_blogue"
  }

  mattr_accessor :default_kramdown_codeblock_handler
  self.default_kramdown_codeblock_handler = -> el, indent {
    attr = el.attr.dup
    lang = extract_code_language!(attr)

    begin
      Rouge.highlight(el.value, lang || 'text', 'html')
    rescue RuntimeError
      Rouge.highlight(el.value, 'text', 'html')
    end
  }

  mattr_accessor :markdown_format_handler
  def self.setup_kramdown_for_handling_md_files
    self.markdown_format_handler ||= default_markdown_format_handler
    ActionView::Template.register_template_handler :md, markdown_format_handler
  end

  mattr_accessor :kramdown_codeblock_handler
  def self.use_rouge_codeblock_handler
    self.kramdown_codeblock_handler ||= default_kramdown_codeblock_handler
  end

  mattr_accessor :checksums
  def self.set_checksums
    self.checksums = Hash[
      Post.all.map{ |p| [p.id, checksum_calc.(p)] }
    ]
  end

  mattr_accessor :blanket_checksum
  def self.set_blanket_checksum
    self.blanket_checksum = blanket_checksum_calc.()
  end
end
