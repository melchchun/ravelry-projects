module KnittingHelper
  def thumbnail_style(project)
    style = ""
    if project.thumbnail_url
      style += "background-image: url('#{ project.thumbnail_url }');"
      style += "background-position: 0 0;"
      style += "background-repeat: no-repeat;"
    end
    style
  end
end
