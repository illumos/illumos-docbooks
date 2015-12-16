<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<xsl:template match="address">
	<xsl:value-of select="street" /><br />
	<xsl:value-of select="city" />, <xsl:value-of select="state" />
	<xsl:value-of select="postcode" /><br />
	<xsl:value-of select="country" />
</xsl:template>

<xsl:template match="publisher">
	<p>
		<xsl:value-of select="publishername" /><br />
		<xsl:apply-templates select="address" />
	</p>
</xsl:template>

</xsl:stylesheet>
