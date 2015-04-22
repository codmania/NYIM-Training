class UploadsController < ActionController::Base
  def create
    asset = Asset.create(normalize_param(params))
    render :text => %Q"<script type='text/javascript'>
              window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{root_url}#{escape_single_quotes(asset.asset.url)}');
            </script>"
  end


  protected

  def escape_single_quotes(str)
    str.gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
  end

  def normalize_param(*args)
    value = args.first.inject({}) do |option, (k,v) |
      k.eql?('upload') ? option['asset'] = v : option[k] = v;
      option
    end

    ['langCode','controller', 'action', 'CKEditor', 'CKEditorFuncNum'].each {|key| value.delete(key)}

    value['name'] = value['asset'].original_filename
    value['format'] = 'img'

    value
  end
end