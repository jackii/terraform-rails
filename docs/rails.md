# Ruby on Rails

Notes on Ruby on Rails


## Encrypted Credentials

Use encrypted credentials to store your credentials. To use it, you need a key.
The key is store in `config/master.key` or `ENV['RAILS_MASTER_KEY']`.

The encrypted credentials are saved on `config/credentials.yml.enc`, which you
cannot edit directly. This file is safe to be versioned.
To edit,

```
EDITOR=vi bin/rails credentials:edit
```

To use in production environment
```
# config/environments/production.rb
config.require_master_key = true
```

There are 2 ways to manage the key
1. Upload the `master.key`
2. Set the `ENV['RAILS_MASTER_KEY']`

**What about `secret_key_base`?**

The master key used to encrypt credentials is different from the secret key base.

The key on master.key is used to encrypt and decrypt all credentials. It does not
replace the secret key base.

The secret key base is required by Rails.

**What about other environments? (test, development, staging etc)**

The current credentials does not support other environments. Rails 6 will solve this.

Recommended setup is to use
- dotenv files for test and development
- Rails 5.1 encrypted secrets for staging
- Rails 5.2 credentials for production

References:
- [Engine Yard - Encrypted Credentials on Rails 5.2](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2)
- [DHH comments on Encrypted Credentials](https://github.com/rails/rails/pull/30067)
- [Rails 5.2 (Imperfect) credentials](https://blog.capsens.eu/rails-5-2-imperfect-credentials-4ef03934aea4)

