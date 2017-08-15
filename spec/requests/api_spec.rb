require 'spec_helper'

RSpec.describe "ApiKey", :type => :request do
  describe "GET /api_keys" do
    it "works! (now write some real specs)" do
      get api_index_path
      expect(response.status).to be(200)
    end
  end
end
