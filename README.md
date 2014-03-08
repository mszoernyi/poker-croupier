poker-croupier
==============

[![Build Status](https://travis-ci.org/lean-poker/poker-croupier.png?branch=master)](https://travis-ci.org/lean-poker/poker-croupier)

Robot poker croupier for lean poker tournaments, an event much like a code retreat, but with a slightly different format and purpose.

You can read about the first event here: 
- http://c0de-x.com/how-playing-poker-can-teach-you-lean-and-continuous-delivery/
- https://athos.blogs.balabit.com/2014/02/lean-poker-code-retreat/

## The purpose

A lean poker tournament's aim is for participants to practice concepts related to lean start ups and continuous deployment. A poker team is a small group of developers (ideally 4 people forming 2 pairs) whose aim is to incrementally build a highly heuristic algorithm within a one day timeframe that is just smart enough to beat the other robots. Professional poker robots are developed for years, so the purpose is definitely not to come up with something really smart, but to be the smartest among the current competitors. With this in mind teams can come up with simple to implement heuristics, examine their effect on game play during training rounds, and than improve their algorithm in a similar lean fashion.

## The format

Since only a few lean poker tournaments have been organized yet the format has not been finalized. Everything below is more of a draft. Please feel free to contribute your thoughts.

The robots are continously playing sit'n'go tournaments during the whole day. Between tournaments the croupier will automatically deploy the latest commit from the master branch for each team. 

The teams have 60 minute sessions while they are allowed to code. After each session there is a break, during which the last game that was played by the robots is shown on a projector. This is the part, where the teams can root for their robots. After the break there is a quick retrospective stand up meeting that looks back on the previous session.

## The rules

There are not many rules, but please keep them in mind. All rules of no limit texas hold'em apply.

One of the most important rules is that there is no explicit prize for the winner (the other teams however are free to invite them for a beer after the event). Lean poker - although it has a competitive feel to it - is not a competition. The emphasis should be on practice.

Another important rule is fair play: no one should try to exploit weaknesses of the framework, or deliberately inject back doors into its source code. Also - with some notable exceptions listed bellow - no team should use any pre-written code. 

As with any code retreat like event: provide a free lunch but avoid pizza.

### Notes on the usage of 3rd party code and fair play

We would like to avoid a situation where one team has a huge advantage over the others due to a library that solves some part of the problem. For that reason the rule of thumb is that only the language's standard library, and general purpose open source libraries are allowed.

#### Exceptions

For a library to qualify for the bellow exceptions, it should be publicly available and opensource. Properitary libraries are baned under all conditions.

- The folding player provided for each language. 
- In the case of C++ the Boost library is allowed, since otherwise C++ would be handicaped against languages like Java and python that have more potent standard libraries. Similarly in other languages where the standard library is small - like JavaScript - public packages are allowed as long as they are resonably general purpose. 
- If in doubt, then the team should ask the other teams if they allow them to use a particular library. In the name of fair play, other teams should allow the usage of the library if it does not give the other team an unfair advantage. 

# How to write a player

We try to provide the folding player (a player that folds or checks under all conditions) for as many languages as we can. Each of them is in a separate git repository, so that participiants can simply fork them, and start working on their algorithms right away.

Currently supported languages:
- [C++](https://github.com/lean-poker/poker-player-cpp)
- [Java](http://github.com/lean-poker/poker-player-java)
- [JavaScript](http://github.com/lean-poker/poker-player-js)
- [PHP](http://github.com/lean-poker/poker-player-php)
- [Python](https://github.com/lean-poker/poker-player-python)
- [Ruby](http://github.com/lean-poker/poker-player-ruby)

### How to create a folding player

The players are simple REST services. You should have the following files:
- A file usually called player\_service, that will take care of routing the requests to an object called player. The current game state sent as a post variable named game\_state in json format. The game\_state needs to be decoded into a dynamic structure. The action post variable specifies which function of the player is to be called. (Currently the only action is bet_request.)
- The other file is usually called player, and contains a Player class (or equivalent structure in languages where there are no classes) with a single bet_request function, that returns 0.

Further more you should have the following files that the deployment script will use:
- start.sh - It should start your service. 
- stop.sh - It should stop the service. 
- config.yml - It should contain the url on which your service can be accessed when it's running.

# How to get started as a contributor

Check the [issues section](https://github.com/devill/poker-croupier/issues) for current tasks. We also have a [mailing list at google groups](https://groups.google.com/forum/?hl=en#!forum/poker-croupier-developers). To understand the project structure, read the [architectural guide](https://github.com/devill/poker-croupier/wiki/Architectural-guide).

When implementing rules consult the Texas Hold'em rules in [English](http://www.pokerstars.com/poker/games/texas-holdem/) or  [Hungarian](http://www.pokerstars.hu/poker/games/texas-holdem/) and poker hand ranks in [English](http://www.pokerstars.com/poker/games/rules/hand-rankings/) or [Hungarian](http://www.pokerstars.hu/poker/games/rules/hand-rankings/)  pages on PokerStars. We wish to play sit-n-go tournaments of No Limit Texas Hold'em.

Helpful links
- [Glossary of poker terms](http://en.wikipedia.org/wiki/Glossary_of_poker_terms)
- [Poker gameplay and terminology](http://en.wikipedia.org/wiki/Category:Poker_gameplay_and_terminology)
- [Poker tournament](http://en.wikipedia.org/wiki/Poker_tournament)

## Setting up your development environment

- Clone the git repo
- Install [rvm](http://rvm.io/) and ruby 2.1.0: `\curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0`
- Install bundler: `gem install bundler`
- Install necessary gems with bundler: `bundle`
- Test your environment by running the unit tests: `rake test`

And that's it! You are all set to go.

## Running the application

At this point we do not yet have rake targets or integration tests that can help in taking the services for a spin. That means that although there are test for each service after changes it's worth running a manual sanity check. The way I do now:`bundle exec ruby croupier/scripts/integration_test.rb`

If you wish to hold a poker tournament than there is another script - `croupier/script/start.rb` - that you can modify and run. It let's you specify the log file, and the hosts and ports for each player. 

## Watching the results

During a gameplay the croupier collects all game related data and serialize it into the `log/` directory. You can replay any of them with the visual spectator. Just start it:

    bundle exec ruby visual_spectator/visual_spectator.rb -p 2000

[Bon appetite](http://localhost:2000).
