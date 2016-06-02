platform :ios, "8.0"

source 'https://github.com/CocoaPods/Specs.git'

target 'Edhita' do
  pod 'EDHFinder', '~> 0.1'
  pod 'EDHFontSelector', '~> 0.2.2'
  pod 'EDHInputAccessoryView', '~> 0.1'
  pod 'Google-Mobile-Ads-SDK'
  pod 'Colours', '~> 5.5'
  pod 'FXForms', '~> 1.2'
  pod 'GHMarkdownParser', '~> 0.1'
  pod 'VTAcknowledgementsViewController', '~> 0.12'

  pod 'Bootstrap', podspec: 'https://raw.githubusercontent.com/tnantoka/podspecs/master/Specs/Bootstrap/Bootstrap.podspec'
  pod 'Megrim', podspec: 'https://raw.githubusercontent.com/tnantoka/podspecs/master/Specs/Megrim/Megrim.podspec'
  pod 'github-markdown-css', podspec: 'https://raw.githubusercontent.com/tnantoka/podspecs/master/Specs/github-markdown-css/github-markdown-css.podspec'
  end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Edhita/Pods-Edhita-acknowledgements.plist', 'Edhita/Assets/Pods-acknowledgements.plist')
end

