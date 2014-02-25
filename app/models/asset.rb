class Asset < ActiveRecord::Base

  FORMATS = Mailers::UserMailer::FORMATS.map(&:to_s)

  FORMATS << 'link'
  FORMATS << 'css'

  has_attached_file :asset,
    :path => ":rails_root/public/system/#{Rails.env}/:attachment/:id/:style/:filename",
    :url  => "/system/#{Rails.env}/:attachment/:id/:style/:filename"

  validates_attachment_presence :asset #, :unless => proc { |r| r.type == }

  # validates_attachment_content_type :asset, :content_type => ['text/html', 'text/plain', "application/octet-stream", "application/x-octet-stream"]

  validates_attachment_size :asset, :in => 0..5000000

  attr_accessor :content
  before_validation :write_content

  validates :name, :presence => true
  validates :format, :inclusion => FORMATS, :uniqueness => { :scope => [:name, :index] }

  def self.asset(name)
    name = canonize_name(name)
    a    = find_by_name(name) || bootstrap_asset(name)
  end

  has_asset :description, :keywords

  before_validation :canonize_name

  def self.canonize_name(name)
    name.to_s.gsub(/ /, '_').underscore
  end

  def canonize_name
    self.name = self.class.canonize_name(name)
  end

  def self.bootstrap_asset(name)
    file = File.new(File.join(Rails.root, 'public/design/default_assets', "#{name}.html.erb")) rescue return
    Asset.create!(:name => name, :format => 'html', :asset => file)
  end

  def self.assets(name)
    assets!(name).inject({ }) do |coll, a|
      coll[a.ref] = a
      coll
    end
  end

  def self.assets!(name)
    name = canonize_name(name)
    find_all_by_name(name)
  end

  def ref
    "#{self.format}#{index||''}".to_sym
  end

  def read
    asset && File.read(asset.path) rescue nil
  end

  def write_content
    unless content.blank? || asset_updated_at_changed?
      tempfilename = "#{name}_#{index || 0}.#{format}"
      file         = asset && asset.path ?
        File.open(asset.path, 'w') :
        File.new(File.join('/tmp', tempfilename), File::CREAT|File::TRUNC|File::RDWR, 0644)
      file.write content
      #logger.debug [content, asset_updated_at_changed?, file, asset, asset.path].inspect
      self.asset = file unless asset && asset.path
      self.asset_updated_at = Time.now
      file.close
    end
  end

  [:link, :css, :img].each do |s|
    scope :"#{s}_scope", lambda { where(:format.eq => s.to_s).order(:index.asc, :created_at.desc) }
  end

  [:outline, :bio, :resources, :description, :keywords, :directions, :pricing, :services].each do |s|
    scope :"#{s}_scope", lambda { where(:name.matches => "%#{s}").order(:index.asc, :created_at.desc) }
  end

  misc = ['main', 'about_us', 'policies', 'signup', 'success', 'promotion', 'packages', 'corporate_training']
  scope :misc_scope, lambda { where(:name.in => misc).order(:name.asc) }

end
