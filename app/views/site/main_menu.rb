class Views::Site::MainMenu < Erector::Widget

  include Application::Helpers::Jmenu

  def main_menu
    menu = [
        [["Corporate Training", display_asset_path('Corporate Training')]],
        [["About Us", display_asset_path('About Us')]],
        [["Trainer Bios", trainers_path]],
        [["Testmonials", testimonials_path]],
        [["Client List", companies_path]],
        [["Policies", display_asset_path('Policies')]],
        [["Directions", locations_path]],
        #[["Forum", site(:forum_link), { :remote => false }]]
    ] +
        Asset.link_scope.where(:index.gt => 0).map(&:read).reject(&:nil?).map do |file|
          link, url = file.split(',').map(&:strip)
          link = 'Missing asset/url' if url.blank?
          if /\//.match url
            [[link, url, { :remote => false }]]
          else
            [[link, (display_asset_path(url) rescue '')]]
          end
        end
  end

  def content
    to_jmenu(main_menu)
  end

end
