#
# Be sure to run `pod lib lint Expression.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Expression'
  s.version          = '0.0.1'
  s.summary          = 'Expression in Objective-C'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/DanboDuan/Expression'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bob' => 'bob170131@gmail.com' }
  s.source           = { :git => 'https://github.com/DanboDuan/Expression.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.frameworks = 'Foundation'
  s.default_subspec = 'Core'
  s.requires_arc = true

  s.subspec 'Utility' do |utility|
        utility.source_files = 'Expression/Utility/**/*.{h,m,c}'
        utility.public_header_files = 'Expression/Utility/Header/*.h'
  end

  s.subspec 'Core' do |core|
      core.source_files = 'Expression/Core/**/*.{h,m,c}'
      core.dependency 'Expression/Utility'
      core.public_header_files = 'Expression/Core/Header/*.h'
  end

end
