<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<!-- generates a file name for the given node -->
<xsl:template name="generateFileName">
	<xsl:variable name="elementNum">
		<xsl:number level="any" />
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="local-name() = 'subtitle'">
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="local-name() = 'part'">
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="local-name() = 'title'">
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="local-name() = 'partintro'">
			<xsl:text>partintro-</xsl:text>
			<xsl:value-of select="$elementNum" />
			<xsl:text>.html</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@xml:id" />
			<xsl:text>.html</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="findPreviousFileName">
	<xsl:choose>
		<xsl:when test="position() = 1">
			<xsl:text></xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="preceding-sibling::*[1]">
				<xsl:call-template name="generateFileName" />
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="findNextFileName">
	<xsl:choose>
		<xsl:when test="position() = last()">
			<xsl:text></xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="following-sibling::*[1]">
				<xsl:call-template name="generateFileName" />
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
