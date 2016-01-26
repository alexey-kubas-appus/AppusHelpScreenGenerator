Pod::Spec.new do |s|
  s.name         = "AppusHelpScreenGenerator"
  s.version      = “0.0.2”
  s.summary      = "'AppusHelpScreenGenerator' is a component, which gives you an opportunity to easily make a help screens for Your app"
  s.homepage     = "http://appus.pro"
  s.license      = { :type => "Apache", :file => 'LICENSE' }
  s.author       = { "Alexey Kubas" => "alexey.kubas@appus.me" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/alexey-kubas-appus/AppusHelpScreenGenerator.git”, :tag => “0.0.2" }
  s.source_files = "APHelpScreenView", "APHelpScreenView/*.swift"
  s.framework             = 'Foundation'
  s.requires_arc = true
end
