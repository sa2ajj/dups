#! /usr/bin/python -tt

"""
A simple tool to find duplicate file files
"""

import sys, os

from collections import defaultdict

from hashlib import sha1

def main(dirs):
    """
    entry point
    """
    if not dirs:
        dirs = ['.']

    data = defaultdict(list)

    for dirname in dirs:
        for path, _, files in os.walk(dirname):
            for name in files:
                fname = os.path.join(path, name)
                with open(fname, 'rb') as handle:
                    data[sha1(handle.read()).digest()].append(fname)

    for files in [sorted(v) for v in data.values() if len(v) > 1]:
        print '%d duplicates' % len(files)
        for fname in files:
            print ' ', fname

if __name__ == '__main__':
    main(sys.argv[1:])
