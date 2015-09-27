module Blogue
  class Engine < ::Rails::Engine
    isolate_namespace Blogue

    config.before_initialize do
      Blogue.setup_defaults!
    end

    initializer('blogue.setup', :after => 'append_asset_paths') do |app|
      app.config.assets.paths <<
        (Blogue.assets_path.respond_to?(:call) ?
          Blogue.assets_path.call : Blogue.assets_path)

      app.config.assets.precompile += ['*.jpg', '*.png', '*.gif']

      if handler = Blogue.markdown_template_handler
        ActionView::Template.register_template_handler(:md, handler)
      end

      Blogue.compute_cache_keys!
    end
  end
end
