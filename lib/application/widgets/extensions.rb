module Application::Widgets::Extensions

  def self.included(base)
    base.class_eval do
      include ExtensionsInstanceMethods
    end
  end

  module ExtensionsInstanceMethods

    def heading(*args)
      widget Application::Helpers::Title, :headings => args
    end

    def admin_bar(*options)
      p do
        rawtext(options.map do |link|
          helpers.link_to *link
        end.join ' | ')
      end if admin?
    end

    def out(name)
      name               = name.to_sym
      @template_captures ||= { }
      rawtext @template_captures[name] ||= if content_for? name
                                             # yield does not work here to display captured content
                                             content_for name
                                           else
                                             text "WARNING: no content for :#{name}"
                                           end
    end

    def dom_id(*args)
      helpers.dom_id(*args)
    end


    def text(*args)
      args.each { |a| super a }
    end


  end

end