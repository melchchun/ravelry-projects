class RavelryApi
  require 'net/http'

  def self.get_project_data
    response = []
    begin
      net_response = Net::HTTP.get_response(URI.parse(self.get_url_with_key))
      status_code = net_response.fetch('status')

      if status_code.to_i == 200
        if net_response.body == "/* Invalid API Key */"
          response = [false, "Invalid API Key"]
        else
          data = ActiveSupport::JSON.decode(net_response.body)
          response = [true, data]
        end
      else
        response = [false, "Received #{ status_code } status from server"]
      end

    rescue MultiJson::DecodeError => ex
      response = [false, "JSON response from server cannot be parsed"]
    rescue ArgumentError => ex
      response = [false, ex.message]
    rescue Errno::ENOENT => ex
      response = [false, ex.message]
    end

    response
  end

  private
    def self.get_url_with_key
      @api_hash ||= YAML.load_file(File.dirname(__FILE__) + '/../config/api.yml').with_indifferent_access
      @url ||= "http://api.ravelry.com/projects/#{ @api_hash[:username] }/progress.json?key=#{ @api_hash[:access_token] }&status=in-progress&notes=true"
    end
end
