<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<xsl:template match="mediaobject">
	<xsl:variable name="img-href" select="imageobject/imagedata/@fileref" />
	<xsl:variable name="alt-text" select="textobject/simpara/text()" />
	<img src="{$img-href}.png" alt="{$alt-text}" />
</xsl:template>

<xsl:template match="example|figure">
	<figure>
		<xsl:call-template name="add-id" />
		<xsl:apply-templates />
		<xsl:if test="title">
			<figcaption>
				<xsl:call-template name="title" />
			</figcaption>
		</xsl:if>
	</figure>
</xsl:template>

<xsl:template match="//table | //informaltable">
	<!-- determine border for table: either 0 or 1 -->
	<xsl:variable name="tableBorder">
		<xsl:choose>
			<xsl:when test="@frame = 'top' or @frame = 'bottom'  or @frame = 'topbot' or @frame = 'all' or @frame = 'sides' ">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- make main table and rows, call entry template for cells -->
	<table border="{$tableBorder}" cellspacing="2" cellpadding="8">
		<!-- id and title are not present in informaltables -->
		<xsl:call-template name="add-id" />
		<xsl:if test="title">
			<caption>
				<xsl:call-template name="title" />
			</caption>
		</xsl:if>
		<xsl:for-each select=".//row">
			<tr>
				<xsl:apply-templates select="entry" />
			</tr>
		</xsl:for-each>
	</table>
</xsl:template>

<xsl:template match="entry">
	<xsl:variable name="cell-align" select="@align" />
	<xsl:variable name="cell-valign" select="@valign" />
	<xsl:variable name="style-text">
		<xsl:if test="@align">
			<xsl:value-of select="'align: ${cell-align};'" />
		</xsl:if>
		<xsl:if test="@valign">
			<xsl:value-of select="'vertical-align: ${cell-valign};'" />
		</xsl:if>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="ancestor::thead">
			<th>
				<xsl:attribute name="style">
					<xsl:value-of select="$style-text" />
				</xsl:attribute>
				<xsl:apply-templates />
			</th>
		</xsl:when>
		<xsl:otherwise>
			<td>
				<xsl:attribute name="style">
					<xsl:value-of select="$style-text" />
				</xsl:attribute>
				<xsl:apply-templates />
			</td>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
