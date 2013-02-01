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

create ${ARCH}-fbsd-release.tbz for $ARCH

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

a list of distribution files ("base.txz doc.txz games.txz kernel.txz" and
lib32.txz if ARCH=amd64)


WITH_SRC
--------

include src distribution

WITH_PORTS
----------

include ports distribution

CLEAN_DIST_FILES
----------------

delete fetched .txz files

EXAMPLES
========

in most cases, all you need is:

    # make all ARCH=i386

use distribution files on local disk

    # make DIST_PROTO=file DIST_PATH=../../../tmp/distfiles

