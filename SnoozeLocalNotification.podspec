Pod::Spec.new do |s|
  s.name        = "SnoozeLocalNotification"
  s.version     = "0.1.0"
  s.summary     = "A short description of SnoozeLocalNotification."
  s.description = ""
  s.homepage     = "https://github.com/azu/SnoozeLocalNotification"
  s.license      = 'MIT'
  s.author       = {"azu" => "azuciao@gmail.com"}
  s.source       = {:git => "https://github.com/azu/SnoozeLocalNotification.git", :tag => s.version.to_s}
  s.social_media_url = 'https://twitter.com/azu_re'
  s.platform     = :ios
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
end
