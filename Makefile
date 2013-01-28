# variables user may defined
# ARCH	architecture for the target (amd64)
# RELEASE	FreeBSD release (9.1-RELEASE)
# WITH_SRC	include src distribution (undef)
# WITH_PORTS	include ports distribution (undef)
# CLEAN_DIST_FILES	clean fetched distfiles (undef)

ARCH?=	amd64
RELEASE?=	9.1-RELEASE
DIST_PROTO?=	ftp
DIST_HOST?=	ftp.jp.freebsd.org
DIST_PATH?=	pub/FreeBSD/releases/${ARCH}/${RELEASE}
DIST_FILES?=	base.txz doc.txz games.txz kernel.txz lib32.txz
PORTS_FILE?=	ports.txz
SRC_FILE?=	src.txz

FBSD_TAR_FILE?=	bsd-release.tbz
TMPROOT?=	tmproot

all:	${DIST_FILES} ${FBSD_TAR_FILE}

${FBSD_TAR_FILE}: ${TMPROOT}

.for F in ${DIST_FILES}
	tar -xp -C ${TMPROOT} -f ${F}
.endfor

.if defined(WITH_SRC)
	tar -xp -C ${TMPROOT} -f ${SRC_FILE}
.endif

.if defined(WITH_PORTS)
	tar -xp -C ${TMPROOT} -f ${PORTS_FILE} --exclude .svn
.endif

	tar -cpjf ${.TARGET} -C ${TMPROOT} .

${TMPROOT}:
	mkdir -p ${TMPROOT}

${DIST_FILES}:
# TODO support file://
	fetch ${DIST_PROTO}://${DIST_HOST}/${DIST_PATH}/${.TARGET}

clean:
.if defined(CLEAN_DIST_FILES)
	rm -f ${DIST_FILES}
.endif
	rm -rf ${TMPROOT}
	rm -f ${FBSD_TAR_FILE}
