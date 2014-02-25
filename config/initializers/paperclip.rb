# https://github.com/thoughtbot/paperclip
Paperclip.options[:command_path] = `which convert|perl -pe 's/convert//'`
