require 'spec_helper'

RSpec.describe "api_keys/edit", :type => :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      :user => nil,
      :exchange => nil,
      :key => "MyString",
      :secret => "MyString"
    ))
  end

  it "renders the edit api form" do
    render

    assert_select "form[action=?][method=?]", api_key_path(@api_key), "post" do

      assert_select "input#api_key_user_id[name=?]", "api_key[user_id]"

      assert_select "input#api_key_exchange_id[name=?]", "api_key[exchange_id]"

      assert_select "input#api_key_key[name=?]", "api_key[key]"

      assert_select "input#api_key_id_api[name=?]", "api_key[id_api]"
    end
  end
end
