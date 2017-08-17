FactoryGirl.define do
  factory :wallet do
    user nil
    exchange nil
    coin nil
    balance "9.99"
    available "9.99"
    pending "9.99"
  end
end
