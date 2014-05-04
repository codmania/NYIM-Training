# coding: utf-8
class Views::Layouts::NyimEntirePage < Erector::Widget
  def content
    rawtext '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
    html do
      head do
        meta 'http-equiv' => 'Content-Type', :content => 'text/html; charset=UTF-8'
        rawtext '<!-- TemplateBeginEditable name="doctitle" -->'
        title do
          text 'New York Interactive Media'
        end
        rawtext '<!-- TemplateEndEditable -->'
        rawtext '<!-- TemplateBeginEditable name="head" -->'
        rawtext '<!-- TemplateEndEditable -->'
        link :href => '/stylesheets/nyim2011.css', :rel => 'stylesheet', :type => 'text/css'
        rawtext '<!--[if IE 5]>'
        style :type => 'text/css' do
          text '/* place css box model fixes for IE 5* in this conditional comment */.thrColFixHdr #main { width: 180px; }.thrColFixHdr #right { width: 190px; }'
        end
        rawtext '<![endif]-->'
        rawtext '<!--[if IE]>'
        style :type => 'text/css' do
          text '/* place css fixes for all versions of IE in this conditional comment */.thrColFixHdr #right, .thrColFixHdr #main { padding-top: 30px; }.thrColFixHdr #center { zoom: 1; }/* the above proprietary zoom property gives IE the hasLayout it needs to avoid several bugs */'
        end
        rawtext '<![endif]-->'
      end
      body :class => 'thrColFixHdr' do
        div :class => 'rounded-corners-shadow', :id => 'container' do
          div :id => 'header' do
            div :class => 'shadow-shine', :id => 'topbar' do
              div :id => 'logo' do
              end
              div :id => 'address' do
                text '1 Union Square West, Suite 903, NY, NY • Information and Booking: 212.658.1918'
              end
              div :id => 'mail' do
                a :href => 'mailto:mailto:faye@training-nyc.com?Subject=WebMail' do
                  img :src => '/stylesheets/images/mail.png', :width => '50', :height => '37', :alt => 'Email'
                end
              end
            end
            div :id => 'menu1' do
              div :class => 'rounded-corners-shadow', :id => 'classbutton' do
                text 'Find Classes:'
              end
              div :class => 'rounded-corners-shadow', :id => 'classes' do
                ul do
                  rawtext '<!-- #BeginLibraryItem "/Library/classes-menu.lbi" -->'
                  li do
                    a :href => '#' do
                      text 'Excel'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'PowerPoint'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Dreamweaver'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Fashion'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Flash'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'InDesign'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Photoshop'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'QuickBooks'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'SPSS'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'VBA'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Access'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Word'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'FileMaker'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Project'
                    end
                  end
                  rawtext '<!-- #EndLibraryItem -->'
                end
              end
              div :class => 'rounded-corners-shadow', :id => 'signup' do
                a :href => '#' do
                  text 'Sign Up'
                end
              end
            end
            div :id => 'menu2' do
              div :class => 'rounded-corners-shadow', :id => 'infobutton' do
                text 'Information:'
              end
              div :class => 'rounded-corners-shadow', :id => 'info' do
                rawtext '<!-- #BeginLibraryItem "/Library/info.lbi" -->'
                ul do
                  li do
                    a :href => '#' do
                      text 'Corporate Training'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'About Us'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Policies'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Client List'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Client Testimonials'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Directions'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Trainer Bios'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Forum'
                    end
                  end
                  li do
                    a :href => '#' do
                      text 'Feedback'
                    end
                  end
                end
                rawtext '<!-- #EndLibraryItem -->'
              end
              div :class => 'rounded-corners-shadow', :id => 'login' do
                a :href => '#' do
                  text 'Lo	g In'
                end
              end
            end
            rawtext '<!-- end #header -->'
          end
          div :id => 'main' do
            rawtext '<!-- TemplateBeginEditable name="MainContent" -->'
            h1 do
              text 'The highest rated corporate & group computer training in new york'
            end
            h2 do
              text 'Why we are your best choice:'
            end
            ul do
              li :class => 'rounded-corners-shadow' do
                text 'Certified Trainers, minimum of 10 yrs experience'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Since 1998'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Lifetime online forum support'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Top Notch feedback and client list'
                br
              end
            end
            h2 do
              text 'Group classes:'
              br
            end
            ul do
              li :class => 'rounded-corners-shadow' do
                text 'LIFETIME Unlimited retakes'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Micro Classes (3-6 people)'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Hands on (with fast computers)'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Hours of after class video training'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Classes don\'t get cancelled'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Materials constantly updated'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Free Coffee, Tea, Chocolate, water'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Comfortable, Convenient location'
              end
              li :class => 'rounded-corners-shadow' do
                text '75% off all future versions'
              end
              li :class => 'rounded-corners-shadow' do
                text 'Shortcut Efficiency driven'
              end
            end
            rawtext '<!-- TemplateEndEditable -->'
            rawtext '<!-- end #main -->'
          end
          div :id => 'right' do
            rawtext '<!-- TemplateBeginEditable name="Right" -->'
            div :id => 'badge' do
            end
            div :class => 'rounded-corners-shadow', :id => 'sale' do
              rawtext '<!-- #BeginLibraryItem "/Library/specials.lbi" -->'
              h1 do
                text 'Specials'
              end
              p do
                text '$135'
                a :href => '#' do
                  text 'Excel'
                end
                text 'or'
                a :href => '#' do
                  text 'PowerPoint'
                end
                text 'for Business         Blowout! Normally $280)         15% off all Web Design        Classes'
                br
                text '(book before 9/15)'
              end
              h2 do
                a :href => '#' do
                  text 'Current Sales Packages'
                end
              end
              rawtext '<!-- #EndLibraryItem -->'
            end
            div :class => 'rounded-corners-shadow', :id => 'location' do
            end
            
            h4 :class => 'caption' do
              text '&nbsp;'
            end
            rawtext '<!-- #BeginLibraryItem "/Library/site location.lbi" -->'
            h4 :class => 'caption' do
              text 'Heart of Union Square'
            end
            rawtext '<!-- end #right -->'
            p do
              text '1 Union Square West and 14ths St.'
            end
            p do
              text '[Right off 4,5,6,R,Q,W,N,L,F,M trains]'
            end
            rawtext '<!-- #EndLibraryItem -->'
            rawtext '<!-- TemplateEndEditable -->'
          end
          
          div :id => 'center' do
            rawtext '<!-- TemplateBeginEditable name="Center" -->'
            h1 do
              text 'Our Specialties Include:'
            end
            rawtext '<!-- #BeginLibraryItem "/Library/program table.lbi" -->'
            table :width => '100%', :border => '0', :id => 'programs' do
              tr do
                td do
                  h2 do
                    text 'Business Track'
                  end
                  p do
                    text 'Microsoft Office'
                  end
                end
                td do
                  h2 do
                    text 'Design Track'
                  end
                  p do
                    text 'Adobe Creative Suite'
                  end
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/excel.png', :width => '40', :height => '34', :class => 'picspace'
                    text 'Excel'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/ps.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'Photoshop'
                  end
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/ppt.png', :width => '40', :height => '34', :class => 'picspace'
                    text 'PowerPoint'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/dw.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'Dreamweaver'
                  end
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/word.png', :width => '40', :height => '34', :class => 'picspace'
                    text 'Word'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/ill.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'Illustrator'
                  end
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/access.png', :width => '40', :height => '34', :class => 'picspace'
                    text 'Access'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/id.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'InDesign'
                  end
                end
              end
              tr do
                td do
                  text '&nbsp;'
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/flash.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'Flash'
                  end
                end
              end
              tr do
                td do
                  h2 do
                    text 'Specialty'
                  end
                end
                td do
                  text '&nbsp;'
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/spss.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'SPSS'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/qb.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'QuickBooks'
                  end
                end
              end
              tr do
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/fm.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'FileMaker'
                  end
                end
                td do
                  a :href => '#' do
                    img :src => '/stylesheets/images/icons/proj.png', :width => '40', :height => '40', :class => 'picspace'
                    text 'Project'
                  end
                end
              end
            end
            rawtext '<!-- #EndLibraryItem -->'
            p do
              text '&nbsp;'
            end
            rawtext '<!-- TemplateEndEditable -->'
            rawtext '<!-- end #center -->'
          end
          rawtext '<!-- This clearing element should immediately follow the #center div in order to force the #container div to contain all child floats -->'
          br :class => 'clearfloat'
          
          div :class => 'rounded-bottom-corners', :id => 'footer' do
            div :id => 'testimonials' do
              h3 do
                text 'CLIENT TESTIMONIALS'
                a :href => '#' do
                  text 'MORE »'
                end
              end
              p do
                text '"Overall, I would rate the preparation, use of time, knowledge of material and general kindness as one of the best training classes/sessions that I have ever attended.”'
              end
              p do
                text '— K. Burton of Microsoft Corp., received Excel & PowerPoint Private Training'
              end
            end
            div :id => 'smallprint' do
              rawtext '<!-- #BeginLibraryItem "/Library/smallprint.lbi" -->'
              a :href => '#' do
                img :src => '/stylesheets/images/cpe.png', :width => '62', :height => '54', :border => '0', :align => 'left', :class => 'picspace'
                text 'NYIM is an approved CPE Training Center and allows you to receive CPE Credit in New York, New Jersey, Connecticut as well as all states.'
              end
              rawtext '<!-- #EndLibraryItem -->'
            end
            div :id => 'clientlist' do
              h3 do
                text 'PARTIAL CLIENT LIST'
                a :href => '#' do
                  text 'MORE »'
                end
              end
              p do
                text 'American Express • dELiA*s • Deloitte & Touche USA LLP • Executive Office of The President of the United States • Fitch Ratings • HBO • HSBC Bank • Major League Baseball • Marks, Paneth & Shron • Maxim Magazine • McGraw – Hill • Microsoft • Morgan Stanley • Motorola Inc. • MTV Networks • Salomon Brothers • Scholastic • Starbucks Coffee Company • T-Mobile • Corcoran Group • New York Post • Village Voice • Toyota • Victoria\'s Secret •'
              end
            end
            rawtext '<!-- end #footer -->'
          end
          rawtext '<!-- end #container -->'
        end
      end
    end  
  end
end
