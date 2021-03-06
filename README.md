# MailManager

[![Build Status](https://travis-ci.org/cap10morgan/mailmanager.svg?branch=master)](https://travis-ci.org/cap10morgan/mailmanager)
[![Gem Version](https://badge.fury.io/rb/mailmanager.svg)](http://badge.fury.io/rb/mailmanager)

MailManager is a Ruby wrapper for the GNU Mailman mailing list manager. It exposes
some administrative functions to Ruby. See the [API docs](http://rubydoc.info/github/cap10morgan/mailmanager/master/frames)
for details.
It is licensed under the New BSD License (see the LICENSE file for details).

MailManager has been tested with Mailman 2.1.14. It has NOT been tested with any
release of Mailman 3 (in alpha as of 1/19/2011). It requires Python 2.4 or higher.
Note that while Mailman itself requires Python, it can work with older versions. So
check your Python version before using this.

## Installation

    gem install mailmanager

## Basic Usage

    mm = MailManager.init('/mailman/root')
    all_lists = mm.lists
    foo_list = mm.get_list('foo')
    new_list = mm.create_list(:name => 'newlist', :admin_email => 'me@here.com', :admin_password => 'secret')
    new_list.add_member('bar@baz.com')
    new_list.members -> ['bar@baz.com']

## Hacking

Here are the basic steps for adding new features to this gem, if you're a programmer
type who likes to write code so you can code while you code... sorry.

MailManager's API currently consists of a handful of methods at the top-level
MailManager::Base class. This is where you'll find create_list and get_list. These
both return instances of MailManager::List, which is really where the action is.

MailManager::List contains the public Ruby API for interacting with Mailman's lists.
It exposes the methods and attributes of Mailman's MailList.py class, but makes
them a bit more Ruby-ish where appropriate. Not every method / attribute is
exposed, but this is where you come in, dear contributor.

The code that actually talks to Mailman is in lib/mailmanager/lib.rb.
It runs scripts in Mailman's bin directory. Anything that interacts with an
existing list uses Mailman's "withlist" script and the listproxy.py file in this
gem. If you read the docs on withlist that come with Mailman, it should be pretty
obvious what's going on there. But you don't need to understand all that to expose
new methods & attributes of MailList.py to MailManager.

Exposing new list properties works something like this:
* Look at Mailman's code in Mailman/MailList.py and see if the thing you want to
  expose is a method or an attribute. You'll need to know a little Python, but not
  much. Basically, a method is a callable thing and an attribute is a simple
  property of the object. "AddMember" is a method, for example, while "description"
  is an attribute.
* If it's a method, just write a simple method in lib/mailmanager/list.rb that
  calls a method in lib.rb (just like the others do). Then go write the method
  that you call in lib/mailmanager/lib.rb, using list_address or add_member as an
  example (depending on whether you're writing a getter or a setter, respectively).
* All methods that interact with MailList.py instances (i.e. mailing lists) use the
  withlist command, so just copy that stuff from an existing method.
* If you're exposing an attribute, then use the moderator methods as a guide.
  For example, they do their own dupe checking since the MailList.py class will
  let you set the attribute to whatever you want. Dangerous!
* If you're writing a setter, you have one more chore to make it work. You need the
  listproxy.py code to lock the list and then save it after making your requested
  change. It will do this for you if you do the following:
    * For a method: Add the name of the MailList.py method to the needs_save dict and
      have it return True. It should be obvious when you look at the others in there.
    * For an attribute: Add the name of the attribute to the needs_save_with_arg dict.
      This one is a bit different because the attr name is the same for gets and sets,
      but we need to lock and save when it's a set, and we can guess that it's a set
      when there is an argument passed, and a get when there is no argument. S-M-R-T
    * For a chain of attrs/methods: Huh? Look at lib.rb#add_moderator for an
      example. "moderator" is an array attribute of MailList.py, and we want to
      append a new string to it. So our "command" to listproxy.py is
      "moderator.append" with the new moderator string as the argument. listproxy is
      smart enough to untangle that and get the moderator attribute and then call the
      append method on it with your argument. But, in order to tell it to lock and
      save the list for us, we must replace that dot in the name with an
      underscore in the needs_save key. That's why we have "moderator_append=True"
      in the needs_save dict in listproxy.py. So if you have a chain of attributes
      and methods to get at the thing you're exposing, just replace the dots with
      underscores in the needs_save dict key and you'll be all set.

That should get you started hacking on the gem. If you get stuck or are trying to
do anything more complex, please feel free to e-mail me: cap10morgan@gmail.com.

## Testing

The RSpec suite should run out of the box with the `rake spec` command.
Feel free to open a GitHub issue if they do not.

## Contributing

* Fork on GitHub
* Make a new branch
* Commit your feature addition or bug fix to that branch.
* Don't mess with Rakefile, version.rb, or Changelog. (If you want to have your own version, that's fine but bump version in its own commit so we can ignore it when we pull.)
* Add tests for it. This is important so we don't break it in a future version unintentionally.
* Push your changes to that branch (i.e. not master)
* Make a pull request
* Bask in your awesomeness

## Author

* Wes Morgan (cap10morgan on GitHub) <cap10morgan@gmail.com>

Copyright 2011 Democratic National Committee,
All Rights Reserved.
