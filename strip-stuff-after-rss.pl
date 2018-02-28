#!/usr/bin/perl -w

my @arg = <STDIN>;
my $arg = join("",@arg);
$arg =~ s/<\/rss>.*/<\/rss>/s;
print $arg;
