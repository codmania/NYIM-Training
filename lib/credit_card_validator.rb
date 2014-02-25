class CreditCardValidator < ActiveModel::EachValidator
  # validations for activemerchant creditcard value objects
  # potentially extended with supported card types class method used for validation
  def validate_each(record, attribute, card)

    requires_verification_value = options[:requires_verification_value]
    supported_cardtypes = options[:supported_cardtypes] || ActiveMerchant::Billing::LinkpointGateway.supported_cardtypes
    configuration = {:on => :save, :only_integer => false, :allow_nil => false}
    configuration.update(options)
    if card.is_a? ActiveMerchant::Billing::CreditCard
      card.errors.add :type, "unsupported card type" unless card.type.is_a?(String) &&
          supported_cardtypes.include?(card.type.to_sym)
      card.require_verification_value = requires_verification_value
      card.validate
      # merge the errors object into billing info errors...
      # stupid there is no merge method for errors
      #
      card.errors.each { |k, v| v.each { |e| record.errors.add(k, e) } }
      #card_errors = card.errors.to_a.collect {|a| a.join(" ")}.join(";\n")
      #record.errors.add(attribute, card_errors) unless card_errors.blank?
    else
      record.errors.add attribute, "cannot be mapped to a credit card?"
    end
  end
end

