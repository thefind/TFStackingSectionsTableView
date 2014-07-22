Pod::Spec.new do |s|
  s.name                = "TFStackingSectionsTableView"
  s.version             = "1.0.0"
  s.summary             = "Keep all of your table section headers on the screen. Tap a header to bring a section into view."
  s.description         = <<-DESC
                            In a regular table view, only the current section header is pinned to the top. TFStackingSectionsTableView
                            keeps all the section headers on screen, stacked at the top and bottom of the table. You can then tap a section header to bring that section into view.
                          DESC
  s.homepage            = "https://github.com/thefind/TFStackingSectionsTableView"
  s.screenshots         = "https://raw.githubusercontent.com/thefind/TFStackingSectionsTableView/master/Screenshots/screenshot.png"
  s.license             = "MIT"
  s.author              = { "phatmann" => "thephatmann@gmail.com" }
  s.social_media_url    = "http://twitter.com/thephatmann"
  s.platform            = :ios, "7.0"
  s.source              = { :git => "https://github.com/thefind/TFStackingSectionsTableView.git", :tag => "v1.0.0" }
  s.source_files        = "TFStackingSectionsTableView"
  s.requires_arc        = true
end
