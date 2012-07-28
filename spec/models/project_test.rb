require 'spec_helper'

class ProjectTest
  describe Project do
    context "load projects" do
      it "creates projects objects from data hash and returns an array of them on success" do
        # expects project data to return a key projects with one key-value pair of
        # "projects" => [array of data hashes]
        project_data_hash = {'name' => 'Dr. Who Scarf'}
        data_hash = { 'projects' => [project_data_hash] }
        RavelryApi.stub(:get_project_data).and_return([true, data_hash])

        result = Project.load_projects
        result.first.should be_true
        result.last.should be_a_kind_of(Array)
        result.last.first.should be_a_kind_of(Project)
      end

      it "returns error message if api returns failure" do
        RavelryApi.stub(:get_project_data).and_return([false, "error message"])

        result = Project.load_projects
        result.should eq([false, "error message"])
      end
    end
    it "needs tests around the todo parsing"
    it "will be able to parse todo list from todo, to do, and to-do"
    # then update readme
  end
end
