# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MVP-API-Sample' do
  use_frameworks!

  # Pods for MVP-API-Sample

  target 'MVP-API-SampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Model' do
    inherit! :search_paths
    plugin 'cocoapods-keys', {
    :project => "MVP-API-Sample",
    :keys => [
      "GurunaviApiKey",
    ]}
  end

end
