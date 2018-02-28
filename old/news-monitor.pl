#!/usr/bin/perl -w

use BOSS::Config;
use Manager::Dialog qw(SubsetSelect);
use MyFRDCSA;
use NewsMonitor::EthicalViolations;
use PerlLib::BodyTextExtractor;

use Cache::FileCache;
use Data::Dumper;
use WWW::Google::News;
use WWW::Mechanize::Cached;

# please enter the film name

$specification = "
	-u		Update results
";

my $config = BOSS::Config->new
  (Spec => $specification,
   ConfFile => "");
my $conf = $config->CLIConfig;
$UNIVERSAL::systemdir = ConcatDir(Dir("minor codebases"),"news-monitor");

my $cacheobj = new Cache::FileCache
  ({
    namespace => 'news-monitor',
    default_expires_in => "2 years",
    cache_root => "$UNIVERSAL::systemdir/data/FileCache",
   });

my $cacher = WWW::Mechanize::Cached->new
  (
   cache => $cacheobj,
   timeout => 15,
  );

if (exists $conf->{-u}) {
  my $news = WWW::Google::News->new();
  # $news->topic("Frank Zappa");
  my $results = $news->search();
  foreach my $result (@$results) {
    $cacher->get($result->{url});
    my $text = BodyTextExtractor(HTML => $cacher->content());
    AnalyzeText(Text => $text);
  }
}

sub AnalyzeText {
  my (%args) = @_;
  print Dumper($args{Text});

}
