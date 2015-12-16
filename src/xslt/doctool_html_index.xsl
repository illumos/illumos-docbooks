<?xml version="1.0" encoding="UTF-8" ?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY closest-id   '(ancestor-or-self::set
    |ancestor-or-self::book
    |ancestor-or-self::part
    |ancestor-or-self::reference
    |ancestor-or-self::partintro
    |ancestor-or-self::chapter
    |ancestor-or-self::appendix
    |ancestor-or-self::preface
    |ancestor-or-self::article
    |ancestor-or-self::section
    |ancestor-or-self::sect1
    |ancestor-or-self::sect2
    |ancestor-or-self::sect3
    |ancestor-or-self::sect4
    |ancestor-or-self::sect5
    |ancestor-or-self::refentry
    |ancestor-or-self::refsect1
    |ancestor-or-self::refsect2
    |ancestor-or-self::refsect3
    |ancestor-or-self::simplesect
    |ancestor-or-self::bibliography
    |ancestor-or-self::glossary
    |ancestor-or-self::variablelist
    |ancestor-or-self::varlistentry
    |ancestor-or-self::index
    |ancestor-or-self::webpage)[@xml:id][last()]/@xml:id'>

<!ENTITY closest-sect   '(ancestor-or-self::chapter
    |ancestor-or-self::sect1
    |ancestor-or-self::sect2
    |ancestor-or-self::sect3
    |ancestor-or-self::sect4
    |ancestor-or-self::sect5
    )[last()]'>

]>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<xsl:template name="generate-index">
	<ul class="idx"><xsl:call-template name="primary-level" /></ul>
</xsl:template>


<xsl:template name="primary-level">
	<xsl:for-each-group select="//indexterm" group-by="primary">
		<xsl:sort select="lower-case(current-grouping-key())" />
		<li>
			<xsl:apply-templates select="primary" />
			<xsl:for-each select="current-group()[not(secondary)]">
				<xsl:call-template name="index-reference" />
			</xsl:for-each>
			<ul><xsl:call-template name="secondary-level" /></ul>
		</li>
	</xsl:for-each-group>
</xsl:template>

<xsl:template name="secondary-level">
	<xsl:for-each-group select="current-group()" group-by="secondary">
		<xsl:sort select="lower-case(current-grouping-key())" />
		<li>
			<xsl:apply-templates select="secondary" />
			<xsl:for-each select="current-group()[not(tertiary)]">
				<xsl:call-template name="index-reference" />
			</xsl:for-each>
			<ul><xsl:call-template name="tertiary-level" /></ul>
		</li>
	</xsl:for-each-group>
</xsl:template>

<xsl:template name="tertiary-level">
	<xsl:for-each-group select="current-group()" group-by="tertiary">
		<xsl:sort select="lower-case(current-grouping-key())" />
		<li>
			<xsl:apply-templates select="tertiary" />
			<xsl:for-each select="current-group()">
				<xsl:call-template name="index-reference" />
			</xsl:for-each>
		</li>
	</xsl:for-each-group>
</xsl:template>

<xsl:template name="index-reference">
	<xsl:text>, </xsl:text>
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="id2href">
				<xsl:with-param name="RefID">
					<xsl:value-of select="&closest-id;" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:variable name="nearest" select="&closest-sect;" />
		<xsl:choose>
			<xsl:when test="$nearest and $nearest[ancestor-or-self::chapter]">
				<xsl:for-each select="$nearest">
					<xsl:call-template name="section-number" />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:number value="position()" format="i" />
			</xsl:otherwise>
		</xsl:choose>
	</a>
</xsl:template>

</xsl:stylesheet>
