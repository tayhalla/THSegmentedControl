#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "THSegmentedControl"
  s.version          = "0.1.0"
  s.summary          = "UISegmentedControl for multiple selection"
  s.description      = <<-DESC
  THSegmentedControl allows you to take in multiple selection and mirrors its next-of-kin, UISegmentedControl.
                       DESC
  s.homepage         = "https://github.com/tayhalla/THSegmentedControl"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Taylor Halliday" => "taylor.halliday@gmail.com" }
  s.source           = { :git => "https://github.com/tayhalla/THSegmentedControl.git", :commit => '8d3a72c1b01404e5741c4dc33405d40b30020906' }
  s.source_files  = 'THSegmentedControl/*'

  s.platform         = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true

  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
