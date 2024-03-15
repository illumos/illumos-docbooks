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
# Copyright 2019, Joyent, Inc.
# Copyright 2024 Oxide Computer Company
#

BOOKS =			$(BOOKS_WITH_PDF) $(BOOKS_HTML_ONLY)
BOOKS_WITH_PDF =	lgrps dtrace mdb zfs-admin wdd
#
# We are having some temporary issues building the PDF for these books:
#
BOOKS_HTML_ONLY =	smb-admin
PDF_TYPES =		print ebook

BUILD_FILES =		$(shell find src/xslt src/dblatex -type f)

#
# For each book, generate the list of input files in a variable based on the
# book name; e.g., $(FILES_dtrace).
#
$(foreach b,$(BOOKS), \
    $(eval FILES_$(b) = $$(shell find raw/$(b)/ -name \*.xml -o -name \*.eps)))

DBLATEX =		dblatex
DBLATEX_OPTS =		-p src/dblatex/params.xsl
DBLATEX_OPTS_print =	-P latex.page.size=letter
DBLATEX_OPTS_ebook =	-P latex.page.size=ebook

MOGRIFY =		mogrify
MOGRIFY_OPTS =		-density 150 -format png

OUTDIR =		build

TARGETS_HTML =		$(foreach b,$(BOOKS), \
			    $(OUTDIR)/$(b)/index.html)
TARGETS_PDF =		$(foreach b,$(BOOKS_WITH_PDF), \
			    $(foreach t,$(PDF_TYPES), \
			    $(OUTDIR)/$(b)/$(b)-$(t).pdf))

.PHONY: all
all: $(TARGETS_HTML) $(TARGETS_PDF) $(OUTDIR)/index.html

.PHONY: html
html: $(TARGETS_HTML)

.PHONY: pdf
pdf: $(TARGETS_PDF)

$(OUTDIR)/index.html:
	rm -f $@
	cp index.html $@

$(OUTDIR)/%/index.html:
	rm -rf $(OUTDIR)/$*
	mkdir -p $(OUTDIR)/$*
	mvn -Dtarget.outdir=$(OUTDIR) -Dtarget.book=$* xml:transform
	cp src/xslt/style.css $(OUTDIR)/$*
	mkdir $(OUTDIR)/$*/figures; \
	cp src/xslt/phoenix.svg $(OUTDIR)/$*/figures
	if [[ -d raw/$*/figures ]]; then \
		$(MOGRIFY) $(MOGRIFY_OPTS) -path $(OUTDIR)/$*/figures \
		    raw/$*/figures/*.eps; \
	fi

#
# pdf_template(book, pdf_type): emits a rule and recipe to generate the
# selected book (e.g., "lgrps") PDF of the selected type (e.g., "print").
#
define pdf_template
$$(OUTDIR)/$(1)/$(1)-$(2).pdf: raw/$(1)/$(1).book $$(FILES_$(1)) \
    $$(BUILD_FILES) | $$(OUTDIR)/$(1)/index.html
	$$(DBLATEX) $$(DBLATEX_OPTS) $$(DBLATEX_OPTS_$(2)) -o $$@ $$<
endef

#
# Construct a target for each of the cartesian product of all books and types:
#
$(foreach b,$(BOOKS_WITH_PDF), \
    $(foreach t,$(PDF_TYPES), \
    $(eval $(call pdf_template,$(b),$(t)))))

clean:
	rm -rf $(OUTDIR)/

check:
	mvn exec:java
