package Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

use File::Path qw( make_path );

sub new {
	my $class = shift;
	my $self = {
			source => 'repository of the Docker specification',
			dockerfile => 'Dockerfile',
			path => 'path to the dockerfile from DockerContrib/tools',
			image => 'tag for the image generated',
			};
	bless $self, $class;
	return $self;

}	

sub show{
	my ( $this, $build, $type ) = @_;
	
	print STDERR "Build:\t$build\nType:\t$type\n";
	
	while (my ($k, $v) = each( %$this)) {
		print STDERR "$k:\t$v\n";
	}
}

sub start{
	my( $this, $type ) = @_;
	
	if ( $type eq 'docker' ) {
		$this->run();
	} else {
		$this->compose( $type );
	}
}

sub postInstall{
	#define post processing here
	#useful to add password to installed wiki
}

sub build{
	my $this = shift;

	my $cmd = "docker build $this->{path} -t $this->{image}";
	$this->do_command( $cmd );
	
	###`$cmd`;
}

sub getUpdateRepo {
	my $this = shift;
	
	my $cmd;
	my ( $owner, $repo ) = ($this->{source} =~ m!([^/]+)/([^/]+)\Z! );
	my $path = "../working/DockerContrib/" . lc($owner);
	if (-d "$path/$repo" ) {
		$cmd = "cd $path/$repo; git pull origin $this->{branch}";
	} else {
		make_path( $path );
		$cmd = "cd $path; git clone $this->{source}";
	}
	$this->do_command( $cmd );
	
	$this->{path} = "$path/$repo";
}

sub run{
	my $this = shift;
	
	my $cmd = "docker run -idt -p 8080:80 --name $this->{containerName} $this->{image}";
	$this->do_command( $cmd );
	
}

sub compose{
	my ($this, $type ) = @_;
	
	my $cmd = "docker compose -f \"$this->{path}/$this->{type}{$type}\" up -d";  
	$this->do_command( $cmd );
}

sub do_command{
	my ( $this, $cmd ) = @_;
	print STDERR "$cmd\n";
	`$cmd`;
}

1;