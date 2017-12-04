iPod::Spec.new do |s|
  s.name             = 'cnode'
  s.version          = '0.1.0'
  s.summary          = '一些屁话'
  s.description      = <<-DESC
更多行
行的
屁话
                       DESC
 
  s.homepage         = 'https://github.com/1000copy/cnode'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1000copy' => '1000copy@gmail.com' }
  s.source           = { :git => 'https://github.com/1000copy/cnode.git'  }

  s.ios.deployment_target = '10.0'
  s.source_files = 'cnode/*'
end
