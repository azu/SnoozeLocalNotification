Pod::Spec.new do |s|
  s.name        = "SnoozeLocalNotification"
  s.version     = "0.1.0"
  s.summary     = "A short description of SnoozeLocalNotification."
  s.description = <<-DESC
                       An optional longer description of SnoozeLocalNotification

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
  DESC
  s.homepage     = "https://github.com/azu/SnoozeLocalNotification"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = {"azu" => "azuciao@gmail.com"}
  s.source       = {:git => "https://github.com/azu/SnoozeLocalNotification.git", :tag => s.version.to_s}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources    = 'Pod/Assets/*.png'

end
