#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

foreach my $file (split /\n/, `find /var/lib/myfrdcsa/codebases/minor/news-monitor/data/output`) {
  print "<$file>\n";
  if (-f $file) {
    $contents = read_file($file);
  }
}
