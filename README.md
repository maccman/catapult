# Catapult [![Dependency Status](https://gemnasium.com/maccman/catapult.png)](https://gemnasium.com/maccman/catapult)

Simple gem that gives pure JavaScript/CoffeeScript projects a basic structure, and manages any necessary compilation and concatenation.

Catapult is especially useful alongside MVC frameworks like [Spine](http://spinejs.com) and [Backbone](http://backbonejs.org).

## Installation

    $ gem install catapult

## Usage

To generate an app, use:

    $ catapult new myapp

      create  myapp
      create  myapp/assets/javascripts/app.js
      create  myapp/assets/stylesheets/app.css
      create  myapp/browser.json
      create  myapp/public/index.htm

    $ cd myapp

You'll notice a bunch of files have been created. The convention in Catapult is that any assets under `assets/javascripts` and `assets/stylsheets` will be compiled under the static `public` directory. Your HTML files can reference them there.

Now you can start a catapult server:

    $ catapult server

And open up the app [in your browser](http://localhost:9292).

You can also build the files for deployment:

    $ catapult build

Or watch the files for changes, and then automatically build:

    $ catapult watch

## Concatenation

Catapult uses [Sprockets](https://github.com/sstephenson/sprockets) for concatenation. Sprockets uses meta comments to specify dependencies. For example:

    //= require jquery
    //= require ./other_file
    //= require_tree ./app

See the Sprockets documentation for more information.

## Included compilers

Sprockets will automatically compile certain file types when the files are first requested. For example, files with `.coffee` extensions will be compiled down to JavaScript before being served up to the end user.

The included Sprockets compilers are: [CoffeeScript](http://coffeescript.org), [sprockets-commonjs](http://github.com/maccman/sprockets-commonjs) and [Stylus](http://learnboost.github.com/stylus/). You can include additional ones by simply adding them to your project's `Gemfile`.

## Deploying to Heroku

It's a good idea to just serve up static files in production, and disable the asset compilation.

If you're using a system like Apache, you can just serve up the static files under the `./public` dir. Otherwise, with a [Rack](http://rack.github.com) based system, like [Heroku](http://heroku.com), you're going to need a few files:

Firstly, a `Gemfile`:

    source 'https://rubygems.org'
    gem 'catapult'

Then a `config.ru` file, serving up the static files:

    require 'catapult'

    use Catapult::TryStatic,
        :root => Catapult.root.join('public'),
        :urls => %w[/],
        :try  => ['.html', 'index.html', '/index.html']

    run lambda {|env|
      [404, {}, ['Not found']]
    }