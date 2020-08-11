#!/usr/bin/python3

from collections import Counter
from sys import argv
from time import sleep
from nltk.tokenize import TreebankWordTokenizer
import regex

tokenizer = TreebankWordTokenizer()

with open(argv[1]) as datei:
    latex = datei.read()
    text = regex.search(r'(\\opening\{ .*, })?(.*)(\\closing)?', latex, regex.S|regex.M)

    if argv[1].endswith('.tex'):
        text = text.group(2)
        text = regex.sub("[.;\\\]", "", text)
        text = regex.sub("\\enquote\{", "", text)
        text = regex.sub("\}", "", text)
    else:
        text = text.group()
        
    lexikon = tokenizer.tokenize(str(text))

    lexikon_bereinigt = [lexem for lexem in lexikon if regex.match("[a-zA-ZäöüÄÖÜ]", lexem)]

    zaehler = Counter(lexikon_bereinigt)
    haeufig = zaehler.most_common(10)

    lexikon = list(enumerate(lexikon_bereinigt))

    # Nur zur Kontrolle, wird ersetzt durch Redis-, MongoDB- und/oder SQL-Anbindung:
    
    print(lexikon)

    print(haeufig)
