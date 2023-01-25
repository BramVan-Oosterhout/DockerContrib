package Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

use File::Path qw( make_path );
use Capture::Tiny;
use Cwd;
use Data::Dump qw(dump);

sub new {
	my $class = shift;
	my $self = {
			source => 'repository of the Docker specification',
			branch => 'the repo branch to be cloned/pulled',
			path => 'path to the dockerfile from DockerContrib/tools',
			image => 'tag for the image generated',
			port => 'port mapped to the container listening',
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
	my $this = shift;
	#define post processing here
	#useful to add password to installed wiki
	
	my $shParam = join( ' ', '-c "cd /var/www/foswiki;',
							 'tools/configure -save',
							 "-set {DefaultUrlHost}=\'http://localhost:$this->{port}\'",
							 '"'
					  );

	my @cmd = qq( docker exec -it $this->{containerName} sh $shParam );
	
	$this->do_command( @cmd );	
}

sub build{
	my $this = shift;

	my @cmd = qq(docker build $this->{path} -t $this->{image});
	$this->do_command( @cmd );
}

sub getUpdateRepo {
	my $this = shift;
	
	my @cmd;
	my $curDir = cwd();
	my ( $owner, $repo ) = ($this->{source} =~ m!([^/]+)/([^/]+)\Z! );
	my $path = "../working/DockerContrib/" . lc($owner);
	if (-d "$path/$repo" ) {
		chdir "$path/$repo";
		@cmd = qq( git pull origin $this->{branch} );
	} else {
		make_path( "$path" );
		chdir "$path";
		@cmd = qq( git clone $this->{source} );
	}
	$this->do_command( @cmd );
	
	chdir( $curDir );
	
	$this->{path} = "$path/$repo";
}

sub rewriteEnv{
	my ( $this, $update ) = @_;
	
	my $envFile = $this->{path} . '/.env';
	return () unless -e $envFile;
	
	open(my $fhEnv, "<", $envFile) or die "Can't open $envFile for read: $!";
	my %env;
	while ( <$fhEnv> ) {
		next unless $_ =~ /\A[^\s]+=/;
		chomp;
		my ($k, $v ) = split /\s*=\s*/;
		$env{ $k } = $v;
	}
	close $fhEnv;
	
	%env = ( %env, %$update );
		
	open( $fhEnv, ">", $envFile) or die "Can't open $envFile for write: $!";
	while ( my ($k, $v ) = ( each %env )) {
        print $fhEnv "$k=$v\n";
	}
	close $fhEnv;	
}

sub run{
	my $this = shift;
	
	my @cmd = qq(docker run -idt -p $this->{port}:80 --name $this->{containerName} $this->{image});
	$this->do_command( @cmd );
}

sub compose{
	my ($this, $type ) = @_;
	
	$this->rewriteEnv( { CONTAINER_NAME => $this->{containerName},
						 EXTERNAL_PORT => $this->{port}
						});
	
	my @cmd = qq( docker compose -f \"$this->{path}/$this->{type}{$type}\" up -d);  
	$this->do_command( @cmd );
}

sub do_command{
	my ( $this, @cmd ) = @_;
	print STDERR join( ' ', @cmd ),"\n";
	
	my ($stdout, $stderr, $exit_code) = Capture::Tiny::capture {
   # system('htmldate', '-u', $url)
      	system( @cmd );
    };

	if ( $exit_code != 0 ) {
		print STDERR " >>> Result: $exit_code - $stdout\n >>> $stderr";
		exit $exit_code;
	}
	
	print STDERR $stdout, "\n" if $this->{verbose} && $exit_code == 0 && $stdout;
}

1;