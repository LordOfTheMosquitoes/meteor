#!/bin/sh

# David Buzgo 23.7.2019.

if [ $# = 0 ] 
then
	echo " "
	echo " rate [FILE]"
	echo " probaj 	rate -h"
	exit 1

elif [ "$1" = "-h" ] ||  [ "$1" = "--help" ]
then
	echo "  "
	echo " rate [FILE]"
	echo " Skripta dobija MAGN fajl u IMO formatu i vraca RATE fajl u IMO formatu"
	echo " Skritpa ne racuna efektivno vreme posmatranja"
	exit 0
fi


MFN="$1"

d=0
while [ -f /tmp/meteortmp-$d ]
do
	d=$((d+1))
done

echo "DATE UT; START; END; Teff; RA; Dec; F; Lm; $(awk -F ';' 'NR>1{printf("%s\n", $4);}' "$MFN" | sort | sed 's/\W//g' | uniq | tr '\n\r' '?' | sed 's/\?/; /g;  s/\W*$//g')" > /tmp/meteortmp-$d

 awk -F ';' '
 NR>1 && FNR==NR{
 	printf("%s\n", $4)
 }
 NR==1{ len = NF; for(i=9; i<NF; i+=2) raspored[i] = $i; printf("%s\n", $0); }
 FNR != NR && FNR==2{times = $2}
 FNR != NR && times!=$2 && FNR>2 {
 	printf("May 11 1998; %s; %s; 0.000; 310; 40; 1; 6.5; C; %d", times, $2, sum[raspored[9]]);
 	for(i=11; i<len; i+=2) printf("; C; %d",sum[raspored[i]]);
 	printf("\n");
 
 	for(i=9; i<len; i+=2) sum[raspored[i]] = 0; 
 	times=$2;
 	}
 NR!=FNR && FNR>1{ for(i=5; i<NF; i++){sum[$4]+=$i;} }
 END{
 	printf("May 11 1998; %s; %s; 0.000; 310; 40; 1; 6.5; C; %d", times, $3, sum[raspored[9]]);
 	for(i=11; i<len; i+=2)
 		printf("; C; %d",sum[raspored[i]]);
 	printf("\n");
 }
 ' /tmp/meteortmp-$d "$MFN"

 rm /tmp/meteortmp-$d
