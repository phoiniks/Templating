#!/usr/bin/python3

from collections import Counter
import math
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
    frequenz = zaehler.most_common()

    lexikon = list(enumerate(lexikon_bereinigt))

    # Nur zur Kontrolle, wird ersetzt durch Redis-, MongoDB- und/oder SQL-Anbindung:

    print("\nLänge des Textes: {}\n".format(len(lexikon)))

    print(lexikon)

    print()
    
    print("=" * 150)

    print()

    print("\nLänge des Lexikons: {}\n\n".format(len(frequenz)))    

    drittel = math.floor(len(frequenz) / 3)

    print("Mittleres Drittel beginn bei Lemma {}.\n".format(drittel * 2))
    
    print("Das mittlere Drittel (der Frequenzanalyse gemäß der semantisch relevanteste Teil des Textes):\n")

    print(frequenz[drittel:(drittel * 2)])
