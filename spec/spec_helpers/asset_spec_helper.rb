module AssetSpecHelper
  def file(contents)
    f = Tempfile.new('asset_spec_helper')
    f.write contents
    f
  end

  def create_asset(name,format,index=nil)
    f = file "#{format} #{name}" 
    options = { :name => name, :asset => f, :format => format, :index => index }
    Asset.create options
    f.unlink
  end

  def create_mail(name,*formats)
    formats = ['text','html'] if formats.empty?
    formats.each do |format| create_asset(name,format) end
  end

end