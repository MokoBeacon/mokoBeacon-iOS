Pod::Spec.new do |s|
  	s.name         = "mokoBeaconSDK"    #存储库名称
  	s.version      = "0.0.1"      #版本号，与tag值一致
  	s.summary      = "iBeacon"  #简介
  	s.description  = "moko iBeacon SDK"  #描述
  	s.homepage     = "https://github.com/MokoBeacon/mokoBeacon-iOS"      #项目主页，不是git地址
  	s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  	s.author             = { "lovexiaoxia" => "aadyx2007@163.com" }  #作者
  	s.platform     = :ios, "8.0"                 #支持的平台和版本号
  	s.ios.deployment_target = "8.0"
  	s.frameworks   = "UIKit", "Foundation" #支持的框架
  	s.source       = { :git => "git@github.com:MokoBeacon/mokoBeacon-iOS.git", :tag => "#{s.version}" }         #存储库的git地址，以及tag值
  	s.requires_arc = true #是否支持ARC

  	s.source_files = 'mokoBeaconSDK/HCKBeaconSDK.h'

# ――― subspec ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  	s.subspec 'private' do |ss|
    		ss.source_files = 'mokoBeaconSDK/private/**'
  	end

    s.subspec 'public' do |ss|
            ss.source_files = 'mokoBeaconSDK/public/**'
            ss.dependency "mokoBeaconSDK/private"
    end

end