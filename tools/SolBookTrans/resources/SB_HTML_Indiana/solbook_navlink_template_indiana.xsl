<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_page_template_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description: The HTML template for generating the previous and next links for SolBook in project indiana style.
        This should be provided with the context node for the page for the links. Should be chapter or equivalent.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
           
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
        <xsl:when test="$elementNum = 1">
            <xsl:text><xsl:value-of select="local-name()" /></xsl:text>
            <xsl:text>.html</xsl:text>
        </xsl:when>
	<xsl:when test="local-name() = 'preface'">
            <xsl:text><xsl:value-of select="local-name()" /></xsl:text>
            <xsl:text>.html</xsl:text>
	</xsl:when>
        <xsl:otherwise>
            <xsl:text><xsl:value-of select="local-name()" /></xsl:text>
            <xsl:text><xsl:value-of select="$elementNum" /></xsl:text>
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
    
    
    
    
