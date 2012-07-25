class RavelryApi
  require 'net/http'

  def self.get_project_data
    api_hash = YAML.load_file(Rails.root + 'config/api.yml').with_indifferent_access
    url = "http://api.ravelry.com/projects/#{ api_hash[:username] }/progress.json?key=#{ api_hash[:access_token] }&status=in-progress&notes=true"
    resp = Net::HTTP.get_response(URI.parse(url))
    ActiveSupport::JSON.decode(resp.body)
  end
end
