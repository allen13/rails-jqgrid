# Rails-jqgrid
#Give it a model, everything else is optional.

#Current Tasks
# Need an on click function for rows
module ActionView
  module Helpers
    def jqgrid(model,opt={})
      
      #Random HTML id
      opt[:id] ||= model.to_s.pluralize + '_' + rand(36**4).to_s(36)
      
      #Default Grid options Begin
      opt[:fields] ||= model.column_names.to_s
      opt[:caption] ||= model.to_s.titleize.pluralize
      id = opt[:caption].parameterize
      opt[:url] ||=  %Q(/grid_data?model=#{model.to_s}&fields=#{opt[:fields]})
      opt[:datatype] ||= "json"
      opt[:colNames] ||= opt[:fields].split(",").collect {|col| col.titleize}
      opt[:colModel] ||= fields_to_colmodel(opt[:fields])
      opt[:pager] ||= "#jQuery('##{opt[:id]}_pager')" #The '#' at the start marks the string as a function, else it will be a string in json
      opt[:rowNum] ||= 10
      opt[:rowList] ||= [100,200,300]
      opt[:viewrecords] ||= true
      opt[:ondblClickRow] ||= %Q(#
      function(rowId, iRow, iCol, e)
      {
        if(rowId)
        {
          window.location = '#{url_for(:controller => model.name.pluralize,:action => 'show')}' + '/' + rowId;
        }
      }
      )
      #Default Grid opt End
      
      opt[:pager_opt] = {}
      #Default Pager options Begin
      opt[:pager_opt][:edit] ||= false
      opt[:pager_opt][:add] ||= false
      opt[:pager_opt][:del] ||= false
      opt[:pager_opt][:search] ||= false
      opt[:pager_opt][:refresh] ||= false
      opt[:pager_opt][:view] ||= false
      opt[:pager_opt][:editoptions] ||= ""
      opt[:pager_opt][:addoptions] ||= ""
      opt[:pager_opt][:deleteoptions] ||= ""
      opt[:pager_opt][:searchoptions] ||= ""
      #Default Pager options End
      
      #Grid Javascript Begin
      %Q(
        <script type="text/javascript">
        
          jQuery(document).ready(function(){
          var main_grid = jQuery('##{opt[:id]}').jqGrid(
            #{opt.to_json(:exclude => [:pager_opt,:fields,:id])}
          );
          
          main_grid.navGrid('##{opt[:id]}_pager',
          #{opt[:pager_opt].to_json(:exclude =>[:editoptions,:addoptions,:deleteoptions,:searchoptions])},
          {#{opt[:pager_opt][:editoptions]}},
          {#{opt[:pager_opt][:addoptions]}},
          {#{opt[:pager_opt][:deleteoptions]}},
          {#{opt[:pager_opt][:searchoptions]}}
          );
          
          main_grid.filterToolbar();
          
        });
        </script>
        <table id="#{opt[:id]}" class="scroll ui-state-default" cellpadding="0" cellspacing="0"></table>
        <div id="#{opt[:id]}_pager" class="scroll" style="text-align:center;"></div>
      )
      #Grid Javascript End
    end
    
    def fields_to_colmodel(fields)
      fields_a = fields.split(",")
      colmodel = []
      fields_a.each do |field|
        colmodel << {:name => field,:index =>field}
      end
      colmodel
    end
    
    def jqgrid_theme(theme)
      includes = capture { stylesheet_link_tag "jqgrid/#{theme}/jquery-ui-1.7.2.custom" }
      includes << capture { stylesheet_link_tag "jqgrid/ui.jqgrid" }
      includes << capture { javascript_include_tag "jqgrid/jquery-1.3.2.min" }
      includes << capture { javascript_include_tag "jqgrid/jquery.jqGrid.min" }
      includes << capture { javascript_include_tag "jqgrid/i18n/grid.locale-en" }
      includes
    end
  end
end

module JqgridJson
  
  def to_jqgrid_json(fields,total_rows,per_page,current_page)
    
    jqgrid = {}
    total_pages = (total_rows/per_page)+1
    jqgrid[:page] = current_page
    jqgrid[:records] = total_rows
    jqgrid[:total] = total_pages
    
    fields_a = fields.split(",")
    
    rows = []
    each do |row|
      value_a = []
      fields_a.each do |field|
        value_a << row[field]
      end
      rows << {:id => row.id, :cell => value_a}
    end
    
    jqgrid[:rows] = rows
    jqgrid.to_json
    
  end
  
end

class Array
  include JqgridJson
  def to_s
    str = ""
    each do |value|
      str << value + ","  
    end
    str.chop!
    str
  end
end

class String
  def to_json(options = nil)
    #If the '#' symbol is thefirst character, this is a json function
    #Return without the first '#' or parenthesis
    if self.at(0) == '#'
      self.sub(/(#)/,'')
    else
    #Otherwise use the original definition from the ActiveSupport library
    #Which will make it a json string
      json = '"' + gsub(ActiveSupport::JSON::Encoding.escape_regex) { |s|
        ActiveSupport::JSON::Encoding::ESCAPED_CHARS[s]
      }
      json.force_encoding('ascii-8bit') if respond_to?(:force_encoding)
      json.gsub(/([\xC0-\xDF][\x80-\xBF]|
              [\xE0-\xEF][\x80-\xBF]{2}|
              [\xF0-\xF7][\x80-\xBF]{3})+/nx) { |s|
                s.unpack("U*").pack("n*").unpack("H*")[0].gsub(/.{4}/, '\\\\u\&')
      } + '"'
    end
  end
end