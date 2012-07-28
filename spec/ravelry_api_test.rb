require 'ravelry_api'
require 'spec_helper'

SAMPLE_PROJECT_JSON = "{\"user\":{\"url\":\"http://www.ravelry.com/people/melch\",\"name\":\"melch\"},\"projects\":[{\"pattern\":{\"designer\":{\"url\":\"http://www.ravelry.com/designers/carina-spencer\",\"name\":\"Carina Spencer\"},\"url\":\"http://www.ravelry.com/patterns/library/catkin\",\"name\":\"Catkin\"},\"progress\":100,\"happiness\":null,\"started\":null,\"needles\":[],\"thumbnail\":null,\"status\":\"in-progress\",\"comments\":0,\"yarns\":[{\"url\":\"http://www.ravelry.com/yarns/library/madelinetosh-tosh-sock\",\"brand\":\"madelinetosh\",\"name\":\"tosh sock\"}],\"blogPosts\":[],\"url\":\"http://www.ravelry.com/projects/melch/catkin\",\"completed\":\"2012-03-04\",\"favorited\":0,\"size\":\"regular\",\"madeFor\":\"me!\",\"name\":\"catkin\",\"notes\":null,\"permalink\":\"catkin\"},{\"pattern\":{\"designer\":{\"url\":\"http://www.ravelry.com/designers/carina-spencer\",\"name\":\"Carina Spencer\"},\"url\":\"http://www.ravelry.com/patterns/library/catkin\",\"name\":\"Catkin\"},\"progress\":90,\"happiness\":3,\"started\":\"2012-04-01\",\"needles\":[],\"thumbnail\":{\"medium\":\"http://images4.ravelrycache.com/uploads/melch/113348834/IMG_1233_medium.jpg\",\"flickrUrl\":\"#\",\"src\":\"http://images4.ravelrycache.com/uploads/melch/113348834/IMG_1233_square.jpg\"},\"status\":\"in-progress\",\"comments\":0,\"yarns\":[],\"blogPosts\":[],\"url\":\"http://www.ravelry.com/projects/melch/catkin-2\",\"completed\":null,\"favorited\":0,\"size\":\"regular\",\"madeFor\":\"Mom!\",\"name\":\"catkin for mom\",\"notes\":\"<p>todo <br />find buttons <br />fix the dropped stitch better <br />block <br />send</p>\",\"permalink\":\"catkin-2\"},{\"pattern\":{\"designer\":{\"url\":\"http://www.ravelry.com/designers/brella\",\"name\":\"brella\"},\"url\":\"http://www.ravelry.com/patterns/library/norwegian-totoro-mittens\",\"name\":\"Norwegian Totoro Mittens\"},\"progress\":5,\"happiness\":null,\"started\":null,\"needles\":[],\"thumbnail\":{\"medium\":\"http://images4.ravelrycache.com/uploads/melch/113348899/IMG_1234_medium.jpg\",\"flickrUrl\":\"#\",\"src\":\"http://images4.ravelrycache.com/uploads/melch/113348899/IMG_1234_square.jpg\"},\"status\":\"in-progress\",\"comments\":0,\"yarns\":[],\"blogPosts\":[],\"url\":\"http://www.ravelry.com/projects/melch/norwegian-totoro-mittens\",\"completed\":null,\"favorited\":0,\"size\":\"small - needs to be bigger\",\"madeFor\":\"Jennifer\",\"name\":\"Totoro mittens\",\"notes\":\"<p>to do <br />Frog <br />Make bigger <br />Thumbs need gussets <br />todo <br />I should get on this before graduation end of 2012.</p>\",\"permalink\":\"norwegian-totoro-mittens\"},{\"pattern\":{\"designer\":{\"url\":\"http://www.ravelry.com/designers/caryll-mcconnell\",\"name\":\"Caryll McConnell\"},\"url\":\"http://www.ravelry.com/patterns/library/wavy-feathers-qiviut-scarf\",\"name\":\"Wavy Feathers Qiviut Scarf\"},\"progress\":20,\"happiness\":null,\"started\":\"2012-06-02\",\"needles\":[],\"thumbnail\":{\"medium\":\"http://images4.ravelrycache.com/uploads/melch/113348755/IMG_1240_medium.jpg\",\"flickrUrl\":\"#\",\"src\":\"http://images4.ravelrycache.com/uploads/melch/113348755/IMG_1240_square.jpg\"},\"status\":\"in-progress\",\"comments\":0,\"yarns\":[{\"url\":\"http://www.ravelry.com/yarns/library/sweaterkits-silk-jewel\",\"brand\":\"Sweaterkits\",\"name\":\"Silk Jewel\"},{\"url\":\"http://www.ravelry.com/yarns/library/sweaterkits-silk-whisper\",\"brand\":\"Sweaterkits\",\"name\":\"Silk Whisper\"}],\"blogPosts\":[],\"url\":\"http://www.ravelry.com/projects/melch/wavy-feathers-qiviut-scarf\",\"completed\":null,\"favorited\":0,\"size\":\"long\",\"madeFor\":\"me\",\"name\":\"ocean waves\",\"notes\":null,\"permalink\":\"wavy-feathers-qiviut-scarf\"}]}"
SAMPLE_INVALID_API_KEY = "/* Invalid API Key */"

def project_url(name, api_key)
  "http://api.ravelry.com/projects/#{ name }/progress.json?key=#{ api_key }&status=in-progress&notes=true"
end

class RavelryApiTest
  describe RavelryApi do
    before(:each) do
      @name = 'name'
      @valid_api_key   = 'valid'
      @invalid_api_key = 'invalid'
      @net_response = double("Net::HTTPResponse")
      @invalid_url = project_url(@name, @invalid_api_key)
      @valid_url = project_url(@name, @valid_api_key)

      @net_response.stub(:fetch).with("status").and_return("200")
    end
    context "get project data" do
      it "returns [true, { project data hash }] when successful" do
        @net_response.stub(:body).and_return(SAMPLE_PROJECT_JSON)

        YAML.stub(:load_file).and_return({ "username" => @name, "access_token" => @valid_api_key })
        Net::HTTP.should_receive(:get_response).with(URI.parse(@valid_url)).and_return(@net_response)

        success, response = RavelryApi.get_project_data
        success.should eq(true)
        response.should eq(ActiveSupport::JSON.decode(SAMPLE_PROJECT_JSON))
      end
      it "returns [false, 'api key fail message'] api error returned" do
        @net_response.stub(:body).and_return(SAMPLE_INVALID_API_KEY)

        YAML.stub(:load_file).and_return({ "username" => @name, "access_token" => @invalid_api_key })
        Net::HTTP.should_receive(:get_response).with(URI.parse(@invalid_url)).and_return(@net_response)

        success, response = RavelryApi.get_project_data
        success.should eq(false)
        response.should eq("Invalid API Key")
      end
      it "returns [false, 'generic error message'] JSON parse fails" do
        @net_response.stub(:body).and_return("invalid JSON")

        YAML.stub(:load_file).and_return({ "username" => @name, "access_token" => @invalid_api_key })
        Net::HTTP.should_receive(:get_response).with(URI.parse(@invalid_url)).and_return(@net_response)

        success, response = RavelryApi.get_project_data
        success.should eq(false)
        response.should eq("JSON response from server cannot be parsed")
      end
      it "returns [false, 'status error'] when status failed" do
        status_code = "500"
        @net_response.stub(:body).and_return("some message")
        @net_response.stub(:fetch).with("status").and_return(status_code)

        YAML.stub(:load_file).and_return({ "username" => @name, "access_token" => @invalid_api_key })
        Net::HTTP.should_receive(:get_response).with(URI.parse(@invalid_url)).and_return(@net_response)

        success, response = RavelryApi.get_project_data
        success.should eq(false)
        response.should eq("Received #{ status_code } status from server")
      end
    end
  end
end
