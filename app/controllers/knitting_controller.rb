class KnittingController < ApplicationController
  def index
    success, response = Project.load_projects
    if success
      @projects = response
    else
      @projects = []
      flash[:error] = response
    end
  end
end
