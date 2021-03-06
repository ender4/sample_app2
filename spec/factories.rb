Factory.define :user do |user|
  user.name "Aron Ritchie"
  user.email "aron.ritchie@foo.bar.com"
  user.password "bazbix"
  user.password_confirmation "bazbix"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Hello World!"
  micropost.association :user
end
