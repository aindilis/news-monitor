#!/usr/bin/perl -w
use strict;

use XML::RSS::Parser;
use FileHandle;

my $p = XML::RSS::Parser->new;
my $fh = FileHandle->new('/s2/myfrdcsa/codebases/minor/news-monitor/NewsMonitor/Source/test.rss');
my $feed = $p->parse_file($fh);

# output some values 
my $feed_title = $feed->query('/channel/title');
print $feed_title->text_content;
my $count = $feed->item_count;
print " ($count)\n";
foreach my $i ( $feed->query('//item') ) { 
    my $node = $i->query('title');
    print '  '.$node->text_content;
    print "\n"; 
}
