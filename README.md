# Reposted.me

## Raison d'être

Reposted.me is a simple clone of [Favstar](http://favstar.fm/). It's designed to do one thing well: to display your posts on App.net that have been starred or reposted by others.

## Current state

The initial code released to Github is the full production version of Reposted.me, but with a few modifications. These modifications will be pushed to production shortly, and production will track open source.

- Removed Flurry Analytics
- Cleaned up some unused controllers (such as changelog, which was never used)
- Removed some files from SCM that held sensitive information, such as
  confidential tokens.

Primarily for the last reason, I had to strip all SCM history and start a new git repository. Bad habits form when you work in closed source!

## Running

1. Secret Token

    Generate and configure a new secret token.

        $ rake secret
        $ cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb
        $ vim config/initializers/secret_token.rb

1. Database configuration

    Configure your database for the various environments. To just run locally, the defaults for test are probably fine.

        $ cp config/database.yml.example config/database.yml
        $ vim config/database.yml

1. App Token

    Copy and configure the app token. You can sign up for an app token [here][developers.app.net]. You'll need an App.net developer account.

        $ cp config/initalizers/app_token.rb.example config/initializers/app_token.rb
        $ vim config/initializers/app_token.rb

1. Bundle and run
        $ bundle install
        $ rails s

## Contributing

Pull requests are welcome, but I always appreciate ideas being bounced off me before big changes are made. I can be contacted on App.net as @wjl.

As always, if you spot a bug, feel free to file a Github issue or contact me privately.

## Planned improvements

- Due to the nature of the Developer Incentive Program, it was beneficial to filter all API requests back through the app server, to use the app token. Since this is no longer the case, the logic in `post.rb` can be moved to JavaScript which will allow much faster loading.

- Investigate and document the difficulties with using the Interactions API. (NB: More on this later.)

- Rather than infinite loading, implement an actual infinite scrolling system that loads on demand. Right now if you load a profile and leave the page open, you'll make N/200 API requests where N is the number of posts you have.
