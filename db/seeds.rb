unless User.exists?
  User.create(name: "テストくん", email: "test@example.com",
              password: "hogehoge", password_confirmation: "hogehoge")
end
