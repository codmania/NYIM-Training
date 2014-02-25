class Views::Testimonials::Index < Application::Widgets::List
  
  
  def widget_content
    h1 'Client Testimonials'
    super
    bootstrap if collection.empty? && Rails.env.development?
  end

  def item(f)
    p :class => 'box' do
      text f.text
      br
      br
      text " - #{f.name} attended #{f.course.name}"
    end
  end

  def bootstrap
    p :class => 'box' do
      text "I recently had a private training session with Joe Tandle from NYIM. The overall experience was great. I feel the instructor was well educated on the tools I needed in order to succeed in my current role. The pace of the class was wonderful. It allowed me
      to ask thoughtful questions on ambiguous material and in return the answers were clear and concise. The instructor was well-prepared.
      He also supplied me with supporting documentation to use at all times.
      He even went so far as to provide me the opportunity to call him at anytime in the future if I ever ran into a problem.
      Overall, I would rate the preparation, use of time, knowledge of material and general kindness as one of the best training classes/sessions
      that I have ever attended.
      I  have and will continue to recommend Joe Tandle and the folks at NYIM to others."
      br
      br
      text '- K. Burton of Microsoft Corp., received Excel and PowerPoint Private Training'
    end
    p :class => 'box' do
      text "The instructor was very helpful. He really knows his  PowerPoint. I feel that I go the attention I needed. I think it's  wonderful to have a smaller class because that way the instructor has  more time to spend with the student. New York Interactive Media is the  BEST place to take computer classes. I was very impressed with this  PowerPoint class. HOORAY!!!! Whatever didn't register in my head is  written in black and white in the manual. This makes things more easier  for the student. I NEVER had any connection with PowerPoint but today's  class has given me a better perspective."
      br
      br
      text '- A. Lypeckyi attended PowerPoint 2007 for Business Group Class'
    end
    p :class => 'box' do
      text 'Joe was wonderful and really knowledgable. He also made  sure to keep closely in touch with each of our progress as the training  progressed'
      br
      br
      text '- Global Health Strategies, received PowerPoint 2007 Private Training'
    end
    p :class => 'box' do
      text 'Glenn  is extremely knowledgable of excel and can  TEACH the material.  I loved this class; Glenn and five of us. Very  intimate, that is what I paid for.  His knowledge of excel taught to me  and my classmates were great because we all had somthing to add.  I even  brought up this class on a job interview.  Very satisfied!!!'
      br
      br
      text '- K.B., attended Advanced Excel 2003 for Business Group Class'
    end

  end
end

