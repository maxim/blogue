module Blogue
  class Post
    class << self
      def find(id)
        all.find{ |p| p.id == id }
      end

      def all
        posts = all_post_paths.
          map(&method(:new)).
          sort(&method(:sort_posts))

        Rails.env.production? ? posts.reject(&:private?) : posts
      end

      def all_post_paths
        all_paths_in_posts_dir.select(&method(:post_file?))
      end

      def all_paths_in_posts_dir
        Dir["#{Blogue.posts_path}/*"]
      end

      def post_file?(path)
        File.file?(path) && !File.basename(path).starts_with?('.')
      end

      def extract_post_id(path)
        File.basename(path)[/[^\.]+/]
      end

      def sort_posts(post_a, post_b)
        post_b.time <=> post_a.time
      end

      def load_meta(text)
        YAML.load(
          text.lines.select do |line|
            !!(line[/^<!--\s*meta/]..line[/--!>$/])
          end[1..-2].try(:join, "\n") || ''
        ) || {}
      end
    end

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def id
      self.class.extract_post_id(path)
    end

    def date
      time.try(:to_date)
    end

    def time
      meta_time || file_ctime
    end

    def title
      meta_title || parsed_title || filename_title
    end

    def body
      File.read(path)
    end

    def tldr
      meta['tldr']
    end

    def author_name
      meta_author_name || config_author_name
    end

    def private?
      filename_with_underscore? || meta_private?
    end

    def meta
      self.class.load_meta(body)
    end

    def cache_key
      "blogue/posts/#{id}/#{Blogue.posts_cache_keys[id]}"
    end

    def to_partial_path
      'posts/post'
    end

    def to_helper_name
      id.underscore
    end

    private

    def meta_time
      Time.parse(meta['date'])
    rescue TypeError
      nil
    end

    def file_ctime
      File.ctime(path)
    end

    def meta_title
      meta['title']
    end

    def parsed_title
      if body.lines.find{ |line| line =~ /^\s*#\s+(.+)$/ }
        $1
      end
    end

    def filename_title
      id.split(/[-_]/).join(' ').capitalize
    end

    def meta_author_name
      meta['author']
    end

    def config_author_name
      Blogue.author_name
    end

    def filename_with_underscore?
      File.basename(path).starts_with?('_')
    end

    def meta_private?
      meta['private']
    end
  end
end
