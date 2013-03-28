#! /usr/bin/bash
#
#  Author: Sravan Bhamidipati
#  Date: 8th December, 2010
#  Purpose: To collect anti-patterns on all packages in AIX, Cygwin, HP-UX, RHEL, Solaris.

# AIX: 805 packages
# CYGWIN: 386 packages
# HPUX: 117 packages (Perl regexp problems)
# RHEL: 538 packages
# SAMG: SFRAC (23), VOM (2), installer, arrayrep, vcsrvm-cvs
# SOLARIS: 1124 packages

if [[ $OSTYPE =~ "aix" ]]; then
	IFS=":"

	lslpp -lc | while read line
	do
		if [[ $line =~ "Fileset" || $line =~ "VRTS" ]]; then :
		else
			array=($line)
			./anti-patterns.pl ${array[1]}
		fi
	done

	unset IFS
	mkdir -p aix/perl aix/shell aix/summary aix/unknown
	mv *-perl-* aix/perl/
	mv *-shell-* aix/shell/
	mv *-summary.txt aix/summary/
	mv *-unknown.txt aix/unknown/
elif [[ $OSTYPE =~ "cygwin" ]]; then
	i=0

	cygcheck -c | while read line
	do
		if [ $i -lt 2 ]; then ((i++))
		else ./anti-patterns.pl ${line%% *}
		fi
	done

	mkdir -p cygwin/perl cygwin/shell cygwin/summary cygwin/unknown
	mv *-perl-* cygwin/perl/
	mv *-shell-* cygwin/shell/
	mv *-summary.txt cygwin/summary/
	mv *-unknown.txt cygwin/unknown/
elif [[ $OSTYPE =~ "hpux" ]]; then
	swlist | while read line
	do
		if [[ $line == "" || $line =~ "#" || $line =~ "VRTS" ]]; then :
		else
			array=($line)
			./anti-patterns.pl ${array[0]}
		fi
	done

	mkdir -p hpux/perl hpux/shell hpux/summary hpux/unknown
	mv *-perl-* hpux/perl/
	mv *-shell-* hpux/shell/
	mv *-summary.txt hpux/summary/
	mv *-unknown.txt hpux/unknown/
elif [[ $OSTYPE =~ "linux" ]]; then
	rpm -qa | while read line
	do
		if [[ $line =~ "VRTS" ]]; then :
		else ./anti-patterns.pl $line
		fi
	done

	mkdir -p linux/perl linux/shell linux/summary linux/unknown
	mv *-perl-* linux/perl/
	mv *-shell-* linux/shell/
	mv *-summary.txt linux/summary/
	mv *-unknown.txt linux/unknown/
elif [[ $OSTYPE =~ "solaris" ]]; then
	pkginfo | while read line
	do
		array=($line)
		if [[ ${array[1]} =~ "VRTS" ]]; then :
		else ./anti-patterns.pl ${array[1]}
		fi
	done

	mkdir -p solaris/perl solaris/shell solaris/summary solaris/unknown
	mv *-perl-* solaris/perl/
	mv *-shell-* solaris/shell/
	mv *-summary.txt solaris/summary/
	mv *-unknown.txt solaris/unknown/
fi
