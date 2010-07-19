class GridDataController < ApplicationController
  def index
    model = eval(params["model"])
    fields = params["fields"].split(",")
    
    find = {}
    find[:select] = params["fields"] + ",id"
    find[:order] = params["sidx"] + " " + params["sord"] unless params["sidx"].empty?
    conditions = filter_bar_conditions(fields,params)
    find[:conditions] = conditions unless conditions.empty?
    
    rows = model.find(:all,find)
    row_count = model.count(:all,:conditions => find[:conditions])
    
    render :json => rows.to_jqgrid_json(
      params["fields"],#fields
      row_count,#total records
      params["rows"].to_i,#rows per page
      params["page"].to_i)#current page
  end
  
  def filter_bar_conditions(fields,params)
    conditions = ""
    fields.each do |field|
      conditions << "#{field} LIKE '#{params[field]}%' AND " unless params[field].nil?
    end
    conditions.chomp("AND ")
  end
end
