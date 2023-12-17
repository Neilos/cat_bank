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
