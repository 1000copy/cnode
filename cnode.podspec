Pod::Spec.new do |s|
  s.name             = 'cnode'
  s.version          = '0.1.0'
  s.summary          = '一些屁话'
  s.description      = '一些屁话'
  s.homepage         = 'https://github.com/1000copy/cnode'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1000copy' => '1000copy@gmail.com' }
  s.source           = { :path => '~/github/pod/cnode' }
  s.ios.deployment_target = '10.0'
  s.source_files = '*'
end