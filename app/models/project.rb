class Project
  require 'ravelry_api'

  def initialize(data_hash)
    @data = data_hash
  end

  def notes
    @data["notes"]
  end

  def self.load_projects
    project_data = RavelryApi.get_project_data
    project_data["projects"].map do |data_hash|
      Project.new(data_hash)
    end

    # result
    # { "user"=> { "name"=>"melch", "url"=>"http://www.ravelry.com/people/melch"},
  #     "projects"=> [
  #       { "completed"=>Sun, 04 Mar 2012,
  #         "name"=>"catkin",
  #         "happiness"=>nil,
  #         "madeFor"=>"me!",
  #         "permalink"=>"catkin",
  #         "progress"=>100,
  #         "size"=>"regular",
  #         "yarns"=>[{"name"=>"tosh
  #           sock",
  #           "brand"=>"madelinetosh",
  #           "url"=>"http://www.ravelry.com/yarns/library/madelinetosh-tosh-sock"}],
  #         "favorited"=>0,
  #         "status"=>"in-progress",
  #         "url"=>"http://www.ravelry.com/projects/melch/catkin",
  #         "pattern"=>{"name"=>"Catkin", "designer"=>{"name"=>"Carina Spencer", "url"=>"http://www.ravelry.com/designers/carina-spencer"}, "url"=>"http://www.ravelry.com/patterns/library/catkin"},
  #         "comments"=>0,
  #         "blogPosts"=>[],
  #         "started"=>nil,
  #         "thumbnail"=>nil,
  #         "notes"=>nil,
  #         "needles"=>[] },
  #       { "completed"=>nil,
  #         "name"=>"catkin for mom",
  #         "happiness"=>3,
  #         "madeFor"=>"Mom!",
  #         "permalink"=>"catkin-2",
  #         "progress"=>90,
  #         "size"=>"regular",
  #         "yarns"=>[],
  #         "favorited"=>0,
  #         "status"=>"in-progress",
  #         "url"=>"http://www.ravelry.com/projects/melch/catkin-2",
  #         "pattern"=>{"name"=>"Catkin", "designer"=>{"name"=>"Carina Spencer", "url"=>"http://www.ravelry.com/designers/carina-spencer"}, "url"=>"http://www.ravelry.com/patterns/library/catkin"},
  #         "comments"=>0,
  #         "blogPosts"=>[],
  #         "started"=>Sun, 01 Apr 2012,
  #         "thumbnail"=>nil,
  #         "notes"=>"<p>Still need to: <br />find buttons <br />fix the dropped stitch better <br />block <br />send</p>",
  #         "needles"=>[] },
  #       { "completed"=>nil,
  #         "name"=>"Totoro mittens",
  #         "happiness"=>nil,
  #         "madeFor"=>"Jennifer",
  #         "permalink"=>"norwegian-totoro-mittens",
  #         "progress"=>5,
  #         "size"=>"small - needs to be bigger",
  #         "yarns"=>[],
  #         "favorited"=>0,
  #         "status"=>"in-progress",
  #         "url"=>"http://www.ravelry.com/projects/melch/norwegian-totoro-mittens",
  #         "pattern"=>{"name"=>"Norwegian Totoro Mittens",
  #           "designer"=>{"name"=>"brella", "url"=>"http://www.ravelry.com/designers/brella"}, "url"=>"http://www.ravelry.com/patterns/library/norwegian-totoro-mittens"},
  #         "comments"=>0,
  #         "blogPosts"=>[],
  #         "started"=>nil,
  #         "thumbnail"=>nil,
  #         "notes"=>"<p>Needs to be frogged and made bigger. Thumbs also uncomfortable - need gusseted thumb.</p>", "needles"=>[]}
  #       ]
  #     }

  end

  def todo_list
    # this is a pretty brittle parse, would possibly switch out for an html parsing gem...
    # ... or a todo object off of a project, rather than co-opting notes
    # regex = /(todo|to do)(.*)[^(todo|to do)]/xim
    regex = /(todo|to)(.*)[^(todo|to do)]/xim
    match = regex.match(notes)
    match ? match[2] : nil
  end
end
