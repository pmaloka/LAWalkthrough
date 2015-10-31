Pod::Spec.new do |s|
  s.name     = 'LAWalkthrough'
  s.version  = '1.0.3'
  s.license  = 'MIT'
  s.summary  = 'A view controller class for iOS designed to simplify the creation of a walkthrough.'
  s.homepage = 'https://github.com/pmaloka/LAWalkthrough'
  s.authors  = { 'Larry Aasen' => 'larryaasen@konugo.com' }
  s.source   = { :git => 'https://github.com/pmaloka/LAWalkthrough.git', :tag => '1.0.1' }
  s.source_files = 'LAWalkthrough'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
end
