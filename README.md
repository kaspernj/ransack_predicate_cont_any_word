# RansackPredicateContAnyWord

This gem adds the "cont_any_word" predicate to Ransack for filtering more natural and human.

## Usage

```ruby
User.ransack(email_cont_any_word: "@example.com test").result.to_sql #=> SELECT "users".* FROM "users" WHERE ("users"."email" LIKE '%@example.com%' AND "users"."email" LIKE '%test%')
```

It is also possible to search for whole sentences
```ruby
User.ransack(encrypted_password_cont_any_word: '"yeah this is my password" password some').result.to_sql #=> SELECT "users".* FROM "users" WHERE ("users"."encrypted_password" LIKE '%yeah this is my password%' AND "users"."encrypted_password" LIKE '%password%' AND "users"."encrypted_password" LIKE '%some%')
```

For OR-combined attributes, each word may match in different columns:
```ruby
User.ransack(email_or_encrypted_password_cont_any_word: "@example.com encrypted_password").result.to_sql
#=> SELECT "users".* FROM "users" WHERE (("users"."email" LIKE '%@example.com%' OR "users"."encrypted_password" LIKE '%@example.com%') AND ("users"."email" LIKE '%encrypted_password%' OR "users"."encrypted_password" LIKE '%encrypted_password%'))
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ransack_predicate_cont_any_word'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ransack_predicate_cont_any_word
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
