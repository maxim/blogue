require 'blogue/engine'
require 'blogue/kramdown_template_handler'
require 'digest'

module Blogue
  DEFAULT_AUTHOR_NAME = `whoami`.strip.freeze
  DEFAULT_POSTS_PATH = 'app/posts'.freeze
  DEFAULT_ASSETS_PATH = -> { "#{Blogue.posts_path}/assets" }
  DEFAULT_COMPUTE_POST_CACHE_KEY = -> post {
    Digest::MD5.hexdigest([post.id, post.author_name, post.body].join)
  }
  DEFAULT_ROUGE_KRAMDOWN_OPTIONS = {
    :syntax_highlighter => :rouge,
    :syntax_highlighter_opts => { default_lang: 'ruby' }.freeze
  }.freeze

  class << self
    attr_accessor \
      :author_name,
      :posts_path,
      :markdown_template_preprocessor,
      :markdown_template_handler,
      :compute_post_cache_key,
      :assets_path

    attr_reader \
      :posts_cache_keys,
      :cache_key,
      :started_at

    def setup_defaults!
      self.author_name = DEFAULT_AUTHOR_NAME
      self.posts_path = DEFAULT_POSTS_PATH
      self.assets_path = DEFAULT_ASSETS_PATH
      self.compute_post_cache_key = DEFAULT_COMPUTE_POST_CACHE_KEY
      self.markdown_template_handler = detect_markdown_template_handler
      @started_at = Time.current.freeze
    end

    def compute_cache_keys!
      @posts_cache_keys = Hash[Post.all.map { |p|
        [p.id.freeze, Blogue.compute_post_cache_key.(p).freeze]
      }].freeze

      @cache_key = Digest::MD5.hexdigest(
        @posts_cache_keys.values.sort.join
      ).freeze
    end

    def detect_markdown_template_handler
      if defined?(Kramdown) && defined?(Rouge)
        KramdownTemplateHandler.new \
          :kramdown => DEFAULT_ROUGE_KRAMDOWN_OPTIONS,
          :preprocessor => markdown_template_preprocessor
      elsif defined?(Kramdown)
        KramdownTemplateHandler.new \
          :preprocessor => markdown_template_preprocessor
      end
    end
  end
end
