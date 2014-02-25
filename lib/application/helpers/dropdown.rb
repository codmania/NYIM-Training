module Application
  module Helpers
    module Dropdown
      def to_dropdown(options)
        collection = options[:collection] || []
        id_f = options[:id] || :id
        name_f = options[:name] || :name
        dropdown = collection.map { |x| [x.send(name_f), x.send(id_f)] }
        text = options[:blank]
        dropdown.unshift([text,nil]) if text
        add = options[:add]
        dropdown = dropdown + add if add
        options[:tag] ? options_for_select(dropdown, options[:selected]) : dropdown
      end
    end
  end
end
