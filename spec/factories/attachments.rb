FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'acceptance_helper.rb')) }
  end
end
