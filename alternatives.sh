#! /usr/dt/bin/dtksh
#
#  Author: Sravan Bhamidipati @bsravanin
#  License: MIT License http://www.opensource.org/licenses/mit-license.php
#  Courtesy: Symantec Corporation http://www.symantec.com
#  Date: 14th November, 2011
#  Purpose: To compare alternatives to Ksh anti-patterns.

file=/data/builds/SxRT-5.1SP1-2010-09-01a/dvd1-sol_sparc/readme_first.txt
line="I'm as mad as hell, and I can't take this anymore."

time for ((i=0; i<10000; i++)); do awk=`awk '{print $3}' $file`; done
time for ((i=0; i<10000; i++)); do awkAlt=`cut -f3 -d" " $file`; done
time for ((i=0; i<10000; i++)); do while read -A awkAlt; do :; done < $file; done
echo awk

time for ((i=0; i<10000; i++)); do awkGrep=`awk '{print $3}' $file | grep the`; done
time for ((i=0; i<10000; i++)); do awkGrepAlt=`awk '{if($3~/the/) print $3}' $file`; done
echo awkGrep

time for ((i=0; i<10000; i++)); do awkSed=`awk '{print $3}' $file | sed 's/the/das/g'`; done
time for ((i=0; i<10000; i++)); do awkSedAlt=`nawk '{sub(/the/, "das", $3); print $3}' $file`; done
echo awkSed

time for ((i=0; i<10000; i++)); do awkSort=`awk '{print NF}' $file | sort -n | tail -1`; done
time for ((i=0; i<10000; i++)); do awkSortAlt=`awk 'BEGIN {max=0} {if(max<NF) max=NF} END {print max}' $file`; done
echo awkSort

time for ((i=0; i<10000; i++)); do basename=`basename $file`; done
time for ((i=0; i<10000; i++)); do if [[ $file == *"/" ]]; then basenameAlt=${file%/}; basenameAlt=${basenameAlt##*/}; else basenameAlt=${file##*/}; fi; if [[ $basenameAlt == "" ]]; then $basenameAlt="/"; fi; done
echo basename

time for ((i=0; i<10000; i++)); do cat=`cat $file`; done
time for ((i=0; i<10000; i++)); do while read line; do catAlt=$catAlt"\n"$line; done < $file; done
echo cat

time for ((i=0; i<10000; i++)); do catAwk=`cat $file | awk '{print $1}'`; done
time for ((i=0; i<10000; i++)); do catAwkAlt=`awk '{print $1}' $file`; done
echo catAwk

time for ((i=0; i<10000; i++)); do catGrep=`cat $file | grep vx`; done
time for ((i=0; i<10000; i++)); do catGrepAlt=`grep vx $file`; done
echo catGrep

time for ((i=0; i<10000; i++)); do catHead=`cat $file | head`; done
time for ((i=0; i<10000; i++)); do catHeadAlt=`head $file`; done
echo catHead

time for ((i=0; i<10000; i++)); do catRead=`cat $file | while read line; do echo $line; done`; done
time for ((i=0; i<10000; i++)); do catReadAlt=`while read line; do echo $line; done < $file`; done
echo catRead

time for ((i=0; i<10000; i++)); do catSed=`cat $file | sed 's/vx/sym/g'`; done
time for ((i=0; i<10000; i++)); do catSedAlt=`sed 's/vx/sym/g' $file`; done
echo catSed

time for ((i=0; i<10000; i++)); do catTail=`cat $file | tail`; done
time for ((i=0; i<10000; i++)); do catTailAlt=`tail $file`; done
echo catTail

time for ((i=0; i<10000; i++)); do catWc=`cat $file | wc`; done
time for ((i=0; i<10000; i++)); do catWcAlt=`wc $file`; done
echo catWc

time for ((i=0; i<10000; i++)); do /usr/bin/cd; /usr/bin/cd -; done
time for ((i=0; i<10000; i++)); do cd; cd -; done
echo cd

time for ((i=0; i<10000; i++)); do id="uid=0(root) gid=0(root)"; cuts=`echo $id | cut -d' ' -f1 | cut -d'=' -f2 | cut -d '(' -f1`; done
time for ((i=0; i<10000; i++)); do id="uid=0(root) gid=0(root)"; id1=${id%%"("*}; idAlt=${id1#*=}; done
echo cuts

time for ((i=0; i<10000; i++)); do devNull=`echo 2>/dev/null`; done
time for ((i=0; i<10000; i++)); do devNullAlt=`echo`; done
echo devNull

time for ((i=0; i<10000; i++)); do dirname=`dirname $file`; done
time for ((i=0; i<10000; i++)); do if [[ $file == *"/" ]]; then dirnameAlt=${file%/}; dirnameAlt=${dirnameAlt%/*}; else dirnameAlt=${file%/*}; fi; if [[ $dirnameAlt == "" ]]; then $dirnameAlt="/"; fi; done
echo dirname

time for ((i=0; i<10000; i++)); do echo=`/usr/bin/echo`; done
time for ((i=0; i<10000; i++)); do echoAlt=`echo`; done
echo echo

time for ((i=0; i<10000; i++)); do echoAwk=`echo $line | awk '{print $3}'`; done
time for ((i=0; i<10000; i++)); do echoAwkAlt=($line); done
echo echoAwk

time for ((i=0; i<10000; i++)); do echoCut=`echo $line | cut -f3 -d" "`; done
time for ((i=0; i<10000; i++)); do echoCutAlt=($line); done
echo echoCut

time for ((i=0; i<10000; i++)); do echoGrep=`echo $line | grep crazy`; echoGrep=$?; done
time for ((i=0; i<10000; i++)); do if [[ $line == *"crazy"* ]]; then echoGrepAlt=0; else echoGrepAlt=1; fi; done
echo echoGrep

time for ((i=0; i<10000; i++)); do echoSed=`echo $line | sed 's/mad/crazy/g'`; done
time for ((i=0; i<10000; i++)); do echoSedAlt=${line/mad/crazy}; done
echo echoSed

time for ((i=0; i<10000; i++)); do echoWcM=`echo $line | wc -m`; done
time for ((i=0; i<10000; i++)); do echoWcMAlt=${#line}; done
echo echoWcM

time for ((i=0; i<10000; i++)); do echoWcW=`echo $line | wc -w`; done
time for ((i=0; i<10000; i++)); do array=($line); echoWcWAlt=${#array[*]}; done
echo echoWcW

time for ((i=0; i<10000; i++)); do exprInt=`expr $exprInt + 1`; done
time for ((i=0; i<10000; i++)); do exprAlt=$((exprAlt+1)); done
echo expr

time for ((i=0; i<10000; i++)); do grepAwk=`grep vx $file | awk '{print $3}'`; done
time for ((i=0; i<10000; i++)); do for line in `grep vx $file`; do grepAwkAlt=($line); done; done
echo grepAwk

time for ((i=0; i<10000; i++)); do greps=`grep vx $file | grep the`; done
time for ((i=0; i<10000; i++)); do grepsAlt=`sed '/vx/!d; /the/!d' $file`; done
echo greps

time for ((i=0; i<10000; i++)); do grepSed=`grep vx $file | sed 's/vx/sym/g'`; done
time for ((i=0; i<10000; i++)); do grepSedAlt=`sed '/vx/!d; s/vx/sym/g' $file`; done
echo grepSed

time for ((i=0; i<10000; i++)); do grepV=`grep vx $file | grep -v the`; done
time for ((i=0; i<10000; i++)); do grepVAlt=`sed '/vx/!d; /the/d' $file`; done
echo grepV

time for ((i=0; i<10000; i++)); do grepWc=`grep vx $file | wc -l`; done
time for ((i=0; i<10000; i++)); do grepWcAlt=`grep -c vx $file`; done
echo grepWc

time for ((i=0; i<10000; i++)); do head=`head -1 $file`; done
time for ((i=0; i<10000; i++)); do while read headAlt; do break; done < $file; done
echo head

time for ((i=0; i<10000; i++)); do headAwk=`head -1 $file | awk '{print $3}'`; done
time for ((i=0; i<10000; i++)); do while read -A headAwkAlt; do break; done < $file; done
echo headAwk

time for ((i=0; i<10000; i++))
do
	sleep 10 &
	pid=$!
	/usr/bin/kill -9 $pid
done
time for ((i=0; i<10000; i++))
do
	sleep 10 &
	pid=$!
	kill -9 $pid
done
echo kill

time for ((i=0; i<10000; i++)); do lsAwk=`ls -l /dev/dsk/c0t0d0s0 | awk '{print $11}'`; done
time for ((i=0; i<10000; i++)); do lsAwkAlt=(`ls -l /dev/dsk/c0t0d0s0`); done
echo lsAwk

time for ((i=0; i<10000; i++)); do pwd=`/usr/bin/pwd`; done
time for ((i=0; i<10000; i++)); do pwdAlt=$PWD; done
echo pwd

time for ((i=0; i<10000; i++)); do echo $line >> redirection; done
time for ((i=0; i<10000; i++)); do echo $line; done >> redirectionAlt
rm redirection redirectionAlt
echo redirection

time for ((i=0; i<10000; i++)); do seds=`sed 's/vx/sym/g' $file | sed 's/the /das /g'`; done
time for ((i=0; i<10000; i++)); do sedsAlt=`sed 's/vx/sym/g; s/the /das /g' $file`; done
echo seds

time for ((i=0; i<10000; i++)); do tailAwk=`tail -1 $file | awk '{print $3}'`; done
time for ((i=0; i<10000; i++)); do tailAwkAlt=(`tail -1 $file`); done
echo tailAwk

time for ((i=0; i<10000; i++)); do /usr/bin/test -f $file; done
time for ((i=0; i<10000; i++)); do test -f $file; done
echo test

time for ((i=0; i<10000; i++)); do /usr/bin/touch $file; done
time for ((i=0; i<10000; i++)); do : >> $file; done
echo touch

time for ((i=0; i<10000; i++)); do /usr/bin/true; done
time for ((i=0; i<10000; i++)); do true; done
echo true

time for ((i=0; i<10000; i++)); do ulimit=`/usr/bin/ulimit`; done
time for ((i=0; i<10000; i++)); do ulimitAlt=`ulimit`; done
echo ulimit

time for ((i=0; i<10000; i++)); do umask=`/usr/bin/umask`; done
time for ((i=0; i<10000; i++)); do umaskAlt=`umask`; done
echo umask

time for ((i=0; i<10000; i++)); do uname=`uname -a`; done
OSTYPE=SunOS; HOSTNAME=pilsner.vxindia.veritas.com; RELEASE=5.10; VERSION=Generic_141444-09; MACHTYPE=sun4v; HOSTTYPE=sparc; PLATFORM=SUNW,SPARC-Enterprise-T5120
time for ((i=0; i<10000; i++)); do unameAlt="$OSTYPE $HOSTNAME $RELEASE $VERSION $MACHTYPE $HOSTTYPE $PLATFORM"; done
echo uname

time for ((i=0; i<10000; i++)); do wcAwk=`wc -l $file | awk '{print $1}'`; done
time for ((i=0; i<10000; i++)); do wcAwkAlt=(`wc -l $file`); done
echo wcAwk

# TODO: Alternatives: Smaller basename/dirname. Smaller file inputs. cat Vs read. What about eval?
