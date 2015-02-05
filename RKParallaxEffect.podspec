#
# Be sure to run `pod lib lint RKParallaxEffect.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RKParallaxEffect"
  s.version          = "1.0.0"
  s.summary          = "RKParallaxEffect is written in Swift and provides API to create a parallax effect on UITableHeaderView"
  s.homepage         = "https://github.com/RahulKatariya/RKParallaxEffect"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Rahul Katariya" => "rahulkatariya@me.com" }
  s.source           = { :git => "https://github.com/RahulKatariya/RKParallaxEffect.git", :tag => "v#{s.version}" }
  s.social_media_url = 'https://twitter.com/rahulkatariya91'
  s.platform     	 = :ios, '8.0'
  s.requires_arc	 = true
  s.source_files	 = 'RKParallaxEffect/*.swift'
end
