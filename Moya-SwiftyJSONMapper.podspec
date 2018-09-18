#
# Be sure to run `pod lib lint Moya-SwiftyJSONMapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Moya-SwiftyJSONMapper"
  s.version          = "3.1.0"
  s.summary          = "Map objects through SwiftyJSON in combination with Moya"
  s.description  = <<-EOS
    [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) bindings for
    [Moya](https://github.com/Moya/Moya) for easier JSON serialization.
    Includes [RxSwift](https://github.com/ReactiveX/RxSwift/) bindings as well.
    Instructions on how to use it are in
    [the README](https://github.com/AvdLee/Moya-SwiftyJSONMapper).
  EOS
  s.homepage     = "https://github.com/AvdLee/Moya-SwiftyJSONMapper"
  s.license      = { :type => "MIT", :file => "License" }
  s.author           = { "Antoine van der Lee" => "a.vanderlee@triple-it.nl" }
  s.source           = { :git => "https://github.com/AvdLee/Moya-SwiftyJSONMapper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/twannl'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0'
  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/*.swift"
    ss.dependency "Moya", "~> 11.0"
    ss.dependency "SwiftyJSON"
    ss.framework  = "Foundation"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Source/RxSwift/*.swift"
    ss.dependency "Moya/RxSwift"
    ss.dependency "Moya-SwiftyJSONMapper/Core"
  end

  s.subspec "ReactiveCocoa" do |ss|
    ss.source_files = "Source/ReactiveCocoa/*.swift"
    ss.dependency "Moya/ReactiveSwift"
    ss.dependency "Moya-SwiftyJSONMapper/Core"
  end
end
