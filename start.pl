#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Cwd;

my $init;

GetOptions(
    "init" => \$init,
);

my $work_dir = getcwd();

my $players = [
    'roa',
    'elmac',
];

if ($init) {
    foreach my $player (@$players) {
        system("git clone git\@perlvert.me:/${player}.git ../${player}");
    }
    exit(0);
}

foreach my $player (@$players) {
    chdir "${work_dir}/../${player}";
    system("git pull") == 0 or warn $@;
}

chdir $work_dir;
system('bundle exec ruby croupier/scripts/start_tournament.rb');
