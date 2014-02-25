class SiteSettings < ActiveRecord::Migration
  def self.up
    remove_column :sites, :asset_root_dir, :terms_and_conditions
    add_column :sites, :seo_tag, :string
  end

  def self.down
    remove_column :sites, :seo_tag
    [:asset_root_dir, :terms_and_conditions].each do |c|
      add_column :sites, c, :string
    end
  end
end
