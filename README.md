# illumos docbooks

This repository contains the original docbooks from Sun's last drop and
contains the process of converting them to a format that will work well
for illumos. Currently only a subset of the docbooks that once existed
are here. Others will be added once someone cares enough about them and
we make the process for working on them not quite so terrible.

To build them into something useful, you will need to install:

- GNU make (`gmake` in pkgsrc)
- Maven (`apache-maven` in pkgsrc)
- dblatex (`dblatex` in pkgsrc)
- epstopdf conversion tool (`tex-epstopdf` in pkgsrc)
- texlive packages (`texlive-collection-fontsrecommended`,
  `texlive-collection-latexrecommended`,
  `texlive-collection-latexextra` in pkgsrc)
- cyrillic fonts (`tex-cyrillic` in pkgsrc)

For example, in a SmartOS zone:

```
pkgin install \
    gmake apache-maven dblatex tex-epstopdf tex-cyrillic \
    texlive-collection-fontsrecommended \
    texlive-collection-latexrecommended \
    texlive-collection-latexextra
```

The build tools are based on the old Solbook build tools, which were
licensed under a combo GPL/CDDL.

## Building

The quick and easy way to build everything is to run:

```
make all
```

If you're on a system that doesn't have LaTeX packages available, you can
build just the HTML files with:

```
make html
```

## Repository Layout

- `raw/`

  The currently maintained and updated docbooks. Each book is in its own
  top level directory.

- `src/`

  The source files for generating websites and PDFs from the DocBook
  sources.

- `stage/`

  Original docbooks from Sun that have not been updated.

## Adding New Books

As a part of adding a new book, it should be moved from `stage/` to `raw/`.
Also, when you move it, please change the name to something that is a bit more
obvious.  `dtrace` is much better than `DYNMCTRCGGD`, and `mdb` than
`MODDEBUG`. Once it is there, you must do the following things:

-  Add a license appendix that clearly states that this is under the
   PDL. Look at what the mdb or DTrace guides do.

-  Move all of the gif figures in `figures/GenHTML-CachedGraphics/` to
   `figures/`. This will not be necessary at the time that issue #39 is
   completed. Until such a mystical time.

-  Comment out the index section until such time as bug #4 has been
   resolved.

-  Before you are done, add it as a check target in the Makefile.

And convert the sources from SolBook to Docbook 5:

-  Remove `<highlights>` tags, but leave their inner content
-  Convert all `id`'s to `xml:id`'s
-  Convert `<olink>` tags where `remap="internal"` to `<xref>` tags
-  Remove the `<olink>` tags around `<citerefentry>` tags
-  Convert `<ulink>` tags to `<link>` tags
-  Convert `<chapterinfo>` and `<bookinfo>` to just `<info>`
-  Add a `<bibliorelation>` tag that can be used when creating canonical links
-  Move `<option>` tags out of `<command>` tags/restructure
-  Along the way, as lines are touched, try to reformat
-  Assign `<partintro>` tags IDs, and update any references to the parent
   `<part>` to point at the `<partintro>` instead.
-  There are some other minor things that were not specific to SolBook, but
   were part of DocBook 4 and are gone in DocBook 5. Running the validator
   will find them for you. Consult the DocBook guide for tips on what to do:

   http://www.docbook.org/tdg5/en/html/ch01.html#introduction-whats-new


This should be enough to get the HTML5 version of the book built. To build the
PDFs though, there are some other things that need to be fixed:

-  Convert all colspecs' colwidth attributes from inches to proportional
   measurements. For example, if there are two columns of widths `"1.00in"`
   and `"4.00in"`, they should become `"1*"` and `"4*"` respectively, which
   says that the second column should be four times the width of the first
   column. If there are multiple tables next to each that are similar in
   number of columns and width, try to make them the same, so that they look
   better in the PDF.
-  On `<colspec>` tags for columns that contain paragraphs, add an
   `align="justify"` attribute.
-  On `<tbody>` tags for tables that contain multi-line text, add
   `valign="top"` to ensure that things don't get vertically center-aligned,
   which can make reading the table more confusing.
-  Make sure that the text inside `<programlisting>` and `<screen>` tags wrap
   before 75 characters since monospaced text will be wider in the PDF, and
   the only two options are the listings environment's poor wrapping with
   breaklines, or overflowing into (or past) the margins.
-  Check for long `<example>` contents, which get placed inside a float and
   will therefore overflow the bottom margin if too long.

Additional cleanup worth performing:

-  Remove the processing instructions (things like `<?PubTbl ...?>`) left over
   from the XML editors initially used to write the books (they don't get
   used for anything).

Adding the document to the check target should help you track many of these
issues down.

## Contributing

Treat this like you would illumos-gate with respect to bugs and the like.
Currently the minor bug tracker is based on the github repository.  Before you
put back, you should run `make check`. Furthermore, if you change the xslt
style, you must check most of the docbooks for regressions.

You can check your DocBook changes by running:

```
make check
```

## License

All of the documentation is licensed under the Public Documentation
License. See DOCLICENSE for details.
