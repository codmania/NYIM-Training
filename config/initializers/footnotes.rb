# http://github.com/josevalim/rails-footnotes

if defined?(Footnotes) && Rails.env.development?    
  Footnotes.run!
  Footnotes::Filter.notes = [:session, :cookies, :params, :routes, :env, :queries]
  #Footnotes::Filter.prefix = 'txmt://open?url=file://%s&amp;line=%d&amp;column=%d'
end
