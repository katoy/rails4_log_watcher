json.array!(@users) do |user|
  json.extract! user, :id, :name, :age, :tel, :email, :password_digest
  json.url user_url(user, format: :json)
end
