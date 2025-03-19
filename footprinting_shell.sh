#!/bin/bash

#usage : ./footprinting.sh <domaine>
if [ "$#" -ne 1 ]; then
	echo "usage : $0 domaine"
	exit 1
fi

#le repertoire de sortie

domaine=$1
repertoire="footprinting_$domaine"

mkdir -p "$repertoire"
cd footprinting_$domaine

# 1- WHOIS

echo "les infos de whois"
whois $domaine > whois.txt

# 1-DIG
echo "les infos de dig"

dig $domaine ANY > dig.txt
dig $domaine MX > dig_mx.txt

# 2-NSLOOKUP

echo "les infos de nslookup"

nslookup $domaine > nslookup.txt

# 3- theHavester
#
echo "les infos sur theHvester"
theHavester $domaine > thehavester.txt

# 4-traceroute
#
echo "les infos de traceroute"
traceroute $domaine > traceroute.txt






