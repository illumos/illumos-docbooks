<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbookToHTML_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML inline elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:template match="//olink">
        <xsl:variable name="linkid" select="@targetptr" />
        <!-- note that the file name determination is output dependent, see findFileWithID template below -->
        <xsl:variable name="linkDocFile">
            <xsl:call-template name="findFileWithID">
                <xsl:with-param name="IDtoFind" select="$linkid" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string($linkDocFile) and @remap = 'internal'">
                <a href="{$linkDocFile}#{@targetptr}"><xsl:apply-templates /></a>
            </xsl:when>
            <!-- if its not internal or no ID could be found, then just remove link because there is no way to know where other docs will be -->
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
     
    
    
    
    <!-- THIS IS OUTPUT FORMAT DEPENDENT: Need to figure out which file the linked to ID is in -->
    <!-- Right now, this assumes that each book child will have its own page, named as per solbook_navlink_template_indiana.xsl -->
    <!-- note that this will generate bad results if there is more than 1 ID of the same value indicated, but that should not happen -->
    <xsl:template name="findFileWithID">
        <xsl:param name="IDtoFind" />
        <xsl:for-each select="/book/*">
            <xsl:variable name="currFileName">
                <xsl:call-template name="generateFileName">
                    <xsl:with-param name="myName" select="local-name()" />
                    <xsl:with-param name="myPosition" select="position()" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test=".//@id = $IDtoFind">
                <xsl:value-of select="$currFileName" />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="//ulink">
        <a href="{@url}" target="_blank"><xsl:apply-templates /></a>
    </xsl:template>
        
        
    
</xsl:stylesheet>
