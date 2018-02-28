package NewsMonitor::News;

use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Source Type Title Contents RawContents /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Source($args{Source});
  $self->Type($args{Type});
  $self->Title($args{Title});
  $self->Contents($args{Contents});
  $self->RawContents($args{RawContents});
}

sub Print {
  my ($self,%args) = @_;
  print Dumper([
		$self->Source,
		$self->Title,
		$self->Contents,
	       ]);
}

sub SPrint {
  my ($self,%args) = @_;
  my $title = $self->Title;
  if ($title !~ /[\.\?\!]$/) {
    $title = $title.".";
  }
  return $title."\n".$self->Contents;
}

1;
