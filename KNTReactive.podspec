Pod::Spec.new do |s|
  s.name             = "KNTReactive"
  s.version          = "0.0.13"
  s.summary          = "Reactive binding"
  s.description      = <<-DESC
                       Reactive binding for table, and collection view
                       DESC
  s.homepage         = "https://github.com/kiennt/KNTReactive"
  s.license          = 'MIT'
  s.author           = { "kiennt" => "trungkien2288@gmail.com" }
  s.source           = { :git => "https://github.com/kiennt/KNTReactive.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'KNTReactive/**/*.{h,m}'

  s.dependency 'ReactiveCocoa', '2.3.1'
  s.dependency 'ReactiveViewModel', '0.2'
end
