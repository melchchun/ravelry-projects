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
    context "todo_list" do
      ["todo", "to-do", "to do"].each do |todo|
        it "should return everything after #{ todo }" do
          p = Project.new({ "notes" => "#{ todo }\nlist here" })
          p.todo_list.should eq("\nlist here")
        end
        it "should return everything after #{ todo } but not after the second" do
          p = Project.new({ "notes" => "#{ todo }\nlist here\n#{ todo }\nbut not here" })
          p.todo_list.should eq("\nlist here\n")
        end
      end
      it "should not cause error for nil notes" do
        p = Project.new({ "notes" => nil })
        p.todo_list.should eq(nil)
      end
    end
  end
end
