#
# Be sure to run `pod lib lint MiniPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MiniPlayer'
  s.version          = '1.0.0'
  s.summary          = "It's simple way to play music in your application"

  s.description      = <<-DESC
    Simple control for play music in application. Just put UIView in your xib or storyboard and change class name on "MiniPlayer" 
                       DESC

  s.homepage         = 'https://github.com/seroshtanov/miniPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Vitaly Seroshtanov" => "v.s.seroshtanov@gmail.com" }
  s.source           = { :git => 'https://github.com/seroshtanov/MiniPlayer.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '9.3'
  s.swift_version = "5.0"
  s.source_files = 'MiniPlayer/Classes/**/*'
  s.resources = 'MiniPlayer/Assets/MiniPlayer.xcassets'

end
