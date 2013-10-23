module Blogue
  class Engine < ::Rails::Engine
    isolate_namespace Blogue

    initializer 'blogue.append_asset_path' do |app|
      app.config.assets.paths << (
        File.expand_path(Blogue.assets_path || "#{Blogue.posts_path}/assets")
      )
    end

    config.after_initialize do
      if defined?(Kramdown)
        Blogue.setup_kramdown_for_handling_md_files
        Blogue.use_rouge_codeblock_handler if defined?(Rouge)
      end
    end
  end
end
