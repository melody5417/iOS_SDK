Pod::Spec.new do |spec|
  spec.name         = "MFramework"
  spec.version      = "0.0.3"
  spec.summary      = "Demo of Deploy MFramework."
  spec.description  = <<-DESC
                        Deploy MFramework to Cocoapods
                      DESC
  spec.homepage     = "https://github.com/melody5417/iOS_SDK"
  spec.license  = 'MIT'
  spec.author       = { "melody5417" => "lengningshang@126.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/melody5417/iOS_SDK.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks = "MFramework.framework"
end
