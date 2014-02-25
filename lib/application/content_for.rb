module Application::ContentFor

  def self.included(base)

    base.class_eval do

      action_accessor :document_title, :main_container_dom

      main_container_dom :content

      def content_for(name, &block)
        @content_for_blocks ||= Hash.new
        block ? @content_for_blocks[name] = block : @content_for_blocks[name]
      end

      # you can call this in your responder js update block
      def set_document_title(page)
        if document_title
          logger.debug "set document title to '#{document_title}'"
          page << "document.title = '#{view_context.escape_javascript(document_title)}';"
        end
      end

      def scrolltop(page)
        page << "$('html, body').animate({ scrollTop: 0 }, 1200);"
      end
    end
  end

end