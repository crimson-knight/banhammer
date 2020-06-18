FactoryBot.define do
  factory :banhammer_spamfilter, class: 'Spamfilter' do
    kw { "MyText" }
    points { 1 }
    name { "MyString" }
    link_limit { 1 }
  end
end
