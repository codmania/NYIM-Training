require 'spec_helper'

describe UploadsController do
  context 'ckeditor upload' do
    it 'should create an asset' do
      file = Rack::Test::UploadedFile.new('spec/test_image.png', 'image/jpeg')
      post :create , :upload => file
      assert_equal 1, Asset.all.count
    end
  end
end


