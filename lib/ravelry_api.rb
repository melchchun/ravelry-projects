class RavelryApi
  require 'net/http'

  def self.get_project_data
    response = []
    api_hash = YAML.load_file(Rails.root + 'config/api.yml').with_indifferent_access
    url = "http://api.ravelry.com/projects/#{ api_hash[:username] }/progress.json?key=#{ api_hash[:access_token] }&status=in-progress&notes=true"
    net_response = Net::HTTP.get_response(URI.parse(url))
    status_code = net_response.fetch('status')

    if status_code.to_i == 200
      if net_response.body == "/* Invalid API Key */"
        response = [false, "Invalid API Key"]
      else
        begin
          data = ActiveSupport::JSON.decode(net_response.body)
          response = [true, data]
        rescue MultiJson::DecodeError => ex
          response = [false, "JSON response from server cannot be parsed"]
        end
      end
    else
      response = [false, "Received #{ status_code } status from server"]
    end

    response
  end
end
