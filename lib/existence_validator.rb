class ExistenceValidator < ActiveModel::EachValidator
  def validate_each(record,attr_name,value)

    unless (assoc = record.class.reflect_on_association(attr_name) || record.class.superclass.reflect_on_association(attr_name)) && assoc.macro == :belongs_to
      raise ArgumentError, "Cannot validate existence of :#{attr_name} because it is not a belongs_to association."
    end
    fk_value = record.send(assoc.foreign_key)
    errors = false
    if fk_value.blank?
      unless options[:allow_nil]
        record.errors.add(attr_name, options[:message])
      errors = true
      end
    else
      if (foreign_type = assoc.options[:foreign_type]) # polymorphic
        foreign_type_value = record.send(foreign_type)
        if !foreign_type_value.blank?
        assoc_class = foreign_type_value.constantize
        else
          record.errors.add(attr_name, options[:message])
        errors = true
        end
      else # not polymorphic
      assoc_class = assoc.klass
      end

      unless assoc_class && assoc_class.exists?(fk_value)
        record.errors.add(attr_name, options[:message])
      errors = true
      end

      conditions = options[:conditions] || {}
      unless conditions.empty? || fk_value.blank?
        object = assoc_class.find(fk_value)
        conditions.each do |message,function|
          unless (function.call(object) rescue object.send(function))
          record.errors.add(attr_name, message)
          errors = true
          end
        end
      end
    end
  end

end
