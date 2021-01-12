# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'BringChuChuba' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BringChuChuba
  pod 'SnapKit'
  pod 'SwiftLint'
  pod 'Then'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'Firebase/Auth'
  pod 'RxDataSources'
  pod 'DatePickerDialog'
  
  target 'BringChuChubaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BringChuChubaUITests' do
    # Pods for testing
  end

end

#to check memory leak
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end
