#!/bin/bash

DLV=./dlv
DIRNAME=`dirname $0`
TMPFILE=`mktemp --suffix=.decbench`
$DLV -silent -filter=requires -filter=instancesFolder -filter=testcaseCommand -filter=testcaseExecutionData -filter=resourceLimit $DIRNAME/staticPredicates.dl $1 $2 > $TMPFILE
$DIRNAME/genMakefile.pl $TMPFILE $3 > Makefile
#rm -f $TMPFILE
