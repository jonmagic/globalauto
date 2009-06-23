Factory.define :user do |u|
  u.firstname "John"
  u.lastname "Doe"
  u.login "jdoe"
  u.salt "1000"
  u.hashed_password "77a0d943cdbace52716a9ef9fae12e45e2788d39" # test
end

Factory.define :bob, :parent => :user do |u|
  u.firstname "Bob"
  u.lastname "Smith"
  u.login "bsmith"
end