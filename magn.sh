#!/bin/sh

FILE=$1

if [ $# == 0 ]
then
	echo "  "
	echo " Skripta se pokrece sa :" 
	echo " magn [FILE]"
	echo " probaj -h"
	exit 1
elif [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "  "
	echo " magn [FILE]"
	echo "  "
	echo "  "
	echo " FILE treba da bude u obliku :"
	echo " 	@ VREME"
	echo " 	SHW MAGN"
	echo " 	."
	echo " 	."
	echo " 	."
	echo " 	@ VREME"
	echo " 	."
	echo " 	."
	echo " 	."
	echo " 	@ VREME"
	echo "  "
	echo "  "
	echo " MAGN mora biti iz intervala [-6,7], da bi se ispostovao IMO standard."
	echo " polovicne magnitude (2.5) su skroz prihvatljive"
	echo " Skripta vas nece upozoriti nikada. Treba je koristiti pazljivo"
	echo " SHW moze biti bilo koji niz karaktera i brojeva. Moze i vise"
	echo " @ VREME oznacava promenu intervala za distribuciju magnituda. Naravno, to podrazumeva i pocetak i kraj"
	echo " Primer dobro uredjenog fajla:"
	echo "  "
	echo "  "
	echo " @ 2200"
	echo " p 1.5"
	echo " p -2.5"
	echo " p 3"
	echo " @ 2210"
	echo " s 3"
	echo " stogod1 5"
	echo " @ 2215"

	exit 0
fi

printf "DATE UT; START; END; SHOWER; -6; -5; -4; -3; -2; -1; 0; 1; 2; 3; 4; 5; 6; 7\n"

sed 's/[ \t]*p[ \t]*/ PER /g; s/[ \t]*s[\t]*/ SPO /g; s/[ \t]*a[\t]*/ ANT /g; s/[ \t]*k[\t]*/ KCG /g; s/[ \t]g[\t]*/ GEM /g; s/[ \t]*d[\t]*/ SDA /g; s/[ \t]*c[\t]*/ CAP /g' "$FILE" | awk '
	BEGIN{times=-1;}
	NR==1 {times = $2;}

	$1=="@" && NR!=1 {for(shw in count) {printf("May 11 1998; %04d; %04d; %s; ", times, $2, shw); 
	for(mag=-6; mag<=7; mag++) {printf("%.1f; ", count[shw][mag])} 
	printf("\n");} times = $2; delete count;}

	$1!="@" {
	count[$1][int($2)]+=0.5; count[$1][int($2) + ($2>int($2)) - ($2<int($2)) ]+=0.5;}'| sort -t ';' -k 2 -k 4
