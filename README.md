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

clean up. note that memory device used by WITH_MEMORY_DISK (see below) is not
destroyed. you must destroy it manually.

    # mdconfig -d -u ${ID)

variables
=========

ARCH
----

the target architecture

RELEASE
-------

the target release name

DIST_PROTO
----------

one of ftp, http, https and file (ftp). if DIST_PROTO is "file", DIST_HOST is
ignored.

DIST_HOST
---------

the host name of distfile server ("ftp.jp.freebsd.org")

DIST_PATH
---------

the path to the directory where all distribution files are located at
("pub/FreeBSD/releases/${ARCH}/${RELEASE}")

DIST_FILES
----------

a list of distribution files ("base.txz doc.txz games.txz kernel.txz
lib32.txz")


WITH_SRC
--------

include src distribution

WITH_PORTS
----------

include ports distribution

CLEAN_DIST_FILES
----------------

delete fetched .txz files

WITH_MEMORY_DISK
----------------

use memory disk when extracting distributions. the value is the path to memory
device created by the following command.

    # mdconfig -a -t malloc -s 2G
    md0
    # make WITH_MEMORY_DISK=/dev/md0

SEE ALSO
========

    mdconfig(8)
