# $Id: load.t,v 1.1.1.1 2007/01/20 00:37:45 comdog Exp $
BEGIN {
	@classes = qw(Mac::iTerm::LaunchPad);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile\n" unless use_ok( $class );
	}
