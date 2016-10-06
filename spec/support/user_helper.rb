def add(users, subdomain)
  Apartment::Tenant.switch(subdomain)
  Array(users).each do |user|
    user.save
  end
  Apartment::Tenant.reset
end
