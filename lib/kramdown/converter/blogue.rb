module Kramdown
  module Converter
    class Blogue < Html
      def convert_codeblock(*args, &blk)
        if ::Blogue.kramdown_codeblock_handler
          instance_exec(*args, &::Blogue.kramdown_codeblock_handler)
        else
          super
        end
      end
    end
  end
end
