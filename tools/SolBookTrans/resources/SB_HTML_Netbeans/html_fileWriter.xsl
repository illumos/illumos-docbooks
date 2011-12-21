<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : html_fileWriter.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Allows result trees to be saved as separate files. Requires the use 
        of either the Saxon or Xalan processors. Maybe I'll add more later.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:redirect="http://xml.apache.org/xalan/redirect"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="redirect saxon"
                version="1.0">
                    
                    
    <xsl:template name="writeFile">
        <xsl:param name="saveFilePath" />
        <xsl:param name="resultContent"/>
        <xsl:choose>
            <xsl:when test="element-available('redirect:write')">
                <redirect:write file="{$saveFilePath}">
                    <xsl:copy-of select="$resultContent" />
                </redirect:write>
                <xsl:message>Saved file <xsl:value-of select="$saveFilePath" /> using Xalan</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="element-available('saxon:output')">
                        <saxon:output href="{$saveFilePath}">
                            <xsl:copy-of select="$resultContent" />
                        </saxon:output>
                        <xsl:message>Saved file <xsl:value-of select="$saveFilePath" /> using Saxon</xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>ERROR cannot save files because the XSLT processor is not Saxon or Xalan.</xsl:message>
                        <xsl:message>XSL version: <xsl:value-of select="system-property('xsl:version')" /></xsl:message>
                        <xsl:message>XSL vendor: <xsl:value-of select="system-property('xsl:vendor-url')" /></xsl:message>
                        <xsl:message terminate="yes">XSL processor: <xsl:value-of select="system-property('xsl:vendor')" /></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
                    
    
   
 
     
</xsl:stylesheet>
