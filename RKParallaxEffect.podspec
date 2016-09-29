Pod::Spec.new do |s|
  s.name                  = "RKParallaxEffect"
  s.version               = "2.0.0"
  s.summary               = "RKParallaxEffect is written in Swift and provides API to create a parallax effect on UITableHeaderView"
  s.homepage              = "https://rahulkatariya.github.io/RKParallaxEffect"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Rahul Katariya" => "rahulkatariya@me.com" }
  s.source                = { :git => "https://github.com/RahulKatariya/RKParallaxEffect.git", :tag => "v"+s.version.to_s  }
  s.social_media_url      = 'https://twitter.com/rahulkatariya91'
  s.platform     	        = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc	        = true
  s.source_files	        = 'Sources/*.swift'
end
