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

FBSD_TAR_FILE?=	fbsd-release.tbz
TMPROOT?=	tmproot

all:	${DIST_FILES} ${FBSD_TAR_FILE} patch

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

# TODO bsdiff support
patch:
	# NOOP

${TMPROOT}:
	mkdir -p ${TMPROOT}
.if defined(WITH_MEMORY_DISK)
	newfs ${WITH_MEMORY_DISK}
	mount -o async,noatime ${WITH_MEMORY_DISK} ${TMPROOT}
.endif


${DIST_FILES}:
.if ${DIST_PROTO} == "file"
	cp ${DIST_PATH}/${.TARGET} .
.elif ${DIST_PROTO} == "ftp" || ${DIST_PROTO} == "http" || ${DIST_PROTO} == "https"
	fetch ${DIST_PROTO}://${DIST_HOST}/${DIST_PATH}/${.TARGET}
.else
	echo "unsupported DIST_PROTO, ${DIST_PROTO}. use either file, ftp or http"
	exit 1
.endif

clean:
.if defined(WITH_MEMORY_DISK)
	umount ${WITH_MEMORY_DISK}
.endif
	find tmproot -flags schg -exec chflags noschg {} \;
	rm -rf ${TMPROOT}
.if defined(CLEAN_DIST_FILES)
	rm -f ${DIST_FILES}
.endif
	rm -f ${FBSD_TAR_FILE}
