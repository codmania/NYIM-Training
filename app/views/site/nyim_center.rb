class Views::Site::NyimCenter < Erector::Widget
  
  def content 
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
              img :src => '../images/icons/excel.png', :width => '40', :height => '34', :class => 'picspace'
              text 'Excel'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/ps.png', :width => '40', :height => '40', :class => 'picspace'
              text 'Photoshop'
            end
          end
        end
        tr do
          td do
            a :href => '#' do
              img :src => '../images/icons/ppt.png', :width => '40', :height => '34', :class => 'picspace'
              text 'PowerPoint'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/dw.png', :width => '40', :height => '40', :class => 'picspace'
              text 'Dreamweaver'
            end
          end
        end
        tr do
          td do
            a :href => '#' do
              img :src => '../images/icons/word.png', :width => '40', :height => '34', :class => 'picspace'
              text 'Word'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/ill.png', :width => '40', :height => '40', :class => 'picspace'
              text 'Illustrator'
            end
          end
        end
        tr do
          td do
            a :href => '#' do
              img :src => '../images/icons/access.png', :width => '40', :height => '34', :class => 'picspace'
              text 'Access'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/id.png', :width => '40', :height => '40', :class => 'picspace'
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
              img :src => '../images/icons/flash.png', :width => '40', :height => '40', :class => 'picspace'
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
              img :src => '../images/icons/spss.png', :width => '40', :height => '40', :class => 'picspace'
              text 'SPSS'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/qb.png', :width => '40', :height => '40', :class => 'picspace'
              text 'QuickBooks'
            end
          end
        end
        tr do
          td do
            a :href => '#' do
              img :src => '../images/icons/fm.png', :width => '40', :height => '40', :class => 'picspace'
              text 'FileMaker'
            end
          end
          td do
            a :href => '#' do
              img :src => '../images/icons/proj.png', :width => '40', :height => '40', :class => 'picspace'
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
  end
end
