#! /opt/VRTSperl/bin/perl -w
#
#  Author: Sravan Bhamidipati @bsravanin
#  License: MIT License http://www.opensource.org/licenses/mit-license.php
#  Courtesy: Symantec Corporation http://www.symantec.com
#  Date: 14th November, 2011
#  Purpose: To compare alternatives to Perl anti-patterns.

use strict;
use Time::HiRes qw(gettimeofday tv_interval);

my $start;
my $dir = "/data/builds/SxRT-5.1SP1-2010-09-01a/dvd1-sol_sparc/";
my $file = "/data/builds/SxRT-5.1SP1-2010-09-01a/dvd1-sol_sparc/readme_first.txt";
my $line="I'm as mad as hell, and I can't take this anymore.";
my $tarball = "/data/builds/SxRT-5.1SP1-2010-09-01a/dvd1-sol_sparc.tar.gz";

$start = [gettimeofday]; for (0..10000) {my $awk = `awk '{print \$3}' $file`} print &tv_interval($start, [gettimeofday]), "s for awk.\n";
$start = [gettimeofday]; for (0..10000) {my @awkAlt, my @line; open FILE, $file; while(<FILE>) {@line = split; if (!defined($line[2])) {$line[2] = ""} push @awkAlt, $line[2]} close FILE} print &tv_interval($start, [gettimeofday]), "s for awkAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $basename = `basename $file`; chomp($basename)} print &tv_interval($start, [gettimeofday]), "s for basename.\n";
# $start = [gettimeofday]; for (0..10000) {use File::Basename; my $basenameAlt = &basename($file); delete $INC{'Basename.pm'};} print &tv_interval($start, [gettimeofday]), "s for basenameAlt.\n";
$start = [gettimeofday]; for (0..10000) {my $basenameAlt = $file; $basenameAlt =~ s/\/$//; $basenameAlt =~ s/.*\///; if ($basenameAlt eq "") {$basenameAlt="/"}} print &tv_interval($start, [gettimeofday]), "s for basenameAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $cat = `cat $file`} print &tv_interval($start, [gettimeofday]), "s for cat.\n";
$start = [gettimeofday]; for (0..10000) {open FILE, $file; local $/; my $catAlt = <FILE>; close FILE} print &tv_interval($start, [gettimeofday]), "s for catAlt.\n";

$start = [gettimeofday]; for (0..10000) {chomp(my $cd = `cd`); chomp($cd = `cd $cd`)} print &tv_interval($start, [gettimeofday]), "s for cd.\n";
$start = [gettimeofday]; for (0..10000) {my $cdAlt = $ENV{'PWD'}; chdir; chdir $cdAlt} print &tv_interval($start, [gettimeofday]), "s for cdAlt.\n";

$start = [gettimeofday]; for (0..10000) {`cp $file "$file.bak"`} print &tv_interval($start, [gettimeofday]), "s for cp.\n";
$start = [gettimeofday]; for (0..10000) {use File::Copy "cp"; cp ($file, "$file.bak"); delete $INC{'Copy.pm'}} print &tv_interval($start, [gettimeofday]), "s for cpAlt.\n";

$start = [gettimeofday]; for (0..10000) {`chmod 755 $file`; `chmod 644 $file`} print &tv_interval($start, [gettimeofday]), "s for chmod.\n";
$start = [gettimeofday]; for (0..10000) {chmod 0755, $file; chmod 0644, $file} print &tv_interval($start, [gettimeofday]), "s for chmodAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $cut = `echo $line | cut -f3 -d" "`} print &tv_interval($start, [gettimeofday]), "s for cut.\n";
$start = [gettimeofday]; for (0..10000) {my @cutAlt = split(" ", $line)} print &tv_interval($start, [gettimeofday]), "s for cutAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $date = `date`} print &tv_interval($start, [gettimeofday]), "s for date.\n";
$start = [gettimeofday]; for (0..10000) {my $dateAlt = localtime} print &tv_interval($start, [gettimeofday]), "s for dateAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $dirname = `dirname $file`; chomp($dirname)} print &tv_interval($start, [gettimeofday]), "s for dirname.\n";
# $start = [gettimeofday]; for (0..10000) {use File::Basename; my $dirnameAlt = &dirname($file); delete $INC{'Basename.pm'};} print &tv_interval($start, [gettimeofday]), "s for dirnameAlt.\n";
$start = [gettimeofday]; for (0..10000) {my $dirnameAlt = $file; $dirnameAlt =~ s/\/$//; $dirnameAlt =~ s/\/[^\/]*$//; if ($dirnameAlt eq "") {$dirnameAlt="/"}} print &tv_interval($start, [gettimeofday]), "s for dirnameAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $echo = `echo -n`} print &tv_interval($start, [gettimeofday]), "s for echo.\n";
$start = [gettimeofday]; for (0..10000) {my $echoAlt = print ""} print &tv_interval($start, [gettimeofday]), "s for echoAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $find = `find $dir -name "*.txt"`} print &tv_interval($start, [gettimeofday]), "s for find.\n";
$start = [gettimeofday]; for (0..10000) {my @findAlt; use File::Find; find (sub {push @findAlt,"$File::Find::name\n" if(/.txt$/);}, $dir); delete $INC{'Find.pm'}} print &tv_interval($start, [gettimeofday]), "s for findAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $grep = `grep vx $file`} print &tv_interval($start, [gettimeofday]), "s for grep.\n";
$start = [gettimeofday]; for (0..10000) {my @grepAlt; open FILE, $file; while(<FILE>) {if(/vx/) {push @grepAlt, $_}} close FILE} print &tv_interval($start, [gettimeofday]), "s for grepAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $head = `head $file`} print &tv_interval($start, [gettimeofday]), "s for head.\n";
$start = [gettimeofday]; for (0..10000) {my @headAlt, my $i = 0, my $line; open FILE, $file; while(($line = <FILE>) && ($i++ < 10)) {push @headAlt, $line} close FILE} print &tv_interval($start, [gettimeofday]), "s for headAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $hostname = `hostname`} print &tv_interval($start, [gettimeofday]), "s for hostname.\n";
$start = [gettimeofday]; for (0..10000) {use Sys::Hostname; delete $INC{'Hostname.pm'}} print &tv_interval($start, [gettimeofday]), "s for hostnameAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $id = `id`} print &tv_interval($start, [gettimeofday]), "s for id.\n";
$start = [gettimeofday]; for (0..10000) {my @idAlt = getpwnam('root')} print &tv_interval($start, [gettimeofday]), "s for idAlt.\n";

# for ((i=0; i<10000; i++)); do sleep 10000 & done
# my $pids = `ps -ef | awk '{if(\$0~/sleep 10000/) print \$2}' | xargs`;
# my @pids = split (/\s+/, $pids);
# $start = [gettimeofday]; foreach (@pids) {`kill -9 $_`}; print &tv_interval($start, [gettimeofday]), "s for kill.\n";
# $start = [gettimeofday]; foreach (@pids) {kill 9, $_} print &tv_interval($start, [gettimeofday]), "s for killAlt.\n";

$start = [gettimeofday]; for (0..10000) {`ln -s $file .`; unlink "readme_first.txt"} print &tv_interval($start, [gettimeofday]), "s for ln.\n";
$start = [gettimeofday]; for (0..10000) {symlink $file, "."; unlink "readme_first.txt"} print &tv_interval($start, [gettimeofday]), "s for lnAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $ls = `ls $dir`} print &tv_interval($start, [gettimeofday]), "s for ls.\n";
$start = [gettimeofday]; for (0..10000) {my @lsAlt, my $filename; opendir (DIR, $dir); while($filename = readdir(DIR)) {push @lsAlt, $filename} closedir(DIR)} print &tv_interval($start, [gettimeofday]), "s for lsAlt.\n";

$start = [gettimeofday]; for (0..10000) {`mkdir $dir/$_`} print &tv_interval($start, [gettimeofday]), "s for mkdir.\n";
$start = [gettimeofday]; for (0..10000) {`rm -r $dir/$_`} print &tv_interval($start, [gettimeofday]), "s for rmr.\n";
$start = [gettimeofday]; for (0..10000) {use File::Path; mkpath("$dir/$_"); delete $INC{'Path.pm'}} print &tv_interval($start, [gettimeofday]), "s for mkdirAlt.\n";
$start = [gettimeofday]; for (0..10000) {use File::Path; rmtree("$dir/$_"); delete $INC{'Path.pm'}} print &tv_interval($start, [gettimeofday]), "s for rmrAlt.\n";

# $start = [gettimeofday]; for (0..10000) {`mkdir $_`} print &tv_interval($start, [gettimeofday]), "s for mkdir.\n";
# $start = [gettimeofday]; for (0..10000) {`rmdir $_`} print &tv_interval($start, [gettimeofday]), "s for rmdir.\n";
# $start = [gettimeofday]; for (0..10000) {mkdir $_} print &tv_interval($start, [gettimeofday]), "s for mkdirAlt.\n";
# $start = [gettimeofday]; for (0..10000) {rmdir $_} print &tv_interval($start, [gettimeofday]), "s for rmdirAlt.\n";

$start = [gettimeofday]; for (0..10000) {`mv $file "$file.bak"`; `mv "$file.bak" $file`} print &tv_interval($start, [gettimeofday]), "s for mv.\n";
$start = [gettimeofday]; for (0..10000) {use File::Copy "move"; move ($file, "$file.bak"); move ("$file.bak", $file); delete $INC{'Copy.pm'}} print &tv_interval($start, [gettimeofday]), "s for mvAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $ping = `ping megami.veritas.com`} print &tv_interval($start, [gettimeofday]), "s for ping.\n";
$start = [gettimeofday]; for (0..10000) {use Net::Ping; my $pingAlt = Net::Ping->new(); my $p = $pingAlt->ping("megami.veritas.com"); $pingAlt->close(); delete $INC{'Ping.pm'}} print &tv_interval($start, [gettimeofday]), "s for pingAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $ps = `ps -elf`} print &tv_interval($start, [gettimeofday]), "s for ps.\n";
$start = [gettimeofday]; for (0..10000) {use Proc::ProcessTable; my $table = new Proc::ProcessTable ('cache_ttys' => 1); delete $INC{'ProcessTable.pm'}} print &tv_interval($start, [gettimeofday]), "s for psAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $pwd = `pwd`} print &tv_interval($start, [gettimeofday]), "s for pwd.\n";
$start = [gettimeofday]; for (0..10000) {my $pwdAlt = $ENV{'PWD'}} print &tv_interval($start, [gettimeofday]), "s for pwdAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $sed = `sed 's/vx/sym/g' $file`} print &tv_interval($start, [gettimeofday]), "s for sed.\n";
$start = [gettimeofday]; for (0..10000) {open FILE, $file; local $/; my $sedAlt = <FILE>; close FILE; $sedAlt =~ s/vx/sym/g} print &tv_interval($start, [gettimeofday]), "s for sedAlt.\n";

$start = [gettimeofday]; for (0..10000) {`sleep 0`} print &tv_interval($start, [gettimeofday]), "s for sleep.\n";
$start = [gettimeofday]; for (0..10000) {sleep 0} print &tv_interval($start, [gettimeofday]), "s for sleepAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $sort = `sort $file`} print &tv_interval($start, [gettimeofday]), "s for sort.\n";
$start = [gettimeofday]; for (0..10000) {open FILE, $file; my @sortAlt = <FILE>; close FILE; @sortAlt = sort @sortAlt} print &tv_interval($start, [gettimeofday]), "s for sortAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $tail = `tail $file`} print &tv_interval($start, [gettimeofday]), "s for tail.\n";
$start = [gettimeofday]; for (0..10000) {open FILE, $file; my @tailAlt = <FILE>; close FILE} print &tv_interval($start, [gettimeofday]), "s for tailAlt.\n";

$start = [gettimeofday]; for (0..10000) {`touch $dir/$_`} print &tv_interval($start, [gettimeofday]), "s for touch.\n";
$start = [gettimeofday]; for (0..10000) {`rm $dir/$_`} print &tv_interval($start, [gettimeofday]), "s for rm.\n";
$start = [gettimeofday]; for (0..10000) {open FILE, ">>$dir/$_"; close FILE} print &tv_interval($start, [gettimeofday]), "s for touchAlt.\n";
$start = [gettimeofday]; for (0..10000) {unlink "$dir/$_"} print &tv_interval($start, [gettimeofday]), "s for rmAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $umask = `umask`} print &tv_interval($start, [gettimeofday]), "s for umask.\n";
$start = [gettimeofday]; for (0..10000) {my $umaskAlt = umask;} print &tv_interval($start, [gettimeofday]), "s for umaskAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $uname = `uname -a`} print &tv_interval($start, [gettimeofday]), "s for uname.\n";
$start = [gettimeofday]; for (0..10000) {use Config; delete $INC{'Config.pm'}} print &tv_interval($start, [gettimeofday]), "s for unameAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $uniq = `uniq $file`} print &tv_interval($start, [gettimeofday]), "s for uniq.\n";
$start = [gettimeofday]; for (0..10000) {my @uniqAlt, my %seen = (); open FILE, $file; while(<FILE>) {push(@uniqAlt, $_) unless $seen{$_}++} close FILE} print &tv_interval($start, [gettimeofday]), "s for uniqAlt.\n";

$start = [gettimeofday]; for (0..10000) {my $wc = `wc -l $file`} print &tv_interval($start, [gettimeofday]), "s for wcL.\n";
$start = [gettimeofday]; for (0..10000) {my $lines; open FILE, $file; while(<FILE>) {$lines++} close FILE} print &tv_interval($start, [gettimeofday]), "s for wcLAlt.\n";

# TODO: /dev/null - File::Spec, dig/nsupdate - (Net::DNS*), dladm, exportfs, fuser, lsitab, mailx - Mail::* netstat, nohup, projadd, projdel, projects, projmod, su, uadmin, zoneadm/zonecfg/zonename
# Not in VRTSPerl: cksum - String::CRC::Cksum, cpio - Archive::Cpio df - Filesys::Df, crontab - Config::Crontab, fstyp/lockfs/mount/share/umount/unshare - Sys::Filesystem/Sys::Filesystem::MountPoint, ifconfig - Net::Ifconfig::Wrapper, pkginfo - Solaris::Package, route - Net::Route* rpm, rsh - Net::Rsh, ssh - Net::SSH2, stty - IO::Stty, svcadm/svccfg/svcprop/svcs - Solaris::SMF*, tar - Archive::Tar (slower), which - File::Which
# http://www.troubleshooters.com/codecorn/littperl/perlreg.htm

# perl -e 'use Time::HiRes qw(gettimeofday); print gettimeofday, "LOG MESSAGE HERE"'

# DEVNULL redirection.