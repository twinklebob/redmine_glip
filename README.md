Glip Plugin for Redmine
==========================

Redmine plugin for Glip notifications


Installation
------------

###### 1 .Install glip-rb gem:

add `gem 'glip-rb'` to your Gemfile and run

    bundle install

###### 2. Install Glip plugin:

copy plugin to redmine plugins directory:

    git clone git@github.com:twinklebob/redmine_glip.git #{redmine_root/plugins}

then run

    rake redmine:plugins:migrate RAILS_ENV=production

(change environment if needed - more info at Redmine [plugin installation guide](http://www.redmine.org/wiki/redmine/Plugins))

###### 3. Configure plugin

In Redmine go to the Plugin page in the Adminstration area and configure Glip plugin using webhook URL - you can find it at [Glip](https://Glip.com) (go to the integration panel and click on Webhook icon).

Based on [redmine_kato](https://github.com/kato-im/redmine_kato) in turn based on [redmine_hipchat](https://github.com/hipchat/redmine_hipchat)

## Say thanks

Feel free to buy me a nice cup of tea or something. I accept tips through http://CyberneticDave.tip.me
