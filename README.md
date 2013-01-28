fbsd-release
============

create fbsd-release.tbz for pc-sysinstall(8).

pc-install(8) uses fbsd-release.tbz as install file. it does not support .txz
files officially released by the FreeBSD project. this Makefile fetches,
extracts .txz files and creates fbsd-release.tbz.

target
======

all
---

create fbsd-release.tbz

clean
-----

clean up

variables
=========

ARCH
----

the target architecture

RELEASE
-------

the target release name

WITH_SRC
--------

include src distribution

WITH_PORTS
----------

include ports distribution

CLEAN_DIST_FILES
----------------

delete fetched .txz files
