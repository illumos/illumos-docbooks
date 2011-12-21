<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_toc_template_netbeans.xsl
    Created on : June 13, 2008
    Author     : Mark Brundege
    Description: The HTML template for generating the page-specific TOC for SolBook in NetBeans style.
        This should be provided with the context node for the page. Should be chapter or equivalent.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
<xsl:include href="solbook_navlink_template_netbeans.xsl" />
           
<!-- generates a file name for the given context node, which should be a child of the book node -->
<xsl:template name="generatePageToc">
    <xsl:for-each select="/book/*">
        <xsl:variable name="currFileName">
            <xsl:call-template name="generateFileName">
                <xsl:with-param name="myName" select="local-name()" />
                <xsl:with-param name="myPosition" select="position()" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="currTitle">
            <xsl:choose>
                <xsl:when test="local-name() = 'chapter'">
                    <xsl:number count="chapter" />
                    <xsl:text>.&#32;&#32;</xsl:text>
                    <xsl:value-of select="title" />
                </xsl:when>
                <xsl:when test="local-name() = 'title'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">title_page</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="local-name() = 'bookinfo'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">document_information</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="local-name() = 'preface'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">preface</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="local-name() = 'appendix'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">appendix</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                    <xsl:number count="appendix" />
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="title" />
                </xsl:when>
                <xsl:when test="local-name() = 'reference'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">reference</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:number count="reference" />
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="title" />
                </xsl:when>
                <xsl:when test="local-name() = 'glossary'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">glossary</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="local-name() = 'bibliography'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">bibliography</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="local-name() = 'index'">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">index</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="local-name()" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- build single line for this chapter (or equivalent) file in toc -->
        <p class="toc level1 tocsp"><a href="{$currFileName}"><xsl:value-of select="$currTitle" /></a></p>
    </xsl:for-each>
</xsl:template>    
    
    
    
</xsl:stylesheet> 
    
    
    
    