require 'spec_helper'

RSpec.describe "api_keys/show", :type => :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      :user => nil,
      :exchange => nil,
      :key => "Key",
      :isecret => "secret"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/secret/)
  end
end
