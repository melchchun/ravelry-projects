class Project
  require 'ravelry_api'

  def initialize(data_hash)
    @data = data_hash
    @thumbnail = Thumbnail.new(@data["thumbnail"])
  end
  def notes
    @data["notes"]
  end
  def thumbnail
    @thumbnail
  end
  def url
    @data["url"]
  end
  def name
    @data["name"]
  end

  def thumbnail_url
    @thumbnail.url
  end

  def upload_photos_url
    url + '/photos'
  end

  def self.load_projects
    success, resp = RavelryApi.get_project_data
    projects_or_msg = success ? resp["projects"].map{ |data_hash| Project.new(data_hash) } : resp
    [success, projects_or_msg]
  end

  def todo_list
    # this is a pretty brittle parse, would possibly switch out for an html parsing gem...
    # ... better to have a todo input to control the format
    notes ? notes.split(/to.?do/)[1] : nil
  end

  def thumbnail_or_upload_url
    thumbnail_url || upload_photos_url
  end

  # doesn't seem worth pulling into its own file for one convenience method.
  class Thumbnail
    def initialize(data_hash)
      @thumbnail_data = data_hash
    end

    def url
      @thumbnail_data ? @thumbnail_data["src"] : nil
    end
  end
end
