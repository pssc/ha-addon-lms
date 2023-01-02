package Slim::Utils::OS::Custom;

use strict;
use File::Spec::Functions qw(catdir);

use base qw(Slim::Utils::OS::Debian);

use constant MUSIC_DIR => '/media';

sub initDetails {
	my $class = shift;

	$class->{osDetails} = $class->SUPER::initDetails();
	$class->{osDetails}->{osName} .= " (Docker Home Assistant Addon)";

	return $class->{osDetails};
}

sub initPrefs {
	my ($class, $prefs) = @_;

	if (-d MUSIC_DIR) {
		$prefs->{mediadirs} = $prefs->{ignoreInImageScan} = $prefs->{ignoreInVideoScan} = [ MUSIC_DIR ];
	}

	$prefs->{wizardDone} = 1;
	# no strings so Take Hostname from Env from container setup scripts
	$prefs->{libraryname} = $ENV{HAA_HOST}." - LMS HA Addon";
}

sub dirsFor {
	my ($class, $dir) = @_;

	my @dirs = $class->SUPER::dirsFor($dir);

	if ($dir eq 'music' && -d MUSIC_DIR) {
		push @dirs, MUSIC_DIR;
	}
	elsif ($dir eq 'Plugins') {
		push @dirs, catdir($::cachedir, 'Plugins');
		push @INC, $::cachedir;
	}

	return wantarray() ? @dirs : $dirs[0];
}

sub ignoredItems {
	return (
		# system paths in the fs root which will not contain any music
		'bin'          => '/',
		'boot'         => '/',
		'config'       => '/',
		'dev'          => '/',
		'etc'          => '/',
		'lib'          => '/',
		'libexec'      => '/',
		'opt'          => '/',
		'proc'         => '/',
		'run'          => '/',
		'sbin'         => '/',
		'srv'          => '/',
		'sys'          => '/',
		'tmp'          => '/',
		'usr'          => '/',
		'var'          => '/',
		'boot'          => '/',
		# add some of the HA specific exceptions:
		'ssl'          => '/',
		'@spool'       => 1,   # mail/print/.. spool
		'@tmp'         => 1,   # system temporary files
	);
}

sub aclFiletest {
	return sub {
		my $path = shift || return;

		{
			use filetest 'access';
			return (! -r $path) ? 0 : 1;
		}
	};
}

sub installerOS { 'src' };

#FIXME as config opt in env.. as we do want this silent
#
# we don't really support auto-update, but we need to make the update checker believe so, or it wouldn't check for us
sub canAutoUpdate {
        my $log = Slim::Utils::Log::logger('server.update');

        my $auto = $ENV{'LMS_autoupdate_notify'};
	if ($auto ne 'true') {
	        Slim::Utils::Prefs::preferences('server')  ->set('autoDownloadUpdate', 0);
		return 0;
	}
        $log->warn("Logitech Media Server can't be upgraded automatically in a home assisant addon, update info provided for information only");
	# make sure auto download is always enabled - we don't really auto-update, but this way we're called when we have update info
	Slim::Utils::Prefs::preferences('server')  ->set('autoDownloadUpdate', 1);
	# dirty hack to only return true when called from the update checker...
	my ($subr) = (caller(1))[3];
	return $subr eq 'Slim::Utils::Update::checkVersion' ? 1 : 0;
	# ha addons info | grep update_available FIXME
}

sub runningFromSource {
	# dirty hack to only return true when called from the settings handler...
	my ($subr) = (caller(1))[3];
	return $subr eq 'Slim::Web::Settings::Server::Software::handler' ? 1 : 0;
}

# set global variable to be shown in the web UI, but don't return anything to not trigger any download
sub getUpdateParams {
	$::newVersion = Slim::Utils::Strings::string('SERVER_UPDATE_AVAILABLE_SHORT');
	return;
}


1;
