<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">

<xsl:template match="note|tip|important|caution|warning">
	<xsl:variable name="type" select="local-name()" />
	<xsl:variable name="label"
	    select="concat(upper-case(substring($type, 1, 1)),
	    substring($type, 2))" />

	<aside class="admonition {$type}">
		<div class="admonition-title">
			<xsl:choose>
				<xsl:when test="title">
					<xsl:apply-templates select="title/node()" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$label" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="admonition-body">
			<xsl:apply-templates select="node()[not(self::title)]" />
		</div>
	</aside>
</xsl:template>

</xsl:stylesheet>
