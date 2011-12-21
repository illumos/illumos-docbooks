<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_page_template_netbeans.xsl
    Created on : June 13, 2008
    Author     : Mark Brundege
    Description: The HTML template for generating the previous and next links for SolBook in NetBeans style.
        This should be provided with the context node for the page for the links. Should be chapter or equivalent.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
           
<!-- generates a file name for the given node param, which should be a child of the book node -->
<xsl:template name="generateFileName">
    <xsl:param name="myName" />
    <xsl:param name="myPosition" />
    <xsl:choose>
        <xsl:when test="$myName = 'bookinfo'">
            <xsl:text>docinfo.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>p</xsl:text>
            <xsl:number value="$myPosition + 1" />
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
            <xsl:variable name="prevNode" select="preceding-sibling::*[1]" />
            <xsl:call-template name="generateFileName">
                <xsl:with-param name="myName" select="local-name($prevNode)" />
                <xsl:with-param name="myPosition" select="position() - 1" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="findNextFileName">
    <xsl:choose>
        <xsl:when test="position() = last()">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="nextNode" select="following-sibling::*[1]" />
            <xsl:call-template name="generateFileName">
                <xsl:with-param name="myName" select="local-name($nextNode)" />
                <xsl:with-param name="myPosition" select="position() + 1" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
    
    
</xsl:stylesheet> 
    
    
    
    