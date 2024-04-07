# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

workspace 'The Movie.xcworkspace'
project 'The Movie.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def development_pods
  networking_pod
  pod 'SDWebImage', '~> 5.0'
  pod 'netfox', '1.21.0'
end

target 'The Movie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for The Movie
  development_pods
  
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  development_pods
end
