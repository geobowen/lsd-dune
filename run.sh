#!/bin/bash

convert -contrast $1.jpg $1.pgm 
convert -contrast $1.pgm $1.pgm 

./lsd -s 0.5 -c 0.7 -d 0.7 -P $1.eps -S $1.svg $1.pgm $1_crest.txt

evince $1.eps
