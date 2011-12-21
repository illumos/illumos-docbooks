<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_info.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML info elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:template name="infotemplate">
        <xsl:param name="infoNode" />
        <xsl:param name="includeLegal" />
        <a name="documentinfo"></a>
        <p>
            <xsl:call-template name="localizer">
                <xsl:with-param name="wordName">part_number</xsl:with-param>
                <xsl:with-param name="languageCode" select="$langCode" />
           </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$infoNode/pubsnumber" />
            
        </p>
        <p><xsl:value-of select="$infoNode/pubdate" /></p>
        <p><xsl:value-of select="$infoNode/publisher/address/street" /><br/>
        <xsl:value-of select="$infoNode/publisher/address/city" />,<xsl:text> </xsl:text>
        <xsl:value-of select="$infoNode/publisher/address/state" /><xsl:text> </xsl:text>
        <xsl:value-of select="$infoNode/publisher/address/postcode" /><br/>
        <xsl:value-of select="$infoNode/publisher/address/country" /></p>
        <xsl:apply-templates select="$infoNode/abstract" />
        <xsl:if test="string($includeLegal)">
            <xsl:apply-templates select="$infoNode/legalnotice" />
        </xsl:if>
    </xsl:template>
    
 
     
</xsl:stylesheet>


