#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2016, Joyent, Inc.
#

BUILD_FILES=$(shell find src/xslt src/dblatex)
WDD_FILES=$(shell find raw/wdd/ -name \*.xml -o -name \*.eps)
ZFS_FILES=$(shell find raw/zfs-admin/ -name \*.xml)
MDB_FILES=$(shell find raw/mdb/ -name \*.xml -o -name \*.eps)
DTRACE_FILES=$(shell find raw/dtrace/ -name \*.xml -o -name \*.eps)
LGRPS_FILES=$(shell find raw/lgrps/ -name \*.xml -o -name \*.eps)

DBLATEX=dblatex
DBLATEX_OPTS=-p src/dblatex/params.xsl
DBLATEX_PRINT_OPTS=${DBLATEX_OPTS} -P latex.page.size=letter
DBLATEX_EBOOK_OPTS=${DBLATEX_OPTS} -P latex.page.size=ebook

MOGRIFY=mogrify
MOGRIFY_OPTS=-density 150 -format png

.PHONY:
all: build/lgrps build/zfs-admin build/wdd build/dtrace build/mdb

.PHONY:
html: build/lgrps/index.html build/zfs-admin/index.html build/wdd/index.html \
	build/dtrace/index.html build/mdb/index.html

build/%/index.html:
	rm -rf build/$*
	mvn -q -Dtarget.book=$* xml:transform
	cp src/xslt/style.css build/$*
	mkdir build/$*/figures; \
	cp src/xslt/phoenix.svg build/$*/figures
	if [[ -d raw/$*/figures ]]; then \
		${MOGRIFY} ${MOGRIFY_OPTS} -path build/$*/figures raw/$*/figures/*.eps; \
	fi

build/lgrps: ${LGRPS_FILES} ${BUILD_FILES} | build/lgrps/index.html
	${DBLATEX} ${DBLATEX_PRINT_OPTS} -o build/lgrps/lgrps-print.pdf raw/lgrps/MTPODG.book
	${DBLATEX} ${DBLATEX_EBOOK_OPTS} -o build/lgrps/lgrps-ebook.pdf raw/lgrps/MTPODG.book

build/zfs-admin: ${ZFS_FILES} ${BUILD_FILES} | build/zfs-admin/index.html
	${DBLATEX} ${DBLATEX_PRINT_OPTS} -o build/zfs-admin/zfs-admin-print.pdf raw/zfs-admin/ZFSADMIN.book
	${DBLATEX} ${DBLATEX_EBOOK_OPTS} -o build/zfs-admin/zfs-admin-ebook.pdf raw/zfs-admin/ZFSADMIN.book

build/wdd: ${WDD_FILES} ${BUILD_FILES} | build/wdd/index.html
	${DBLATEX} ${DBLATEX_PRINT_OPTS} -o build/wdd/wdd-print.pdf raw/wdd/DRIVER.book
	${DBLATEX} ${DBLATEX_EBOOK_OPTS} -o build/wdd/wdd-ebook.pdf raw/wdd/DRIVER.book

build/dtrace: ${DTRACE_FILES} ${BUILD_FILES} | build/dtrace/index.html
	${DBLATEX} ${DBLATEX_PRINT_OPTS} -o build/dtrace/dtrace-print.pdf raw/dtrace/DYNMCTRCGGD.book
	${DBLATEX} ${DBLATEX_EBOOK_OPTS} -o build/dtrace/dtrace-ebook.pdf raw/dtrace/DYNMCTRCGGD.book

build/mdb: ${MDB_FILES} ${BUILD_FILES} | build/mdb/index.html
	${DBLATEX} ${DBLATEX_PRINT_OPTS} -o build/mdb/mdb-print.pdf raw/mdb/MODDEBUG.book
	${DBLATEX} ${DBLATEX_EBOOK_OPTS} -o build/mdb/mdb-ebook.pdf raw/mdb/MODDEBUG.book

clean:
	rm -rf build/

check:
	mvn exec:java
