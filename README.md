poker-croupier
==============

[![Build Status](https://travis-ci.org/devill/poker-croupier.png?branch=master)](https://travis-ci.org/devill/poker-croupier)

Robot poker croupier for lean poker tournaments, an event much like a code retreat, but with a slightly different format and purpose.

## The purpose

A lean poker tournament's aim is for participants to practice concepts related to lean start ups and continuous deployment. A poker team is a small group of developers (ideally 4 people forming 2 pairs) whose aim is to incrementally build a highly heuristic algorithm within a one day timeframe that is just smart enough to beat the other robots. Professional poker robots are developed for years, so the purpose is definitely not to come up with something really smart, but to be the smartest among the current competitors. With this in mind teams can come up with simple to implement heuristics, examine their effect on game play during training rounds, and than improve their algorithm in a similar lean fashion.

## The format

Since only a few lean poker tournaments have been organized yet the format has not been finalized. Everything below is more of a draft. Please feel free to contribute your thoughts.

One possibility is that 45 minute coding sessions are followed by sit-n-go games played by the  robots, and a short break. In this case only the last sit-n-go round counts when we determine the winner. Other rounds are just for training from which teams can deduce hypothesises, and test them in subsequent training rounds.

Another way to do it would concentrate a bit more on the continuous delivery aspect. In this case each team has infinite chips they can use to rebuy into the game any time they lost all their chips. The game is played continuously, but each team has a small time frame between rounds for deploying a new version of their robot, and each robot is free to leave the room for a while. The croupier would enforce an SLA. If a player is away from the table for a certain amount of time a penalty has to be payed before the next rebuy. This version lets teams do more experiments, and also forces them to be careful with their deployments. The team that has the best cash flow by the end of the day is the winner.

## The rules

There are not many rules, but please keep them in mind. All rules of no limit texas hold'em apply.

One of the most important rules is that there is no explicit prize for the winner (the other teams however are free to invite them for a beer after the event). Lean poker - although it has a competitive feel to it - is not a competition. The emphasis should be on practice.

Another important rule is fair play: no one should try to exploit weaknesses of the framework, or deliberately inject back doors into its source code. Also - with some notable exceptions listed bellow - no team should use any pre-written code. 

As with any code retreat like event: provide a free lunch but avoid pizza.

### Notes on the usage of 3rd party code and fair play

We would like to avoid a situation where one team has a huge advantage over the others due to a library that solves some part of the problem. For that reason the rule of thumb is that only the language's standard library, and general purpose open source libraries are allowed.

#### Exceptions

For a library to qualify for the bellow exceptions, it should be publicly available and opensource. Properitary libraries are baned under all conditions.

- The folding player provided as part of this repository in the `player/<language>` library can be used as a starting point. (That is to avoid people strugling to get Thrift to work.)
- In the case of C++ the Boost library is allowed, since otherwise C++ would be handicaped against languages like Java and python that have more potent standard libraries. Similarly in other languages where the standard library is small - like JavaScript - public packages are allowed as long as they are resonably general purpose. 
- If in doubt, than the team should ask the other teams if they allow them to use a particular library. In the name of fair play, other teams should allow the usage of the library if it does not give the other team an unfair advantage. 

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

## For Java developers
see the [player / java](https://github.com/devill/poker-croupier/tree/master/player/java) directory for further instructions

