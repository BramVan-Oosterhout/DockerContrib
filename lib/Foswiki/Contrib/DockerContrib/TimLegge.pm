package Foswiki::Contrib::DockerContrib::TimLegge;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/timlegge/docker-foswiki',
			branch => 'master',
			containerName => 'timlegge',
			dockerfile => 'Dockerfile',
			image => 'timlegge/dockerfoswiki',
			type => { simple => 'docker-compose.1-simple.yml',
					  'simple-https' => 'docker-compose.2-simple-https.yml',
					  },
			};
	bless $self, $class;
	return $self;

}

sub postInstall{
	
	my $this = shift;
	
	print STDOUT "Provide admin password for Foswiki: ";
	my $passwd = <STDIN>;
	chomp $passwd;
	
	my $cmd = join( " ", "docker exec -it",
				          $this->{containerName},
						  'sh -c "cd /var/www/foswiki;',
						  'tools/configure -save',
						  "-set {Password}=\'$passwd\'",
						  '"'
                  );	
	$this->do_command( $cmd );
} 

1;