class Application::Widget < Erector::Widget

  include Application::Widgets::Extensions

  needs :content_for_blocks => { }, :resource => nil, :resource_class => nil

  def self.define_needs_accessors
    attr_accessor *needed_variables
  end

  def expose_controller_instance_variables
    if respond_to? :controller
      if controller.resourceful?
        self.resource       ||= controller.resource
        self.resource_class ||= controller.resource_class
      end
      (self.class.needed_variables - @assigns).each do |x|
        value = controller.instance_variable_get("@#{x}")
        send("#{x}=", value) unless value.nil?
      end
    end
  end

  def initialize(assigns = { }, &block)
    self.class.define_needs_accessors
    @assigns = assigns.keys
    puts "\n\n================"
    puts self.class.inspect
    puts assigns.inspect
    super
  end

  def content(&block)
    expose_controller_instance_variables
    content_for_blocks.each do |name, &b|
      content_for name, &b if content_for(name).blank?
    end
    widget_content(&block)
  end

  def call_block(*args)
    args << self if args.empty?
    @_block.call(*args) if @_block
  end

end
