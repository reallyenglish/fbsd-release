# variables user may defined
# ARCH	architecture for the target (amd64)
# RELEASE	FreeBSD release (9.1-RELEASE)
# WITH_SRC	include src distribution (undef)
# WITH_PORTS	include ports distribution (undef)
# CLEAN_DIST_FILES	clean fetched distfiles (undef)

ARCH?=	amd64
RELEASE?=	9.1-RELEASE
DIST_DIR?=	distfiles/${ARCH}
DIST_PROTO?=	ftp
DIST_HOST?=	ftp.jp.freebsd.org
DIST_PATH?=	pub/FreeBSD/releases/${ARCH}/${RELEASE}
DIST_FILES?=	base.txz doc.txz games.txz kernel.txz
.if ${ARCH} == "amd64"
DIST_FILES+=	lib32.txz
.endif
PORTS_FILE?=	ports.txz
SRC_FILE?=	src.txz

FBSD_TAR_FILE?=	${ARCH}-fbsd-release.tbz
TMPROOT?=	tmproot

all:	${DIST_FILES} ${FBSD_TAR_FILE} patch

${FBSD_TAR_FILE}: ${TMPROOT}

.for F in ${DIST_FILES}
	tar -xp -C ${TMPROOT} -f ${DIST_DIR}/${F}
.endfor

.if defined(WITH_SRC)
	tar -xp -C ${TMPROOT} -f ${DIST_DIR}/${SRC_FILE}
.endif

.if defined(WITH_PORTS)
	tar -xp -C ${TMPROOT} -f ${DIST_DIR}/${PORTS_FILE} --exclude .svn
.endif

	tar -cpjf ${.TARGET} -C ${TMPROOT} .

# TODO bsdiff support
patch:
	# NOOP

${TMPROOT}!
	mkdir -p ${TMPROOT}
	umount `realpath tmproot` || true
	mount -t tmpfs tmpfs ${TMPROOT}

${DIST_DIR}:
	mkdir -p ${DIST_DIR}

${DIST_FILES}:	${DIST_DIR}
.if ${DIST_PROTO} == "file"
	cp ${DIST_PATH}/${.TARGET} ${DIST_DIR}/
.elif ${DIST_PROTO} == "ftp" || ${DIST_PROTO} == "http" || ${DIST_PROTO} == "https"
	fetch -m -o ${DIST_DIR} ${DIST_PROTO}://${DIST_HOST}/${DIST_PATH}/${.TARGET}
.else
	echo "unsupported DIST_PROTO, ${DIST_PROTO}. use either file, ftp or http"
	exit 1
.endif

clean:
	umount `realpath ${TMPROOT}` || true

.if defined(CLEAN_DIST_FILES)
	rm -f ${DIST_DIR}/${DIST_FILES}
.endif
	rm -f ${FBSD_TAR_FILE}
