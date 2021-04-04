# README

GaNCH is a disaster-response website, offering publicly-available data from Wikidata to aid first-responders

It is a Rails 6 app, and uses the `sparql-client` ruby library to fetch data from Wikidata

* Ruby version

Ruby 2.6.3 or greater

* System dependencies

Rails 6.0.3 or greater
Postgres

* Configuration

Credentials: GaNCH was set up using the protocol introduced in Rails 5.2. You will want to generate your own
master key and encrypted credentials file. Run `rails credentials:edit` and commit `config/credentials.yml.enc`
(Do NOT commit your master key!)

GaNCH uses sendmail by default (see https://guides.rubyonrails.org/action_mailer_basics.html for your options)

* Database creation

Rake db:setup

* Database initialization

You should create at least one user before making any queries.
There is a Rake task to do this for you. Run
`rake setup:add_user_one` to generate a user with the configured email address (you might want to edit this first.)

If you wish to load the existing queries for Georgia counties, simply run
`rake queries:add_county_queries`

* Services (job queues, cache servers, search engines, etc.)

This project relies on a scheduled job to refresh data from Wikidata.

See the settings in `config/initializers/scheduler.rb` for the particulars.

* Deployment instructions

* ...
