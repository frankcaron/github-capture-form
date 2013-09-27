Github Capture Form
===================

A simple utility to capture and validate a Github user account. To be used at conferences [Stormpath](http://www.stormpath.com) attends for following up with cool devs we meet.

#### Config

In the `stormpath_git_me.rb`, you have to set API_URL to have your domain after the /v2.

In your environment vars (e.g., `~/.bash_profile`), you must have the `MAILGUN_API_KEY` with the appropriate Mailgun API key set.

#### Tech

Written in Ruby with Sinatra. Integrates Mailgun for sending an email.

#### Limitations

Currently limited in the following ways:

* Github API calls are limited to 60 per hour (60 submissions per hour)
* Mailgun API calls are limited to 300 per day (300 submissions per day total)

#### Deployed

Deployed to Heroku.

#### Etc.

Written with love by Frank Caron

frank@stormpath.com
[http://www.stormpath.com](http://www.stormpath.com)
