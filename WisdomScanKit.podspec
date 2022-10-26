Pod::Spec.new do |s|
  s.name         = "WisdomScanKit"
  s.version      = "0.3.4"
  s.summary      = "Powerful camera scanner frame"
  s.description  = "Powerful scanner frame, support to scan qr code, full screen camera shooting, support to scan the bank card number. Swift version, fully compatible with OC project calls."

  s.homepage     = "https://github.com/tangjianfengVS/WisdomScanKitDemo"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "tangjianfeng" => "497609288@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version= '5.0'
  s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/tangjianfengVS/WisdomScanKitDemo.git", :tag => s.version }

  s.source_files  = "WisdomScanKitDemo/WisdomScanKitDemo/WisdomScanKit/*.swift"
  s.source_files  = 'WisdomScanKitDemo/WisdomScanKitDemo/WisdomScanKit/**/*.swift'

  s.resources = "WisdomScanKitDemo/WisdomScanKitDemo/WisdomScanKit/WisdomScanKit.bundle"
  s.dependency "WisdomHUD"
end
