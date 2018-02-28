package NewsMonitor;

use BOSS::Config;
use MyFRDCSA qw(ConcatDir Dir);
use NewsMonitor::SourceManager;
use PerlLib::SwissArmyKnife;
use Sayer;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Config MySourceManager MySayer /

  ];

sub init {
  my ($self,%args) = @_;
  $specification = "
	-U [<sources>...]	Update sources
	-l [<sources>...]	Load sources
	-s [<sources>...]	Search sources
	-c [<sources>...]	Choose sources

	--process		Process news with sentiment analysis

	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";
  $UNIVERSAL::systemdir = ConcatDir(Dir("minor codebases"),"news-monitor");
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  $self->MySourceManager
    (NewsMonitor::SourceManager->new
     ());
  $UNIVERSAL::agent->DoNotDaemonize(1);
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
  if (exists $conf->{'-U'}) {
    $self->MySourceManager->UpdateSources
      (Sources => $conf->{'-U'});
  }
  if (exists $conf->{'-l'}) {
    $self->MySourceManager->LoadSources
      (Sources => $conf->{'-l'});
  }
  if (exists $conf->{'-s'}) {
    $self->MySourceManager->Search
      (Sources => $conf->{-s});
  }
  if (exists $conf->{'-c'}) {
    $self->MySourceManager->Choose
      (Sources => $conf->{-c});
  }
  if (exists $conf->{'--process'}) {
    $self->ProcessNewsWithSentimentAnalysis();
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  }
}

sub ProcessNewsWithSentimentAnalysis {
  my ($self,%args) = @_;
  my $outdir = "$UNIVERSAL::systemdir/data/source";
  foreach my $sourcename (sort $self->MySourceManager->MySources->Keys) {
    my $source = $self->MySourceManager->MySources->Contents->{$sourcename};
    my $sorted = {};
    foreach my $news ($source->MyNews->Values) {
      $sorted->{$news->Source} ||= [];
      push @{$sorted->{$news->Source}}, $news;
      # $news->Print;
      # process with sentiment analysis software
    }
    foreach my $source2 (sort keys %$sorted) {
      my $source2dirname = $source2;
      $source2dirname =~ s/[^a-zA-Z0-9]/_/g;
      my $i = 0;
      foreach my $news (@{$sorted->{$source2}}) {
	my $dirname = $outdir."/".$sourcename."/data/".$news->Type."/".$source2dirname;
	system "mkdir -p ".shell_quote($dirname) unless -d $dirname;
	my $fh = IO::File->new();
	$fh->open(">$dirname/$i.txt") or die "cannot open $dirname/$i.txt\n";
	print $fh $news->SPrint;
	$fh->close();
	++$i;
      }
    }
  }
}

1;
