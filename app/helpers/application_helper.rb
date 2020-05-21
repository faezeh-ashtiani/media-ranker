module ApplicationHelper
  def alert_class(flash)
    return flash[:success] ? "alert alert-success" : "alert alert-warning"
    # if flash[:success] 
    #   "alert alert-success"
    # elsif flash[:warning]
    #   "alert alert-warning"
    # end
  end
end
