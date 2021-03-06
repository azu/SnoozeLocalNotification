Pod::Spec.new do |s|
  s.name        = "SnoozeLocalNotification"
  s.version     = "0.2.0"
  s.summary     = "Snooze UILocalNotification library - repeat local notification."
  s.homepage     = "https://github.com/azu/SnoozeLocalNotification"
  s.license      = 'MIT'
  s.author       = {"azu" => "azuciao@gmail.com"}
  s.source       = {:git => "https://github.com/azu/SnoozeLocalNotification.git", :tag => s.version.to_s}
  s.social_media_url = 'https://twitter.com/azu_re'
  s.platform     = :ios
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
end
