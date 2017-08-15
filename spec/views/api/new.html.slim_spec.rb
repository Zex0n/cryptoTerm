require 'spec_helper'

RSpec.describe "api_keys/new", :type => :view do
  before(:each) do
    assign(:api_key, ApiKey.new(
      :user => nil,
      :exchange => nil,
      :key => "MyString",
      :secret => "MyString"
    ))
  end

  it "renders new api form" do
    render

    assert_select "form[action=?][method=?]", api_keys_path, "post" do

      assert_select "input#api_key_user_id[name=?]", "api_key[user_id]"

      assert_select "input#api_key_exchange_id[name=?]", "api_key[exchange_id]"

      assert_select "input#api_key_key[name=?]", "api_key[key]"

      assert_select "input#api_key_secret[name=?]", "api_key[secret]"
    end
  end
end
