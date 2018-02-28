#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

my $seen = {};

my $dir = '/var/lib/myfrdcsa/codebases/minor/news-monitor/keybindings';
my @files = split /\n/, `ls $dir`;
foreach my $file (@files) {
  my $c = read_file("$dir/$file");
  foreach my $line (split /\n/, $c) {
    $seen->{$line}++;
  }
}

my $pass = {};
my $length = scalar(@files);
foreach my $key (keys %$seen) {
  if ($seen->{$key} >= $length) {
    $pass->{$key} = 1;
  }
}

foreach my $key (sort keys %$pass) {
  print "$key\n";
}
