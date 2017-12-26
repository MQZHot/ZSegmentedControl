Pod::Spec.new do |s|

s.name         = "ZSegmentedControl"                              
s.version      = "0.0.1"                                   
s.summary      = "Customizable segmented control, a UISwitch-like segmented control and Segmented pager written in Swift "
s.homepage     = "https://github.com/MQZHot/ZSegmentedControl"
s.author       = { "mqz" => "mqz1228@163.com" }     
s.platform     = :ios, "8.0"                     
s.source       = { :git => "https://github.com/MQZHot/ZSegmentedControl.git", :tag => s.version }
s.source_files  = "ZSegmentedControl/ZSegmentedControl/*.{swift}"                
s.requires_arc = true
s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" }

end
