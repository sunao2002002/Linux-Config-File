#!/usr/bin/python
import hashlib
import os
import sys

def calcmd5(filepath):
    with open(filepath, 'rb') as f:
        md5obj = hashlib.md5()
        md5obj.update(f.read())
        hash = md5obj.hexdigest()
        return hash

def checkmd5(md5file):
    with open(md5file, "r") as f:
        lines = f.readlines()
        for line in lines:
            array = line.strip().split()
            if len(array) >0:
                md5value = array[0].strip()
                filepath = array[1].strip()
                if os.path.exists(filepath):
                    if calcmd5(filepath) != md5value:
                        print filepath, "Failed"
                    else:
                        print filepath, "OK"
                else:
                    print filepath, "Missing"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "Not enough parameter"
        sys.exit(0)
    if sys.argv[1] == '-c':
        if len(sys.argv) < 3:
            print "please specific the md5sum file"
            sys.exit(0)
        md5file = sys.argv[2]
        if os.path.exists(md5file):
            checkmd5(md5file)
        else:
            print "file not found"
    else:
        for hashfile in sys.argv[1:]:
            if  os.path.exists(hashfile):
                print calcmd5(hashfile), "\t", hashfile
            else:
                print hashfile, "Missing"
