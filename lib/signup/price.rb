module Signup::Price
  def self.included( recipient )

    recipient.class_eval do
      composed_of :price, :class_name => 'Money', :mapping => [%w(price cents)],
        :allow_nil => true, :converter => proc { |c| c.blank? ? Struct.new(:cents).new : Money.new(c.to_f * 100) }
      def price!
        self.price = calculate_price
      end

      def price_uptodate?
        price != calculate_price
      end

      def free?
        calculate_price == Money.new(0)
      end

      def discount_price(discount=0)
        (scheduled_course.price || Money.new(0)) * (1 - discount/100.0)
      end

      def calculate_price
        return if deleted?
        returning_customer ||= submitter.admin? ? student.returning_customer? : submitter.returning_customer?
        # this calculates the price irrespective of status
        if cancelation? then
          self.discount_description = 'late cancelation fee'
          Money.new((site(:refund_fee)||0)*100)
        elsif relatives.canceled.first && relatives.canceled.first.not_too_late?
          # :FIXME this makes sense only if free retakes forever kicks in AFTER class is complete
          self.discount_description = 'late reschedule fee'
          Money.new((site(:retake_fee)||0)*100)
        elsif !cousins.completed_or_awarded.empty? #free retakes forever
          self.discount_description = 'free retakes forever'
          Money.new(0)
        else
          discount_description = ""
          max_discount = 0
          discounts = {
            "company discount" => submitter.discount || 0,
            "promotional price" => promotional? ? promotional_discount : 0,
            "returning customer" => (returning_customer ? site(:returning_customer_discount) : 0)
          }
          discounts.each do |key,value|
            if max_discount <= value
              discount_description = key
              max_discount = value
            end
          end
          discount_description += " (-#{max_discount}%)"
          self.discount_description = max_discount == 0 ? '' : discount_description
          discount_price max_discount
        end
      end
    end
  end
end
