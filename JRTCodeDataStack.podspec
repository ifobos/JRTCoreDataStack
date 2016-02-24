Pod::Spec.new do |s|
  s.name         = "JRTCodeDataStack"
  s.version      = "0.0.1"
  s.summary      = "JRTCodeDataStack is a class that helps the most common implementation of coredata."
  s.homepage     = "https://github.com/ifobos/JRTCodeDataStack"
  s.license      = "MIT"
  s.author       = { "ifobos" => "juancarlos.garcia.alfaro@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ifobos/JRTCodeDataStack.git", :tag => "0.0.1" }
  s.source_files = "JRTCodeDataStack/JRTCodeDataStack/PodFiles/*.{h,m}"
  s.requires_arc = true
end
