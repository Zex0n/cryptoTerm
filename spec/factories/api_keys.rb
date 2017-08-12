FactoryGirl.define do
  factory :api_key do
    name "MyString"
    sort 1
    open "MyString"
    secret "MyString"
    user nil
    exchenge nil
  end
end
