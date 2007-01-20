#!/usr/bin/perl

package Mac::iTerm::LaunchPad;
#
# Open a new terminal in the Finder cwd
#

our $VERSION = sprintf "%d.%03d", q$Revision: 1.1.1.1 $ =~ m/(\d+) \. (\d+)/x;

=head1 NAME

new-iterm - open a new iTerm window with one or more tabs

=head1 SYNOPSIS

	---Frontmost finder directory, defaulting to desktop
	% new-iterm

	---Frontmost finder directory, using special alias
	% new-iterm finder
	
	---Named directory
	% new-iterm /Users/brian/Dev

	---Named directory with
	% new-iterm ~/Dev
	
	---Multiple tabs 
	% new-iterm ~/Dev ~/Foo ~/Bar
	
	---Aliases, predefined in code
	% new-iterm music applications
	
	---Aliases, defined in your own ~/.new-iterm-aliases
	% new-iterm foo bar baz
	
=head1 DESCRIPTION

=head2 Aliases

You can define aliases in the F<~/.new-iterm-aliases> file. The file
is line-oriented and has the alias followed by its directory. You can
use the ~ home directory shortcut. 

	#alias	directory
	cpan /mirrors/MINICPAN
	dev	~/Dev
	paypal ~/Personal/Finances/PayPal
	
Since Mac OS X uses a case insenstive (though preserving) file system,
case doesn't matter. If you tricked Mac OS X into using something else,
use the right case and remove the C<lc()> in the code.

=head3 Default aliases

=over 4

=item desktop - the Desktop folder of the current user ( ~/Desktop )

=item home - home directory of the current user ( ~ )

=item music - music directory of the current user ( ~/Music )

=item applications - music directory of the current user ( ~/Applications )

=item finder - the directory of the frontmost finder window (defaults to Desktop)

=back

=head1 TO DO

=over 4

=item switch to choose session name (currently just default)

=item special alias for finder windows?

	new-iterm dir1 dir2 finder

=back

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

Inspired by a script from Chris Nandor
(http://use.perl.org/~pudge/journal/32199) which was inspired by a
script from Curtis "Ovid" Poe
(http://use.perl.org/~Ovid/journal/32086).

=head1 COPYRIGHT AND LICENSE

Copyright 2007, brian d foy.

You may use this program under the same terms as Perl itself.

=cut

# defaults
my %Aliases = qw(
	desktop  		~/Desktop
	home     		~
	music    		~/Music
	applications	/Applications
	);

_run() unless caller;

sub _run {

_init();
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #	
# argument processing

foreach my $arg ( @ARGV )
	{
	my $cwd = do {
		if( defined $arg )
			{
			# don't lc() if you have a case sensitive file system
			$arg = lc( exists $Aliases{$arg} ? $Aliases{$arg} : $arg );
			$arg = _get_finder_dir() if $arg eq 'finder';
			
			if( -d $arg ) { $arg }
			else          { die "$arg isn't a directory!\n" }
			}
		else
			{
			_get_finder_dir();
			}
		};
	
	_launch_iterm( $cwd );
	}
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #	
sub _init
	{
	@ARGV = ( undef ) unless @ARGV; # finder window special case;

	foreach my $key ( keys %Aliases ) { $Aliases{$key} =~ s/^~/$ENV{HOME}/ }
	
	print Dumper ( \%Aliases );
	
	if( open my($fh), "<", "$ENV{HOME}/.new-iterm-aliases" )
		{
		while( <$fh> )
			{
			s/^\s|\s$//g;
			s|(?<!\\)#|.*|;
			next unless /\S\s+\S/;
			my( $alias, $dir ) = map { lc } split;
			$dir =~ s/^~/$ENV{HOME}/;
			$Aliases{$alias} = $dir;
			}
		}	
	}
	
sub _get_finder_dir
	{
	use Mac::Files;

	# from Chris Nandor
	my $finder = new Mac::Glue 'Finder';
	my $cwd = $finder->prop(target => window => 1)->get(as => 'alias');
	$cwd ||= FindFolder(kUserDomain, kDesktopFolderType); # default to Desktop
	$cwd =~ s/'/'\\''/g;
	$cwd;
	}
	
BEGIN {
use Mac::Glue ':all';

my $iterm = new Mac::Glue 'iTerm';
$iterm->activate;
my $term = $iterm->make( new => 'terminal' );
my $session = 1;

sub _launch_iterm
	{
	my $cwd = shift;
	
	$term->Launch( session => 'default' );
	$term->obj( session => $session++ )->write(text => "cd '$cwd'");
	}
}