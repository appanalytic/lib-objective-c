#
# Be sure to run `pod lib lint AppAnalyticsObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppAnalyticsObjC'
  s.version          = '0.1.1'
  s.summary          = 'Library for AppAnalytics.ir service.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: A simple library for appanalytics.ir to tracking applications installation. It will be managed by appanalytics.ir account.
AppAnalytics class initilize with a access key that can be found in your appanalytics.ir account.
                       DESC

  s.homepage         = 'https://github.com/appanalytic/lib-objective-c'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AppAnalytics' => 'info@appanalytics.ir' }
  s.source           = { :git => 'https://github.com/appanalytic/lib-objective-c.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AppAnalyticsObjC/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AppAnalyticsObjC' => ['AppAnalyticsObjC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
