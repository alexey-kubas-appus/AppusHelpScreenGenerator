Pod::Spec.new do |s|
  s.name         = "HelpScreenGenerator"
  s.version      = “0.0.1”
  s.summary      = "'HelpScreenGenerator' is a component, which gives you an opportunity to easily make a help screens for Your app"
  s.homepage     = "http://appus.pro"
  s.license      = { :type => "Apache", :file => 'LICENSE' }
  s.author       = { "Alexey Kubas" => "alexey.kubas@appus.me" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/alexey-kubas-appus/HelpScreenGenerator.git”, :tag => “0.0.1” }
  s.source_files = "HelpScreenView", "FlatSlideControl/*.swift"
  s.framework             = 'Foundation'
  s.requires_arc = true
end
