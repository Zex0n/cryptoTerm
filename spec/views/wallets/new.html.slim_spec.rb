require 'rails_helper'

RSpec.describe "wallets/new", type: :view do
  before(:each) do
    assign(:wallet, Wallet.new(
      :user => nil,
      :exchange => nil,
      :coin => nil,
      :balance => "9.99",
      :available => "9.99",
      :pending => "9.99"
    ))
  end

  it "renders new wallet form" do
    render

    assert_select "form[action=?][method=?]", wallets_path, "post" do

      assert_select "input[name=?]", "wallet[user_id]"

      assert_select "input[name=?]", "wallet[exchange_id]"

      assert_select "input[name=?]", "wallet[coin_id]"

      assert_select "input[name=?]", "wallet[balance]"

      assert_select "input[name=?]", "wallet[available]"

      assert_select "input[name=?]", "wallet[pending]"
    end
  end
end
