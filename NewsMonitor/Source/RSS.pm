package NewsMonitor::Source::RSS;

use NewsMonitor::News;
use PerlLib::BodyTextExtractor;
use PerlLib::Cacher;
use PerlLib::Collection;
use PerlLib::HTMLConverter;
use PerlLib::HTMLUtil;
use PerlLib::SwissArmyKnife;
use PerlLib::URIExtractor;

use File::DirList;
use XML::RSS::Parser;
use XML::Simple;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [
   qw / Loaded OPMLDir MyCacher MyHTMLConverter MyNews Verbose /
  ];

sub init {
  my ($self,%args) = @_;
  $self->Verbose(1);
  $self->Loaded(0);
  $self->OPMLDir("$UNIVERSAL::systemdir/data/source/RSS/config/opmls-to-process");
  $self->MyCacher
    (PerlLib::Cacher->new
     (
      Expires => "1 day",
      CacheRoot => "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/FileCache",
     ));
  $self->MyHTMLConverter
    (PerlLib::HTMLConverter->new());
  $self->MyNews
    (PerlLib::Collection->new
     (StorageFile => $args{StorageFile}
      || "$UNIVERSAL::systemdir/data/source/RSS/news",
      Type => "NewsMonitor::News"));
  $self->MyNews->Load;
  # $self->MyNews->Contents({});
}

sub UpdateSource {
  my ($self,%args) = @_;
  Message(Message => "Updating source: RSS feeds");
  $self->UpdateRSSFeeds;
  $self->MyNews->Save();
}

sub LoadSource {
  my ($self,%args) = @_;
}

sub UpdateRSSFeeds {
  my ($self,%args) = @_;
  # iterate over the OPML entries
  my $list = File::DirList::list($self->OPMLDir, 'n', 1, 1, 0);
  foreach my $opmlfile (map {ConcatDir($self->OPMLDir,$_->[13])} @$list) {
    next unless $opmlfile =~ /\.opml/i;
    print "Loading OPML File: $opmlfile\n";
    my $contents = read_file($opmlfile);
    my $xml = XMLin($contents);
    print Dumper($xml);
    my $outline = $xml->{body}->{outline};
    my @outline;
    if (ref($outline) eq 'ARRAY') {
      @outline = @$outline;
    } else {
      @outline = ($outline);
    }
    foreach my $item (@outline) {
      my $url = $item->{xmlUrl};
      print $url."\n";
      my $rssoratom = $self->MyCacher->get($url);
      $self->ProcessRSSOrAtom
	(
	 URL => $url,
	 RSSOrAtom => $rssoratom->content,
	);
    }
  }
}

sub ProcessRSSOrAtom {
  my ($self,%args) = @_;
  my $rssoratom = $args{RSSOrAtom};
  # print Dumper($rssoratom);
  my $rss;
  if ($rssoratom =~ /http:\/\/www.w3.org\/2005\/Atom/) {
    # convert it first from atom to rss
    my ($fh,$filename) = tempfile();
    print $fh $rssoratom;
    $rss = `cat $filename | xsltproc /var/lib/myfrdcsa/codebases/minor/news-monitor/atom2rss.xsl -`;
    $fh->close();
  } else {
    $rss = $rssoratom;
  }
  my $p = XML::RSS::Parser->new;
  my $feed = $p->parse_string($rss);

  # output some values
  if (defined $feed) {
    my $feed_title = $feed->query('/channel/title');
    print $feed_title->text_content;
    my $count = $feed->item_count;
    print " ($count)\n";
    my ($title,$description,$text,$link);
    foreach my $i ( $feed->query('//item') ) {
      my $node = $i->query('title');
      $title = $node->text_content;
      if ($self->Verbose) {
	print '  Title: '.$title;
	print "\n";
      }

      my $description = $i->query('description');
      if (defined $description) {
	$description = $description->text_content;
	# print '  Desc: '.$description;
	# print "\n";
	# convert to text, along with title
	$text = $self->MyHTMLConverter->ConvertToTxt(Contents => $description);
	if ($self->Verbose) {
	  print '  Text: '.$text;
	  print "\n";
	}
	# now package this as an entry object and return
      }


      my $link = $i->query('link');
      if (defined $link) {
	$link = $link->text_content;
	if ($self->Verbose) {
	  print '  Link: '.$link;
	  print "\n";
	}
	# in the future, retrieve this link
	# system "wget -N -x -P $UNIVERSAL::systemdir/data/source/RSS/html/ ".shell_quote($link);
	if (0) {
	  my $news = $self->GetNewsForURI
	    (
	     URI => $link,
	     Type => 'link',
	    );
	  $self->MyNews->AddAutoIncrement(Item => $news);
	}
      }

      my $rawcontents = join("", map {$_->text_content} @{$i->contents});
      my $containeduris = {};
      foreach my $uri (@{ExtractURIs($rawcontents)}) {
	$containeduris->{$uri}++;
      }
      foreach my $uri (keys %$containeduris) {
	my $news = $self->GetNewsForURI
	  (
	   URI => $uri,
	   Type => 'contained-uri'
	  );
	$self->MyNews->AddAutoIncrement(Item => $news);
      }

      my $news = NewsMonitor::News->new
	(
	 Source => $args{URL},
	 Type => "rss",
	 Title => $title,
	 Contents => $text,
	 RawContents => $rawcontents,
	);
      $self->MyNews->AddAutoIncrement(Item => $news);
    }
  } else {
    print "ERROR with feed $args{URL}\n";
  }
}

sub GetNewsForURI {
  my ($self,%args) = @_;
  $containeduricontents = $self->MyCacher->get($args{URI});
  my $extractedcontents = BodyTextExtractor(HTML => $containeduricontents);
  my $news = NewsMonitor::News->new
    (
     Source => $args{URI},
     Type => ($args{Type} || 'data'),
     Title => ExtractTitle($containeduricontents)->[0],
     Contents => $extractedcontents,
     RawContents => $containeduricontents->content,
    );
  return $news;
}

1;
