package Foswiki::Contrib::DockerInstallContrib::Bram;
use parent Foswiki::Contrib::DockerInstallContrib;

use strict;
use warnings;

sub new {
	my $class = shift;

	my $self = {
			source => 'https://github.com/BramVan-Oosterhout/df-Notepad',
			branch => 'main',
			containerName => 'notepad',
			dockerfile => 'Dockerfile',
			image => 'notepad',
			@_

			};
	bless $self, $class;
	return $self;

}

sub postInstall{
	
	my $this = shift;
	
	$this->SUPER::postInstall();
	
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