Pod::Spec.new do |s|
  s.name         = "CLBPageControl"
  s.version      = "0.1.2"
  s.summary      = "A replacement for UIPageControl which animates the addition and removal of the page indication dots."
  s.homepage     = "https://github.com/cactuslab/CLBPageControl"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Christian" => "christian@cactuslab.com" }
  s.source       = { :git => "https://github.com/cactuslab/CLBPageControl.git", :tag => "v0.1.2" }
  s.platform     = :ios, '5.0'
  s.source_files = "CLBPageControl/*.{h,m}"
  s.resources = ["CLBPageControl/Images/*.png"]
  s.requires_arc = true
end
