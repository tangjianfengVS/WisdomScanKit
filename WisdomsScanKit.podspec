Pod::Spec.new do |s|
  s.name         = "WisdomsScanKit"
  s.version      = "0.0.1"
  s.summary      = "A short description of WisdomsScanKit."
  s.description  = "WisdomsScanKit housekeeper"

  s.homepage     = "https://github.com/tangjianfengVS/WisdomsScanKit"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "tangjianfeng" => "497609288@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/tangjianfengVS/WisdomsScanKit.git", :tag => s.version }

  s.source_files  = "WisdomScanKitDemo/WisdomScanKitDemo/WisdomScanKit/*.swift"
end
