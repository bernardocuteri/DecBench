#!/usr/bin/python3.5

import subprocess 
import re
import xml.etree.ElementTree as ET

result = subprocess.run(['grep', '-Rl', 'bad_alloc'],stdout=subprocess.PIPE)

out = result.stdout.decode('utf-8')

print(out)

array = out.split("\n")

print(array)

for bad in array:
    m = re.search('^([\w]+)/.*/(k_cut-[\d]+).dat', bad)
    if m:
        xml = m.group(1)+"/k_cut/refinedBenchmarks/"+m.group(2)+".xml"
        tree = ET.parse(xml)
        root = tree.getroot()
        for elem in root.iter('cpuTime'): 
        	elem.text = '-'
        for elem in root.iter('wallTime'): 
        	elem.text = '-'
        for elem in root.iter('maxVirtualMemory'): 
        	elem.text = 'maximumVSizeExceeded'
        tree.write(xml)

