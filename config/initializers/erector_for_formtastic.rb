module Erector::Rails

  class FormBuilder

    def method_missing(method_name, *args, &block)
      if parent.respond_to?(method_name)
        return_value = parent.send(method_name, *args, &block)
        case return_value
          when ActiveSupport::SafeBuffer
            template.concat(return_value)
            nil
          else
            return_value
        end
      else
        super
      end
    end

    def self.method_missing(method_sym, *arguments)
      parent_builder_class.send(method_sym, *arguments)
    end

  end

  SemanticFormBuilder = ::Erector::Rails::FormBuilder.wrapping(Formtastic::FormBuilder)

  [:semantic_form_for, :semantic_fields_for].each do |method_name|
    def_simple_rails_helper(method_name)
  end

end

Formtastic::Helpers::FormHelper.builder = ::Erector::Rails::SemanticFormBuilder

#class Formtastic::FormBuilder
#  def semantic_fields_for(record_or_name_or_array, *args, &block)
#    # Add a :parent_builder to the args so that nested translations can be possible in Rails 3
#    options                  = args.extract_options!
#    options[:parent_builder] ||= ::Erector::Rails::SemanticFormBuilder #self
#
#    # Wrap the Rails helper
#    fields_for(record_or_name_or_array, *(args << options), &block)
#  end
#end
#