module ApplicationHelper
  def alert_class(flash)
    if flash[:success] 
       "alert alert-success" 
    elsif flash[:warning] 
      "alert alert-warning"
    end
  end
end
