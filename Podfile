#use_frameworks!

platform :ios, '8.0'

target 'Demo' do
  pod 'Expression', :path => './'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
    end
end
