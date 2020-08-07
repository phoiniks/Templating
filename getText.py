#!/usr/bin/python3

import re
from sys import argv

with open(argv[1]) as datei:
    latex = datei.read()
    text = re.search(r'\\opening\{ .*, }(.*)\\closing', latex, re.S|re.M)
    print(text.group(1))
