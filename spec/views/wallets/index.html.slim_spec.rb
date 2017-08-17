require 'rails_helper'

RSpec.describe "wallets/index", type: :view do
  before(:each) do
    assign(:wallets, [
      Wallet.create!(
        :user => nil,
        :exchange => nil,
        :coin => nil,
        :balance => "9.99",
        :available => "9.99",
        :pending => "9.99"
      ),
      Wallet.create!(
        :user => nil,
        :exchange => nil,
        :coin => nil,
        :balance => "9.99",
        :available => "9.99",
        :pending => "9.99"
      )
    ])
  end

  it "renders a list of wallets" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
