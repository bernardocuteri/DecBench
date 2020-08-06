#!/usr/bin/python3

import os
import sys
from tempfile import mkstemp
from shutil import move
from os import fdopen, remove

def replaceWithMemoryOut(file_path):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                if 'wallTime' in line:
                    new_file.write("    <wallTime>-</wallTime>\n")
                elif 'cpuTime' in line:
                    new_file.write("    <cpuTime>-</cpuTime>\n")
                elif 'maxVirtualMemory' in line:
                    new_file.write("    <maxVirtualMemory>maximumVSizeExceeded</maxVirtualMemory>\n")
                else:
                    new_file.write(line)
    #Remove original file
    remove(file_path)
    #Move new file
    move(abs_path, file_path)

if len(sys.argv)!=2: 
    print("Expection exactly one argument: the benchmark folder")
    sys.exit(0)

rootdir = sys.argv[1]

for solver in os.listdir(rootdir):
    for benchmark in os.listdir(rootdir+"/"+solver):
        for output in os.listdir(rootdir+"/"+solver+"/"+benchmark+"/outputs"):
            refinedBenchmarkFile = output.replace(".dat", ".xml")
            with open(rootdir+"/"+solver+"/"+benchmark+"/outputs/"+output) as out_file:
                error = False
                for line in out_file:
                    if ("error" in line.lower()) or ("bad_alloc" in line.lower()):
                        error = True
                        break
                if error:
                    replaceWithMemoryOut(rootdir+"/"+solver+"/"+benchmark+"/refinedBenchmarks/"+refinedBenchmarkFile)
                    
                        
