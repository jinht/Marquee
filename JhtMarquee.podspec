Pod::Spec.new do |s|
    
    s.name                       = 'JhtMarquee'
    s.version                    = '1.0.3'
    s.summary                    = '跑马灯/滚动文字条'
    s.homepage                   = 'https://github.com/jinht/Marquee'
    s.license                    = { :type => 'MIT', :file => 'LICENSE' }
    s.author                     = { 'Jinht' => 'jinjob@icloud.com' }
    s.social_media_url           = 'https://blog.csdn.net/Anticipate91'
    s.platform                   = :ios
    s.ios.deployment_target      = '8.0'
    s.source                     = { :git => 'https://github.com/jinht/Marquee.git', :tag => s.version }
    s.ios.vendored_frameworks    = 'JhtMarquee_SDK/JhtMarquee.framework'
    s.frameworks                 = 'UIKit'

end
