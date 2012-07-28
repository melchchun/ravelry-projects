require 'spec_helper'

class KnittingControllerTest
  describe KnittingController, :type => :controller do
    describe "GET index" do
    # context "index" do
      it "assigns an array of projects to @project if projects load successfully" do
        Project.should_receive(:load_projects).and_return([true, [Project.new({})]])
        get :index
        response.should be_success
        assigns(:projects).should be_a_kind_of(Array)
        assigns(:projects).first.should be_a_kind_of(Project)
        flash[:error].should be_nil
      end
      it "assigns flash error if projects fail to load" do
        Project.should_receive(:load_projects).and_return([false, "error_message"])
        get :index
        response.should be_success
        assigns(:projects).should eq([])
        flash[:error].should eq("error_message")
      end
    end
  end
end
