require "rails_helper"

describe RansackPredicateContAnyWord do
  let!(:user) { create :user, encrypted_password: "some password yeah this is my password", email: "test@example.com" }

  it "generates the correct sql" do
    query = User.ransack(email_cont_any_word: "@example.com test").result

    expect(query.to_sql).to eq 'SELECT "users".* FROM "users" WHERE ' \
      '("users"."email" LIKE \'%@example.com%\' AND "users"."email" LIKE \'%test%\')'
    expect(query.to_a).to eq [user]
  end

  it "searches for whole sentences if quotes" do
    query = User.ransack(encrypted_password_cont_any_word: '"yeah this is my password" password some').result

    expect(query.to_sql).to eq 'SELECT "users".* FROM "users" WHERE ("users"."encrypted_password" LIKE ' \
      '\'%yeah this is my password%\' AND "users"."encrypted_password" LIKE \'%password%\' AND ' \
      '"users"."encrypted_password" LIKE \'%some%\')'

    expect(query.to_a).to eq [user]
  end
end
