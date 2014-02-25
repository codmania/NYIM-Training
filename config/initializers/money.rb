#composed_of :price,
#  :class_name => "Money",
#  :mapping => [%w(cents cents), %w(currency currency_as_string)],
#  :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }
#https://github.com/tobi/money