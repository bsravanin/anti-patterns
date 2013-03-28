#! /usr/bin/perl -w
#
#  Author: Sravan Bhamidipati @bsravanin
#  Contributor: Rocky Ren
#  License: MIT License http://www.opensource.org/licenses/mit-license.php
#  Courtesy: Symantec Corporation http://www.symantec.com
#  Date: 14th November, 2011
#  Purpose: To identify anti-patterns in Perl/Shell files of any directory or a package in AIX, Cygwin, HPUX, RHEL, or Solaris.

use strict;
use File::Basename;
use File::stat;

if (scalar(@ARGV) != 3) {die "Usage: $0 <libFile> file|dir|pkg <fileName|dirPath|pkgName>\n"}

my ($library, $type, $pointer) = ($ARGV[0], $ARGV[1], $ARGV[2]);

########## PARSE ANTI-PATTERNS LIBRARY ##########
open LIB, $library || die "Cannot open $library for read!\n";
my ($lang, %rule, @perlRules, @shellRules);
while (<LIB>) {
	chomp();

	if (/^\s*LANG\s*:/) {s/^\s*LANG\s*:\s*//g; $lang = $_}
	elsif (/^\s*REGEX\s*:/) {s/^\s*REGEX\s*:\s*//g; $rule{'REGEX'} = $_}
	elsif (/^\s*HINT\s*:/) {$rule{'HINT'} = $_}
	elsif (/^\s*LEVEL\s*:/) {$rule{'LEVEL'} = $_}
	elsif(defined $lang && defined $rule{'REGEX'}) {
		if ($lang eq "perl") {push @perlRules, {%rule}}
		elsif ($lang eq "shell") {push @shellRules, {%rule}}

		undef $lang, undef %rule;
	}
}
close LIB;
########## PARSE ANTI-PATTERNS LIBRARY ##########

my ($extRegex, $files) = ("\.1m$|\.add$|\.alias$|\.asm$|\.bat$|\.bdf$|\.bmcmap$|\.cat$|\.cf$|\.cfg$|\.cnf$|\.conf$|\.css$|\.dat$|\.def$|\.definition$|\.desktop$|\.dict$|\.dp$|\.dt$|\.dtd$|\.edf$|\.enc$|\.exclude$|\.exe$|\.exp$|\.fig$|\.help$|\.hdr$|\.history$|\.htm$|\.html$|\.info$|\.ini$|\.js$|\.json$|\.jsp|\.key$|\.kt$|\.la$|\.log$|\.Log$|\.lst$|\.mak$|\.man$|\.map$|\.mdl$|\.mf$|\.MF$|\.mib$|\.mk$|\.model$|\.msg$|\.name$|\.nxt$|\.opts$|\.ora$|\.pasm$|\.pc$|\.pdf$|\.pem$|\.Po|\.pod$|\.policy$|\.properties$|\.props$|\.py$|\.rep$|\.sample|\.serv$|\.SF$|\.smc$|\.sql$|\.ssh$|\.syntax$|\.tag$|\.tbl$|\.tcl$|\.tdf$|\.template$|\.texi$|\.tf$|\.tld$|\.tmpl$|\.txe$|\.txt$|\.TXT$|\.upr$|\.wrap$|\.xml$|\.yml$|AUTHORS|copyright|CHANGELOG|\/config\-|CREDITS|esmweb\/jre|esmwebprotofile|fonts|INSTALL|jre\/man|macros.d|main\.cf|man\/man|MANIFEST|NEWS|\/opt\/VRTSsfmh\/operations|README|THANKS|UNINSTALL|\/usr\/lib\/adb|vos_sol_sparc|vvrflowcon", "");

########## DETERMINE LIST OF FILES TO PARSE ##########
if ($type eq "dir") {
	map {
		if (!/$extRegex/ && !/\(new|changelog$|makefile|readme$|readme\./i) {$files = $files .  " \"$_\""}
	} split ("\n", `find $pointer` || die "Directory $pointer has no files.\n");

	$pointer = basename($pointer);
}
elsif ($type eq "pkg") {
	if ($^O eq "aix") {
		map {
			if (!/\-\>/ && !/$extRegex/ && !/\(new|changelog$|makefile|readme$|readme\./i) {s/.*://; $files = $files .  " \"$_\""}
		} split ("\n", `lslpp -fc $pointer` || die "Check package name $pointer.\n");
	}
	elsif ($^O eq "cygwin") {
		map {
			if (!/$extRegex/ && !/\(new|changelog$|makefile|readme$|readme\./i) {$files = $files .  " \"$_\""}
		} split ("\n", `cygcheck -l $pointer` || die "Check package name $pointer.\n");
	}
	elsif ($^O eq "hpux") {
		map {
			if (!/$extRegex/ && !/\(new|changelog$|makefile|readme$|readme\./i) {$files = $files .  " \"$_\""}
		} split ("\n", `swlist -l file $pointer` || die "Check package name $pointer.\n");
	}
	elsif ($^O eq "linux") {
		map {
			if (!/$extRegex/ && !/\(new|changelog$|makefile|readme$|readme\./i) {$files = $files .  " \"$_\""}
		} split ("\n", `rpm -ql $pointer` || die "Check package name $pointer.\n");
	}
	elsif ($^O eq "solaris") {
		my @filesList = split ("\n", `pkgchk -l $pointer`);
		if ($#filesList < 0) {die "Check package name $pointer.\n"}

		for my $index (0 .. $#filesList) {
			if ($filesList[$index] =~ "Pathname:" && $filesList[$index+1] =~ "regular" && $filesList[$index] !~ /$extRegex/ && $filesList[$index] !~ /\(new|changelog$|makefile|readme$|readme\./i) {
				$filesList[$index] =~ s/Pathname: //;
				$files = $files . " " . $filesList[$index];
			}
		}
	}
}
elsif ($type eq "file") {
	$files = $pointer;
	$pointer = basename($pointer);
}
else {die "Usage: $0 <libFile> file|dir|pkg <fileName|dirPath|pkgName>\n"}
########## DETERMINE LIST OF FILES TO PARSE ##########

my ($size, $PERL, @antipatterns, @summary, @unknown);
if ( -e "/opt/VRTSperl/perl" ) {$PERL = "/opt/VRTSperl/perl"}
else {$PERL = "perl"}

########## DETERMINE PROGRAM TYPE ##########
map {if (/ text| script/) {
	if (/\.al:|\.e2x:|\.ix:|\.pl:|\.pm:|healthcheck:|perl.*script/) {
		s/:\s+.+//;
		&parsePerl($_);

		$size = (stat($_))->size;
		push @summary, "Name: $_\tLang: Perl\tSize: $size";
	}
	elsif (/\.sh:|\.csh:|\.ksh:|vxtestpr:|bash script|ksh script/) {
		s/:\s+.+//;
		&parseShell($_);

		$size = (stat($_))->size;
		push @summary, "Name: $_\tLang: Shell\tSize: $size";
	}
	elsif (/ script| text/) {
		s/:\s+.+//;

		if (`bash -n $_ 2>&1` eq "" || `ksh -n $_ 2>&1` eq "" || `sh -n $_ 2>&1` eq "" || $? == 0) {
			&parseShell($_);

			$size = (stat($_))->size;
			push @summary, "Name: $_\tLang: Shell\tSize: $size";
		}
		elsif (`$PERL -c $_ 2>&1` =~ / syntax OK|Can't locate/) {
			&parsePerl($_);

			$size = (stat($_))->size;
			push @summary, "Name: $_\tLang: Perl\tSize: $size";
		}
		else {push @unknown, $_}
	}
}} split ("\n", `file $files`);
########## DETERMINE PROGRAM TYPE ##########

########## SAVE PERL AND SHELL ANTI-PATTERNS INTO SEPARATE FILES ##########
if ($#antipatterns > 0) {
	open PLANTIPATTERNS, ">$pointer-perl-anti-patterns.txt" || die "Cannot open $pointer-perl-anti-patterns.txt for write: $!\n";
	open SHANTIPATTERNS, ">$pointer-shell-anti-patterns.txt" || die "Cannot open $pointer-shell-anti-patterns.txt for write: $!\n";
	foreach (@antipatterns) {
		if (/Lang: Perl/) {select(PLANTIPATTERNS)}
		elsif (/Lang: Shell/) {select(SHANTIPATTERNS)}
		print "$_\n";
	}
	close PLANTIPATTERNS;
	close SHANTIPATTERNS;

	$size = (stat("$pointer-perl-anti-patterns.txt"))->size;
	if ($size == 0) {unlink("$pointer-perl-anti-patterns.txt")}
	$size = (stat("$pointer-shell-anti-patterns.txt"))->size;
	if ($size == 0) {unlink("$pointer-shell-anti-patterns.txt")}
}
########## SAVE PERL AND SHELL ANTI-PATTERNS INTO SEPARATE FILES ##########

########## SAVE LIST OF PARSED FILES AND THEIR PRPOERTIES IN SUMMARY FILE ##########
if ($#summary > 0) {
	open SUMMARY, ">$pointer-summary.txt" or die "Cannot open $pointer-summary.txt for write: $!\n";
	foreach (@summary) {print SUMMARY "$_\n"}
	close SUMMARY;
}
########## SAVE LIST OF PARSED FILES AND THEIR PRPOERTIES IN SUMMARY FILE ##########

########## SAVE LIST OF FILES OF UNDETERMINABLE TYPE INTO UNKNOWN FILE ##########
if ($#unknown > 0) {
	open UNKNOWN, ">$pointer-unknown.txt" or die "Cannot open $pointer-unknown.txt for write: $!\n";
	foreach (@unknown) {print UNKNOWN "$_\n"}
	close UNKNOWN;
}
########## SAVE LIST OF FILES OF UNDETERMINABLE TYPE INTO UNKNOWN FILE ##########


########## SUBROUTINE TO PARSE PERL PROGRAMS ##########
sub parsePerl {
	open PROG, $_[0] || die "Cannot open $_[0] for read!\n";
	my ($line, $perlAntipatterns, $isNew);
	map {
		chomp();
		$line = $_;
		$isNew = 0;

		(map {if($line !~ /^\s*#|^\s*$|eval 'exec .*perl/ && $line =~ ${$_}{'REGEX'}) {
			if ($isNew == 0) {$isNew++; $perlAntipatterns = $perlAntipatterns . "\nANTI-PATTERN: $line\n${$_}{'LEVEL'}\t${$_}{'HINT'}\n"}
			else {$perlAntipatterns = $perlAntipatterns . "${$_}{'LEVEL'}\t${$_}{'HINT'}\n"}
		}} @perlRules)
	} <PROG>;
	close PROG;

	if (defined $perlAntipatterns) {
		push @antipatterns, "Name: $_[0]\tLang: Perl\tReference: alternatives.pl", $perlAntipatterns, "\n";
	}
}
########## SUBROUTINE TO PARSE PERL PROGRAMS ##########


########## SUBROUTINE TO PARSE SHELL PROGRAMS ##########
sub parseShell {
	open PROG, $_[0] || die "Cannot open $_[0] for read!\n";
	my ($line, $shellAntipatterns, $isNew);
	map {
		chomp();
		$line = $_;
		$isNew = 0;

		(map {if($line !~ /^\s*#|^\s*$/ && $line =~ ${$_}{'REGEX'}) {
			if ($isNew == 0) {$isNew++; $shellAntipatterns = $shellAntipatterns . "\nANTI-PATTERN: $line\n${$_}{'LEVEL'}\t${$_}{'HINT'}\n"}
			else {$shellAntipatterns = $shellAntipatterns . "${$_}{'LEVEL'}\t${$_}{'HINT'}\n"}
		}} @shellRules)
	} <PROG>;
	close PROG;

	if (defined $shellAntipatterns) {
		push @antipatterns, "Name: $_[0]\tLang: Shell\tReference: alternatives.sh", $shellAntipatterns, "\n";
	}
}
########## SUBROUTINE TO PARSE SHELL PROGRAMS ##########
