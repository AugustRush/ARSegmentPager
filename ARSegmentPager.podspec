Pod::Spec.new do |s|
  s.name         = "ARSegmentPager"
  s.version      = "1.1.3"
  s.summary      = "segment tab controller with parallaxHeader"
  s.framework    = "UIKit"
  s.platform     = :ios, "6.0"
  s.homepage     = "https://github.com/AugustRush/ARSegmentPager"
  s.license      = "MIT"
  s.author             = { "August" => "liupingwei30@gmail.com" }
  s.source       = { :git => "https://github.com/AugustRush/ARSegmentPager.git", :tag => "1.1.3" }
  s.source_files  = "ARSegmentPageController", "ARSegmentPageController/**/*.{h,m}"
  s.exclude_files = "ARSegmentPageController/Exclude"
  s.public_header_files = "ARSegmentPageController/*.h"
  s.requires_arc = true
end