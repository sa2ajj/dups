Find Duplicate Files
====================

These two tools perform the same task: find duplicated files in given
directories.

``dups.py``
    Implementation in Python
``dups``
    Implementation in Erlang

Two files are considered "same" if there SHA-1 sum (regardless the size) are
the same.

The only difference between the versions is that since Erlang supports very
well parallel computations, all supplied directories are processed in parallel.
