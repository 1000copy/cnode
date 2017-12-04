Pod::Spec.new do |s|
    s.name     = 'sfx'
    s.version  = '0.0.1'
    s.license  = 'MIT'
    s.summary  = 'swift framework'
    s.homepage = 'https://github.com/1000copy/cnode'
    s.author   = { '1000copy' => '1000copy' }
    s.source   = { :git => ''https://github.com/1000copy/cnode.git'}
    s.platform = :ios
    s.source_files = 'cnode/sfx/*.{h,swift,m}'
    s.resources = "cnode/sfx/icon/*.ttf"
    s.framework = 'UIKit'
    s.requires_arc = true
end
