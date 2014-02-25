  class Views::Jobs::Tasks < Application::Widget

  needs :tasks => NyimJobs::Base::TASKS
  def widget_content

    h1 'Background Processes > Launch '

    tasks.each do |task|
      div do
        text NyimJobs::Base::TASKS_CLASSES[task].constantize.description
        text ' '
        form_tag launch_jobs_path(:task => task), :method => :post do
          check_box_tag :force
          text ' '
          submit_tag "Launch #{task}"
        end
      end
    end

  end

end
