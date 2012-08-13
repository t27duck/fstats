FStats
======

What is this?
-------------

FStats is a fun [sinatra]("http://sinatrarb.com") app + ruby script that generates pretty tables 
and graphs (powered by [Highcharts](http://highcharts.com)) on the use of the "f-bomb" 
in a 37Signals [Campfire](http://campfirenow.com) room.

Requirements
-----------

* Ruby (tested on 1.8.7, REE, and 1.9.X) and RubyGems
* bundler
* sqlite3 libs
* The standard packages used to compile native extensions for gems
* A 37Signals Campfire account

Setup
-----

Checkout the repo and navigate to the root of the project locally

    cd /path/to/fstats

Run bundle to install all required gems

    bundle install

For general FYI, these are some of the key gems that will be installed. 
View the Gemfile.lock for the complete list of gems that this project needs.

* curb
* sinatra
* json
* data\_mapper
* sqlite3

Copy the example config file

    cp config/config.yml.example config/config.yml

Edit the config file with your 37Signals information. You'll need:

* The room id you want to report on
* The API key for a user that has access to the room you want to report on
* The Campfire subdomain of your account
* (Optional) The array of user ids to exclude from reporting (such as your boss, bots, or formet co-workers)

Run the generater to pull down data from Campfire

    script/generate

Once that's all done, start up the Sinatra app and navigate to localhost:4567

    ruby app.rb

To refreash the local database with up-to-date data, just run script/generate at anytime
