# $Id: Makefile.PL,v 1.1.1.1 2007/01/20 00:37:45 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile(
	'NAME'	       => 'Mac::iTerm::LaunchPad',
	'VERSION_FROM' => 'lib/LaunchPad.pm',

	'PREREQ_PM'    => { 
		'Test::More'     => '0',
		'Mac::Files'     => '0',
		'Mac::Glue'      => '0',
		},

	'PM'           => {
		'lib/LaunchPad.pm'         => '$(INST_LIBDIR)/LaunchPad.pm',
		},

	'MAN3PODS'     => {
		'lib/LaunchPad.pm' => '$(INST_MAN3DIR)/Mac::iTerm::LaunchPad.3',
		},

	'EXE_FILES' => [],

	clean  => { FILES    => q|Mac-iTerm-LaunchPad-*| },

	);
