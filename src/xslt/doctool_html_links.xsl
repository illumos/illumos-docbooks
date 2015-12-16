<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<xsl:template name="add-id">
	<xsl:if test="@xml:id">
		<xsl:attribute name="id">
			<xsl:value-of select="@xml:id" />
		</xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template name="title">
	<xsl:choose>
		<xsl:when test="self::info">Document Information</xsl:when>
		<xsl:when test="self::partintro">
			<!-- <partintro /> uses title from parent <part /> -->
			<xsl:for-each select="..">
				<xsl:call-template name="title" />
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="title"><xsl:apply-templates select="title" mode="print-title" /></xsl:when>
		<xsl:when test="info/title"><xsl:apply-templates select="info/title" mode="print-title" /></xsl:when>
		<xsl:otherwise><xsl:text>Untitled Chapter</xsl:text></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:variable name="chapters" select="//chapter" />
<xsl:template name="section-number">
	<xsl:variable name="type" select="local-name()" />
	<xsl:choose>
		<xsl:when test="$type = 'sect4'">
			<xsl:variable name="sect4s" select="../sect4" />
			<xsl:for-each select="..">
				<xsl:call-template name="section-number" />
			</xsl:for-each>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="index-of($sect4s, .)" />
		</xsl:when>
		<xsl:when test="$type = 'sect3'">
			<xsl:variable name="sect3s" select="../sect3" />
			<xsl:for-each select="..">
				<xsl:call-template name="section-number" />
			</xsl:for-each>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="index-of($sect3s, .)" />
		</xsl:when>
		<xsl:when test="$type = 'sect2'">
			<xsl:variable name="sect2s" select="../sect2" />
			<xsl:for-each select="..">
				<xsl:call-template name="section-number" />
			</xsl:for-each>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="index-of($sect2s, .)" />
		</xsl:when>
		<xsl:when test="$type = 'sect1'">
			<xsl:variable name="sect1s" select="../sect1" />
			<xsl:for-each select="..">
				<xsl:call-template name="section-number" />
			</xsl:for-each>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="index-of($sect1s, .)" />
		</xsl:when>
		<xsl:when test="$type = 'chapter'">
			<xsl:variable name="chapters" select="ancestor-or-self::book//chapter" />
			<xsl:value-of select="index-of($chapters, .)" />
		</xsl:when>
		<xsl:when test="$type = 'partintro'">
			<xsl:for-each select="..">
				<xsl:call-template name="section-number" />
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="$type = 'part'">
			<xsl:variable name="parts" select="../part" />
			<xsl:number value="index-of($parts, .)" format="I" />
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="linked-title">
	<xsl:param name="WithChapterNumber" select="false()" />
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="id2href">
				<xsl:with-param name="RefID">
					<xsl:value-of select="@xml:id" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:if test="$WithChapterNumber">
			<xsl:call-template name="section-number" />
			<xsl:text>. </xsl:text>
		</xsl:if>
		<xsl:call-template name="title" />
	</a>
</xsl:template>

<xsl:template name="id2href">
	<xsl:param name="RefID" />
	<xsl:for-each select="//*[@xml:id = $RefID]">
		<xsl:value-of select="ancestor-or-self::*[
		    self::chapter|
		    self::partintro|
		    self::preface|
		    self::info|
		    self::index|
		    self::glossary|
		    self::appendix]/@xml:id" />
		<xsl:text>.html#</xsl:text>
		<xsl:value-of select="$RefID" />
	</xsl:for-each>
</xsl:template>

<xsl:template name="mk-link">
	<xsl:param name="RefID" />
	<xsl:param name="link-text" />
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="id2href">
				<xsl:with-param name="RefID" select="$RefID" />
			</xsl:call-template>
		</xsl:attribute>
		<xsl:value-of select="$link-text" />
	</a>
</xsl:template>

<!-- External links -->
<xsl:template match="//link">
	<a href="{@xl:href}"><xsl:apply-templates /></a>
</xsl:template>

<!-- Cross references -->
<xsl:template match="//xref">
	<xsl:variable name="linkend" select="@linkend" />
	<xsl:variable name="endterm" select="@endterm" />
	<a><xsl:choose>
		<xsl:when test="@endterm and @linkend">
			<xsl:attribute name="href">
				<xsl:call-template name="id2href">
					<xsl:with-param name="RefID">
						<xsl:value-of select="$linkend" />
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="//*[@xml:id = $endterm]" />
		</xsl:when>
		<xsl:when test="@linkend">
			<xsl:attribute name="href">
				<xsl:call-template name="id2href">
					<xsl:with-param name="RefID">
						<xsl:value-of select="$linkend" />
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:for-each select="//*[@xml:id = $linkend]">
				<xsl:call-template name="title" />
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>BAD XREF</xsl:text>
		</xsl:otherwise>
	</xsl:choose></a>
</xsl:template>

<!-- Manual page references -->
<xsl:template match='manvolnum'>(<xsl:apply-templates />)</xsl:template>
<xsl:template match='refentrytitle'>
	<xsl:param name="no-tags" tunnel="yes" />
	<xsl:choose>
		<xsl:when test="$no-tags">
			<xsl:apply-templates />
		</xsl:when>
		<xsl:otherwise>
			<span class="refentrytitle"><xsl:apply-templates /></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="citerefentry" mode="print-title">
	<xsl:param name="no-tags" tunnel="yes" />
	<xsl:choose>
		<xsl:when test="$no-tags">
			<xsl:apply-templates />
		</xsl:when>
		<xsl:otherwise>
			<span class="manual-reference">
				<xsl:apply-templates />
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="citerefentry">
	<xsl:variable name="volume" select="manvolnum" />
	<xsl:variable name="page" select="refentrytitle" />
	<a href="https://illumos.org/man/{$volume}/{$page}"
		class="manual-reference">
		<xsl:apply-templates />
	</a>
</xsl:template>


</xsl:stylesheet>
