#!/usr/bin/python3

import sys, os, re

analyzedlist = []

def dep(f, prog):
    if prog in analyzedlist:
        return
    else:
        analyzedlist.append(prog)
    pname = prog.split('/')[-1]
    needed = os.popen('ldd '+prog)
    neededso = re.findall(r'[>](.*?)[(]', needed.read())
    print(prog, neededso)
    for so in neededso:
        if len(so.strip()) >0:
            f.write('"' + pname +'" -> "' +so.split('/')[-1] + '";\n')
            dep(f, so)

def main(argv):
    f = open('/tmp/libdep.dot', 'w', encoding='utf-8')
    f.write('digraph graphname {\n')
    dep(f, argv)
    f.write('}\n')
    f.close()
    os.popen('dot -Tpng -o ./deps.png /tmp/libdep.dot')


if __name__ == "__main__":
    if len(sys.argv)==2:
        main(sys.argv[1])