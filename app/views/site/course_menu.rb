class Views::Site::CourseMenu < Erector::Widget
  
  include Application::Helpers::Jmenu
 
  def course_group_menu_item(g)
    menu = [[g.short_name, course_group_path(g) ]]
    #if admin? || Rails.env.development?
    #  menu << [['Add Course', new_course_path(:course => { :course_group_id => g.id })]]
    #  menu << [['Edit', edit_course_group_path(g)]]
    #  menu << [['Delete', course_group_path(g), { :method => :delete } ]]
    #end
    #menu
  end
  
  def content
    course_groups = CourseGroup.active
    to_jmenu course_groups.empty? ? [[['Add New', new_course_group_path ]]] : course_groups.map { |g| course_group_menu_item(g) }
  end
  
  
end
