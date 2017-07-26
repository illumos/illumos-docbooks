<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

	<xsl:param name="latex.page.size">ebook</xsl:param>

	<xsl:param name="latex.style">../../src/dblatex/illumos</xsl:param>

	<xsl:param name="latex.class.book">memoir</xsl:param>
	<xsl:param name="latex.class.article">memoir</xsl:param>

	<xsl:param name="latex.encoding">utf8</xsl:param>
	<xsl:param name="latex.output.revhistory">0</xsl:param>
	<xsl:param name="doc.collab.show">0</xsl:param>
	<xsl:param name="variablelist.term.separator">\newline </xsl:param>

	<!-- We have some long tables, so make sure we use the longtable
	     environment so that they'll get split across pages correctly -->
	<xsl:param name="table.in.float">0</xsl:param>

	<xsl:param name="latex.class.options">
		<xsl:choose>
			<xsl:when test="$latex.page.size = 'ebook'">11pt,final,oldfontcommands</xsl:when>
			<xsl:otherwise>11pt,twoside,final,openright,oldfontcommands</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:template match="abstract" />

	<xsl:template match="phrase[@role = 'first-word']">
		<xsl:text>\textsc{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="option">
		<xsl:text>\texttt{-</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<!-- Correction for test for xetex which is provided by memoir and
	     inclusion of custom coverpage (maketitle must be redefined before
	     standard preamble templates kick in) -->
	<xsl:template name="encode.before.style">
		<xsl:param name="lang"/>
		<xsl:variable name="use-unicode">
			<xsl:call-template name="lang-in-unicode">
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- XeTeX preamble to handle fonts -->
		<xsl:text>\ifxetex&#10;</xsl:text>
		<xsl:text>\usepackage{fontspec}&#10;</xsl:text>
		<xsl:text>\usepackage{xltxtra}&#10;</xsl:text>
		<xsl:value-of select="$xetex.font"/>
		<xsl:text>\else&#10;</xsl:text>

		<!-- Standard latex font setup -->
		<xsl:choose>
			<xsl:when test="$use-unicode='1'"/>
			<xsl:when test="$latex.encoding='latin1'">
				<xsl:text>\usepackage[T1]{fontenc}&#10;</xsl:text>
				<xsl:text>\usepackage[latin1]{inputenc}&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="$latex.encoding='utf8'">
				<xsl:text>\usepackage[T2A,T2D,T1]{fontenc}&#10;</xsl:text>
				<xsl:text>\usepackage{ucs}&#10;</xsl:text>
				<xsl:text>\usepackage[utf8x]{inputenc}&#10;</xsl:text>
				<xsl:text>\def\hyperparamadd{unicode=true}&#10;</xsl:text>
				<xsl:text>\usepackage{lmodern}&#10;</xsl:text>

				<!-- Style the page headers/footers -->
				<xsl:text>\pagestyle{ruled}&#10;</xsl:text>
				<xsl:choose>
					<xsl:when test="$latex.page.size = 'ebook'">
						<!-- Override 'ruled' page numbers for ebooks
						     so that everything is in the middle -->
						<xsl:text>\makeevenfoot{ruled}{}{\thepage}{}&#10;</xsl:text>
						<xsl:text>\makeoddfoot{ruled}{}{\thepage}{}&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- Override 'plain' page numbers when printing
						     so that everything is on the outside -->
						<xsl:text>\makeevenfoot{plain}{\thepage}{}{}&#10;</xsl:text>
						<xsl:text>\makeoddfoot{plain}{}{}{\thepage}&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

				<!--
					These all create a type block that is 5.819in wide, which
					is small enough to not make the paragraph text too wide,
					but big enough for the code examples.
				-->
				<xsl:choose>
					<xsl:when test="$latex.page.size = 'quarto'">
						<!-- Crown Quarto (paperback) -->
						<xsl:text>\setstocksize{9.681in}{7.444in}&#10;</xsl:text>
						<xsl:text>\settrimmedsize{9.681in}{7.444in}{*}&#10;</xsl:text>
						<xsl:text>\setlrmarginsandblock{1in}{0.625in}{*}&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="$latex.page.size = 'letter-hardcover'">
						<!-- US Letter (hardcover) -->
						<xsl:text>\setstocksize{10.75in}{8.25in}&#10;</xsl:text>
						<xsl:text>\settrimmedsize{10.75in}{8.25in}{*}&#10;</xsl:text>
						<xsl:text>\setlrmarginsandblock{1.431in}{1in}{*}&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="$latex.page.size = 'letter'">
						<!-- US Letter (actual) -->
						<xsl:text>\setstocksize{11in}{8.5in}&#10;</xsl:text>
						<xsl:text>\settrimmedsize{11in}{8.5in}{*}&#10;</xsl:text>
						<xsl:text>\setlrmarginsandblock{1.181in}{1in}{*}&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="$latex.page.size = 'ebook'">
						<!-- US Letter (actual), but with equal margins -->
						<xsl:text>\setstocksize{11in}{8.5in}&#10;</xsl:text>
						<xsl:text>\settrimmedsize{11in}{8.5in}{*}&#10;</xsl:text>
						<xsl:text>\setlrmarginsandblock{1.0905in}{1.0905in}{*}&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">Unrecognized page size</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Make the bottom margin 25% taller than the top -->
				<xsl:text>\setulmarginsandblock{0.8in}{1in}{*}&#10;</xsl:text>
				<xsl:text>\checkandfixthelayout&#10;</xsl:text>
				<xsl:text>\def\lstparamset{%
\lstset{%
	basicstyle=\ttfamily\footnotesize, %
	identifierstyle=\color{colIdentifier}, %
	keywordstyle=\color{colKeys}, %
	stringstyle=\color{colString}, %
	commentstyle=\color{colComments}, %
	literate={&#239;}{{\"i}}1 {&#191;}{{?`}}1 {&#189;}{{$\frac{1}{2}$}}1, %
	tabsize=4, %
	frame=single, %
	framerule=0pt, %
	extendedchars=true, %
	showspaces=false, %
	showlines=true, %
	showstringspaces=false, %
	numberstyle=\tiny, %
	breaklines=false, %
	prebreak={\space\wrapsign}, %
	breakautoindent=true, %
	captionpos=b%
}
}</xsl:text>
			</xsl:when>
		</xsl:choose>

		<xsl:text>\fi&#10;</xsl:text>
	</xsl:template>

	<!-- Docbook's formalpara - dblatex's version fixed for memoir -->
	<xsl:template match="formalpara">
		<xsl:text>&#10;\textbf{ </xsl:text>
		<xsl:call-template name="normalize-scape">
			<xsl:with-param name="string" select="title"/>
		</xsl:call-template>
		<xsl:text>} </xsl:text>
		<xsl:call-template name="label.id"/>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="formalpara/title"></xsl:template>


</xsl:stylesheet>
