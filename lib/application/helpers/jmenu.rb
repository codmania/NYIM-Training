module Application::Helpers::Jmenu
  
  def to_jmenu(menu,real=false)
    if real
      to_jmenu_rec(menu, nil, { :id => 'jMenu', :class => 'jMenu' }, { :class => "fNiv" })
    else
      to_jmenu_rec(menu, nil, { }, { })
    end
  end
  
  def to_jmenu_rec(nodes=[],li_options={},ul_options={},a_options={})
    return unless nodes
    raise ArgumentError, "illegal menu structure '#{nodes.inspect}'" unless nodes.is_a?(Array)
    return if nodes.empty?
    raise ArgumentError, "illegal '#{ul_options}'" unless ul_options.is_a?(Hash)
    ul ul_options do 
      nodes.each do |node|
        li li_options do
          case node
            when String, Symbol then a(a_options) { text node }
            when Array then
            name = node.shift #can be nil
            case name
              when String, Symbol then a(a_options) { text name }
              #when Array then a(a_options.merge(name.extract_options!)) { text *name }
              
              when Array then (name, url_options, html_options) = name 
              html_options = html_options.ifnil?(a_options) { |x| a_options.merge(x) }
              link_to name, url_options, html_options
            else
              raise ArgumentError, "illegal menu structure '#{name.inspect}'" 
            end
            to_jmenu_rec(node)
          end # case
          
        end # li
        
      end # each
    end # ul
    
  end # def
end