Pod::Spec.new do |s|

  s.name         = "SFFir"
  s.version      = "0.0.2"
  s.summary      = "集成fir库"

  s.description  = <<-DESC
                   集成fir，方便使用fir的自动更新功能
                   DESC

  s.homepage     = "https://github.com/sofach/SFFir"

  s.license      = "MIT"

  s.author       = { "sofach" => "mamihlapinatapai@126.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/sofach/SFFir.git", :tag => "0.0.2" }

  s.source_files  = "SFFir/lib/**/*.{h,m}"

  s.requires_arc = true

  s.dependency "AFNetworking"

end