class Views::Site::AdminMenu < Erector::Widget
  #include Application::Helpers::Jmenu
  def admin_menu
    menu = ["Admin Menu",
            ['Site',
             [["Log In", new_user_session_path]],
             #[["Log Out", destroy_user_session_path, { :method => :get } ]],
             [["Site Settings", sites_path]],
             [["Reset", reset_sites_path, { :method => :delete }]],
             [["Reread", clear_sites_path, { :method => :delete }]],
             [["Processes", list_jobs_path,]],
             [['New Location', new_location_path]],
             [["Locations", list_locations_path]],
             [["Testimonials", list_testimonials_path]]
             ],
            [['Assets', list_assets_path],
             [["New Asset", new_asset_path,]],
             [["All", list_assets_path,]],
             [["Main Assets", select_assets_path(:type => 'misc')]],
             [["Emails", manage_emails_sites_path,]],
             [["Menu Items", select_assets_path(:type => 'link')]],
             [["Images", select_assets_path(:type => 'img')]],
             [["CSS", select_assets_path(:type => 'css')]],
             [["Outlines", select_assets_path(:type => 'outline')]],
             [["Services", select_assets_path(:type => 'services')]],
             [["Bios", select_assets_path(:type => 'bio')]],
             [["Resources", select_assets_path(:type => 'resources')]],
             [["Descriptions", select_assets_path(:type => 'description')]],
             [["Keywords", select_assets_path(:type => 'keywords')]],
             [["Directions", select_assets_path(:type => 'directions')]],
             [["Pricing", select_assets_path(:type => 'pricing')]]
             ],
            ['Courses',
             [['New Course Group', new_course_group_path]],
             [['New Course', new_course_path]],
             [['New Class', new_scheduled_course_path]],
             [['Course Groups', list_course_groups_path]],
             [['Courses', list_courses_path]],
             [['Classes', list_scheduled_courses_path]]
             ],
            ['Clients',
             [['New Student', new_student_path]],
             [['New Trainer', new_trainer_path]],
             [['New Admin', new_admin_path]],
             [['New Company', new_company_path]],
             [['Students', list_students_path]],
             [['Trainers', list_trainers_path]],
             [['Companies', list_companies_path]],
             [['Feedback', list_feedbacks_path]]
             ],
            ['Sales',
             [['Promotions', promotions_courses_path]],
             [['Payments', list_payments_path]],
             [['Invoices', list_invoices_path]],
             [['Signups', list_signups_path]]
             ]
            ]
  end

  def content
    #to_jmenu([admin_menu],true)
    #javascript_tag "$('ul.jMenu').jMenu();"

    menu_all = admin_menu
    h2 menu_all.shift
    div :class => 'accordion', :style => "width:90%;" do
      menu_all.each do |menu|
        item = menu.shift
        remote, text, link = case item
        when Array then [true, *item]
        else [false, item, '#']
        end
        h3 { link_to text, link, :remote => remote }
        div do
          ul :class => 'links' do
            menu.each do |sub|
              li :class => "rounded-corners-shadow" do
                args = sub.first
                options = args.extract_options!
                link_method = options[:method] ? :button_to : :link_to
                options[:class] = 'link'
                send link_method, *(args << options)
              end
            end
          end
        end
      end
    end

  end

end
