# README


## Project Overview

A toy banking application.


## System dependencies

- Ruby (See .ruby-version file for the exact Ruby version)
- Postgresql

(See Dockerfile for further details)


## Database creation

To create both the test and development databases:

```zsh
bin/rails db:create
```


## Database setup

To ensure the database is setup:
 
```zsh
bin/rails db:prepare
```

...or to destructively reset the database:

```zsh
bin/rails db:reset
```


## Development

To run a development server, run the following from the root of the project directory:

```zsh
bin/rails server
```

The app will be available locallys at http://localhost:3000/


## Tests

To run the full test suite:

```ruby
bundle exec rspec
```

## Seed data

For testing in development, there is the following seed data.

### Users:

```yml
user1:
  email: 'rich@example.com'
  password: 'Password123!!'

user2:
  email: 'poor@example.com'
  password: 'Password123!!'
```

### Accounts:

```yml
system_account:
  reference: '4605e852-61b3-47da-9de5-8068fa7172ac'

user1_account:
  reference: '0f85a4fb-0f5e-479e-898b-b57866b08b9e'

user2_account:
  reference: 'c3c7f394-3569-4c95-b4ab-9232e21079dc'
```
