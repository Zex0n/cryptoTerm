require 'rails_helper'

RSpec.describe "wallets/show", type: :view do
  before(:each) do
    @wallet = assign(:wallet, Wallet.create!(
      :user => nil,
      :exchange => nil,
      :coin => nil,
      :balance => "9.99",
      :available => "9.99",
      :pending => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
