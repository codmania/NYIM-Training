module Application
  module Display
    class DisplayOptions < Struct.new(:options)
      extend ActiveModel::Naming
      include ActiveModel::Conversion
      def persisted?
        false
      end

    end

    module DisplayInstanceMethods
      def display_options(*args)
        @display_columns = args.empty? ? resource_class.column_names : args
        display = params[:application_display_display_options]
        columns = display ? display[:options].reject(&:blank?).uniq : @display_columns
        @display_options = DisplayOptions.new(columns)
      end
    end

    module DisplayClassMethods
      def display_options(*args)
        options = args.extract_options!
        before_filter options do
          display_options(*args)
        end
      end

    end

    def self.included(base)
      base.class_eval do
        extend DisplayClassMethods
        include DisplayInstanceMethods
      end
    end
  end
end