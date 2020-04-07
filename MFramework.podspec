Pod::Spec.new do |spec|
  spec.name         = "MFramework"
  spec.version      = "0.0.4"
  spec.summary      = "Demo of Deploy MFramework."
  spec.description  = <<-DESC
                        Deploy MFramework to Cocoapods
                      DESC
  spec.homepage     = "https://github.com/melody5417/iOS_SDK"
  spec.license      = 'MIT'
  spec.author       = { "melody5417" => "lengningshang@126.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :http => 'https://dldir1.qq.com/invc/tt/translator/HistoryData/MFramework.framework.zip' }
  spec.vendored_frameworks = "MFramework.framework"
end
