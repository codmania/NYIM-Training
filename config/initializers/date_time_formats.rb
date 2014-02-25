Time::DATE_FORMATS.merge!(
:month_and_year => "%B %Y",
:short_ordinal => lambda { |time| time.strftime("%B #{time.day.ordinalize}") },
:short_date_uk =>  "%d %b %Y",
:default => "%b %d %l:%M%p",
:short => "%b %d %Y",
:js => "%B %d, %Y %H:%M",
:time => "%l:%M%p"
)