#If you read the code for ActionDispatch’s Railtie, you’ll see the line:
#config.action_dispatch.rack_cache = {
#  :metastore => "rails:/",
#  :entitystore => "rails:/",
#  :verbose => true,
#}
#
#The solution is then to set the custom cache key in production.rb like this:
#config.action_dispatch.rack_cache[:cache_key] = Proc.new { |request|
#  [I18n.locale, ':', Rack::Cache::Key.new(request).generate].join
#}