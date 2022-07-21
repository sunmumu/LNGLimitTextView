Pod::Spec.new do |spec|
  s.name         = 'LNGLimitTextView'
  s.version      = '0.0.1'
  s.summary      = 'TextView有占位符合字数限制和提示'
  s.homepage     = 'https://github.com/sunmumu/LNGLimitTextView'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'sunmumu' => '335089101@qq.com' }
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/sunmumu/LNGLimitTextView.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'LNGLimitTextView/**/*.swift'
  s.swift_version = '4.0', '4.1', '4.2','5.0', '5.1', '5.2', '5.3'
  
  s.libraries = 'z'
  s.frameworks = 'UIKit', 'CoreFoundation'

end
