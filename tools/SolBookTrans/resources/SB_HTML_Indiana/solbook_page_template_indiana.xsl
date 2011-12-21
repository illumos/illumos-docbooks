<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_page_template_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description: The HTML template for each single page of a SolBook XML book.
                 This template should be provided with content at the chapter level
                 or the equivalent (a direct child of book or article).
        
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:include href="solbook_HTML_blocks.xsl" />
    <xsl:include href="solbook_HTML_inlines.xsl" />
    <xsl:include href="solbook_HTML_info.xsl" />
    <xsl:include href="solbook_HTML_links.xsl" />
    <xsl:include href="solbook_HTML_media.xsl" />
    <xsl:include href="solbook_HTML_tables.xsl" />
    
<xsl:template name="generatePage">
    <xsl:param name="bookTitle" />
    <xsl:param name="subTitle" />
    <xsl:param name="pageTitle" />
    <xsl:param name="prevFile" />
    <xsl:param name="nextFile" />
    <xsl:param name="todayDate" />
    <xsl:param name="tocText" />
    <xsl:param name="pageContentNode" />
    
    <xsl:variable name="prevLink">
        <xsl:choose>
            <xsl:when test="string($prevFile)">
                <a href="{$prevFile}">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">previous</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="nextLink">
        <xsl:choose>
            <xsl:when test="string($nextFile)">
                <a href="{$nextFile}">
                    <xsl:call-template name="localizer">
                        <xsl:with-param name="wordName">next</xsl:with-param>
                        <xsl:with-param name="languageCode" select="$langCode" />
                    </xsl:call-template>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- the actual page template -->
    <html>
       <head>
            <title><xsl:value-of select="$pageTitle" /> - <xsl:value-of select="$bookTitle" /></title>
            <meta name="robots" content="index,follow" />
            <xsl:element name="meta"><xsl:attribute name="name">date</xsl:attribute><xsl:attribute name="content"><xsl:value-of select="$todayDate"/></xsl:attribute></xsl:element>
            <meta name="collection" content="reference" />
            <link rel="stylesheet" type="text/css" href="css/elements.css" />
            <link rel="stylesheet" type="text/css" href="css/indiana.css" />
       </head>
       <body>
            <div class="Masthead">
                <div class="MastheadLogo"> </div>
                <div class="Title"><xsl:value-of select="$bookTitle" /></div>
            </div>
            <table class="Layout" border="0" cellspacing="0" width="100%">
            <tbody>
                   <tr valign="top" class="PageControls">
                      <td></td>
                      <td>
                         <table width="100%"><tr>
                             <td align="left"><xsl:copy-of select="$prevLink" /></td>
                             <td align="right"><xsl:copy-of select="$nextLink" /></td>
                           </tr></table>
                      </td>
                   </tr>
                   <tr valign="top">
                       <!-- only include TOC column if there is a TOC -->
                      <xsl:if test="string($tocText)">
                      <td class="Navigation" width="200px">
                          <xsl:copy-of select="$tocText" />
                      </td>
                      </xsl:if>
                      <!-- set width on ContentPane only if there is a TOC column -->
                      <xsl:element name="td">
                          <xsl:attribute name="class">ContentPane</xsl:attribute>
                          <xsl:choose>
                              <xsl:when test="string($tocText)">
                                  <xsl:attribute name="width">705px</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                  <xsl:attribute name="width">100%</xsl:attribute>
                                  <xsl:attribute name="colspan">2</xsl:attribute>
                              </xsl:otherwise>
                          </xsl:choose> 
                         <div class="MainContent">      	 
                             <!-- process main content for page -->
                             <xsl:choose>
                                 <xsl:when test="local-name($pageContentNode) = 'title'">
                                    <h1><xsl:value-of select="." /></h1>
                                    <xsl:if test="$subTitle">
                                        <h2><xsl:value-of select="$subTitle" /></h2>
                                    </xsl:if>
                                </xsl:when>
                                 <xsl:when test="local-name($pageContentNode) = 'bookinfo'">
                                    <xsl:call-template name="infotemplate">
                                        <xsl:with-param name="infoNode" select="$pageContentNode" />
                                        <xsl:with-param name="includeLegal">
                                            <xsl:text>yes</xsl:text>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="local-name($pageContentNode) = 'chapter'">
                                    <a name="{@id}"></a>
                                    <xsl:call-template name="localizer">
                                        <xsl:with-param name="wordName">chapter</xsl:with-param>
                                        <xsl:with-param name="languageCode" select="$langCode" />
                                    </xsl:call-template><xsl:text> </xsl:text><xsl:number count="chapter" level="any" />
                                    <xsl:apply-templates select="$pageContentNode" />
                                </xsl:when>
                                <xsl:when test="local-name($pageContentNode) = 'partintro'">
                                    <a name="{@id}"></a>
                                    <h1><xsl:text>Part </xsl:text><xsl:number count="partintro" level="any"  format="I"/><xsl:text>. </xsl:text><xsl:value-of select="../title" /></h1>
                                    <xsl:apply-templates select="$pageContentNode" />
                                </xsl:when>
                                <xsl:when test="local-name($pageContentNode) = 'article'">
                                    <a name="{@id}"></a>
                                    <xsl:call-template name="infotemplate">
                                        <xsl:with-param name="infoNode" select="$pageContentNode/articleinfo" />
                                        <xsl:with-param name="includeLegal">
                                            <xsl:text></xsl:text>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="$pageContentNode/highlights" />
                                    <xsl:apply-templates select="$pageContentNode/sect1" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- apply general SolBook to HTML templates for rest of content -->
                                    <a name="{@id}"></a>
                                    <xsl:apply-templates select="$pageContentNode" />
                                </xsl:otherwise>
                             </xsl:choose>
                         </div>
                      <!-- end of MainContent -->
                      </xsl:element>
                   </tr>
                   <tr class="PageControls" valign="top">
                      <td></td>
                      <td>
                         <table width="100%">
                           <tr>
                             <td align="left"><xsl:copy-of select="$prevLink" /></td>
                             <td align="right"><xsl:copy-of select="$nextLink" /></td>
                           </tr>
                         </table>
                      </td>
                   </tr>
                </tbody>
                </table>
        </body>
        </html>
    
</xsl:template>
    
    
</xsl:stylesheet>
    
    
    
    