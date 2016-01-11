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
# Copyright (c) 2012, Joyent, Inc.
#

LINT=xmllint
DTD=tools/SolBookTrans/resources 

check:
	$(LINT) --valid --noout --path $(DTD) raw/dtrace/DYNMCTRCGGD.book	
	$(LINT) --valid --noout --path $(DTD) raw/mdb/MODDEBUG.book	
	$(LINT) --valid --noout --path $(DTD) raw/wdd/DRIVER.book
	$(LINT) --valid --noout --path $(DTD) raw/lgrps/MTPODG.book
	$(LINT) --valid --noout --path $(DTD) raw/zfsadmin/ZFSADMIN.book
