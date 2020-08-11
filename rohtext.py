#!/usr/bin/python

from sys import argv
import regex

with open(argv[1]) as datei:
     text = datei.read()
     rohtext = regex.search(r'\\\opening\{ .*, \}(.*)\\\closing\{ .* \}', text, regex.S|regex.M)
     rohtext = rohtext.group(1)
     ergebnis = regex.sub('(?:\\\.*\{|\}|\\\\-|\\\)', '', rohtext) 
     print(ergebnis)
             
