Pod::Spec.new do |s|
s.name             = "OYSimpleAlertController"
s.version          = "1.0.0"
s.summary          = "OYSimpleAlertController is very simple Alert written in Swift."
s.homepage         = "https://github.com/oyuk/OYSimpleAlertController"
s.screenshots     = "https://raw.githubusercontent.com/oyuk/OYSimpleAlertController/master/Assets/OkAlert.png","https://raw.githubusercontent.com/oyuk/OYSimpleAlertController/master/Assets/OkAndCancelAlert.png"
s.license          = 'MIT'
s.author           = { "oyuk" => "okysoft68@gmail.com" }
s.source           = { :git => "https://github.com/oyuk/OYSimpleAlertController.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/oydku'
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'OYSimpleAlertController/**/*.{swift}'
end