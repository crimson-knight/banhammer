FactoryBot.define do
  factory :scoring_rule do
    name { "MyString" }
    kw { "MyText" }
    link_limit { 1 }
    points { 1 }
    type { 1 }
  end
end
