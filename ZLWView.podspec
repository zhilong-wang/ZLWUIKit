#
# Be sure to run `pod lib lint ZLWUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZLWView'
  s.version          = '0.0.1'
  s.summary          = '常用的扩展和工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 有多语言的扩展以及，常用的安全适配扩展
                       DESC

  s.homepage         = 'https://github.com/SJYY/ZLWUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SJYY' => 'zhilong_w@aliyun.com' }
  s.source           = { :git => 'https://github.com/SJYY/ZLWUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZLWView/**/*'
  s.dependency 'SnapKit'
  s.dependency 'ZLWUIKit'
end