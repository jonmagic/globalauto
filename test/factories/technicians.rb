Factory.define :technician do |f|
end

Factory.define :greg, :parent => :technician do |f|
  f.name "Greg"
  f.code "1234"
  f.color "red"
  f.active true
end

Factory.define :tom, :parent => :technician do |f|
  f.name "Tom"
  f.code "4321"
  f.color "blue"
  f.active false
end