class KnittingController < ApplicationController
  def index
    @projects = Project.load_projects
  end
end
