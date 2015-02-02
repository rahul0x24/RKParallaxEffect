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
  s.version          = "0.1.0"
  s.summary          = "RKParallaxEffect provides api to create a parallax effect on table view header"
  s.homepage         = "https://github.com/RahulKatariya/RKParallaxEffect"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Rahul Katariya" => "rahulkatariya@me.com" }
  s.source           = { :git => "https://github.com/RahulKatariya/RKParallaxEffect.git", :tag => "v0.1.0" }
  s.social_media_url = 'https://twitter.com/rahulkatariya91'
  s.platform    	   = :ios, '8.0'
  s.requires_arc	   = true
  s.source_files	   = 'RKParallaxEffect/RKParallaxEffect.swift'
end
