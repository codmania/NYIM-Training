class Object
  def ifnil?(*args,&block)
    if block_given?
      is_a?(NilClass) ? args.shift : block.call(self)
    else
      args.empty? or raise ArgumentError, "no args unless block given"
      is_a?(NilClass)
    end
  end

end

class ProxyString < String
  def name
    self
  end
end

class ActiveRecord::Base

  class_attribute :init_defaults
  def initialize_with_defaults(*attrs, &block)
    initialize_without_defaults(*attrs) do |o|
      set_defaults
      yield(o) if block_given?
    end
    self
  end

  alias_method_chain :initialize, :defaults

  # checking value on the already initialized object takes care that
  # protected attributes can also be initialized
  def set_defaults
    d = init_defaults
    d && case d
    when Hash
      d.each_pair do |attr, value|
        if value.respond_to?(:call)
        value = value.call(self)
        end
        send "#{attr}=", value if send(attr).nil? #&& !value.blank?
      end
    when Proc, Method
      d.call(self)
    else
    raise ArgumentError, "invalid default statement: #{d.inspect}"
    end

  end

  def self.default(*attr,&block)
    self.init_defaults = attr.shift || block
  end

  def self.has_asset(*args)
    class_attribute :_assets, :instance_reader => false, :instance_writer => false
    self._assets=args
    args.each do |asset|
      define_method "#{asset}_asset_name" do
        "#{name} #{asset}"
      end
      define_method "#{asset}_asset" do
        Asset.asset send "#{asset}_asset_name"
      end
    end
  end

end
