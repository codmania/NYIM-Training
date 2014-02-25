module IpAddressAttribute
  #http://basic70tech.wordpress.com/2007/04/13/32-bit-ip-address-to-dotted-notation-in-ruby/
  #http://norbauer.com/notebooks/code/notes/storing-ip-addresses-as-integers
  def self.included(base)
    base.extend IpAddressAttributeClassMethods
  end

  module IpAddressAttributeClassMethods
    def ip_address(*attrs)
      attrs.each do |attr|
        define_method "#{attr}=" do |ip_string|
          if ip_string
            address = ip_string.split('.').map(&:to_i).pack('C*').unpack('N').first
            #ip_string.split('.').inject(0) { |total,value| (total << 8 ) + value.to_i }
            write_attribute attr, address
          end
        end
        define_method attr do
          address = read_attribute attr
          #[24, 16, 8, 0].collect {|b| (address >> b) & 255}.join('.')
          if address
            [address].pack('N').unpack('C*').join '.'
          else
            ""
          end
        end
        scope attr, (lambda { |ip_string|
          search = ip_string.split('.').map(&:to_i).pack('C*').unpack('N').first
          where(attr => search)
        })
        
      end
    end

  end

end