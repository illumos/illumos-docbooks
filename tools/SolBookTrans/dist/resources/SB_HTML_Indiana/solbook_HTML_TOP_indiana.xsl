<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_TOP_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Transforms a SolBook 3.5 XML book document into a series of HTML pages,
	1 page for each chapter, in HTML with the Indiana style
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:include href="solbook_page_template_indiana.xsl" />
    <xsl:include href="solbook_toc_template_indiana.xsl" />
    <xsl:include href="html_fileWriter.xsl" />
    <xsl:include href="solbook_HTML_LOCALIZER.xsl" />
                    
    <xsl:output method="html" indent="yes" encoding="UTF-8" />
    
    <!-- outputDir and currentDate should be supplied from processor - either add as command-line options -->
    <!-- or use SolBookTrans which will add them -->
    <xsl:param name="outputDir" />
    <xsl:param name="currentDate" />
    <xsl:param name="langCode" />
        
<!-- create a separate HTML page for each child of the book element -->
<xsl:template match="/book">    
   <!-- book kids: title | bookinfo | preface | glossary | reference | chapter | appendix | bibliography | index -->
   <!-- book/part kids: part/partintro | part/chapter | part/reference | part/glossary | part/appendix | part/bibliography -->
   <xsl:for-each select="part/* | *">
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
           <xsl:otherwise>
               <xsl:call-template name="processPageElement" />
           </xsl:otherwise>
       </xsl:choose>
   </xsl:for-each>
    <!-- make a redirecting index.html page -->
    <html>
        <head>
            <title><xsl:value-of select="title" /></title>
            <meta http-equiv="refresh" content="0;url=preface.html"/>
        </head>
        <body><p> </p></body>
    </html>
</xsl:template>


<!-- Named template for processing most children of book or book/part - each will become new file -->
<xsl:template name="processPageElement">
    <xsl:message>Beginning to process page element <xsl:value-of select="local-name()"/> </xsl:message>
        <xsl:variable name="htmlFileName">
            <xsl:call-template name="generateFileName" />
        </xsl:variable>
        <!-- generate a variable which will contain the html output for each page -->
        <xsl:variable name="htmlPageContent">
            <xsl:call-template name="generatePage">
                <xsl:with-param name="bookTitle">
                    <xsl:value-of select="/book/title" />
                </xsl:with-param>
                <xsl:with-param name="subTitle">
                    <xsl:value-of select="/book/subtitle" />
                </xsl:with-param>
                <xsl:with-param name="pageTitle">
                    <xsl:choose>
                        <xsl:when test="local-name() = 'partintro'">
                            <xsl:value-of select="ancestor::part/title" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./title" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="prevFile">
                    <xsl:call-template name="findPreviousFileName" />
                </xsl:with-param>
                <xsl:with-param name="nextFile">
                    <xsl:call-template name="findNextFileName" />
                </xsl:with-param>
                <xsl:with-param name="todayDate" select="$currentDate" />
                <xsl:with-param name="tocText">
                    <xsl:call-template name="generatePageToc" />
                </xsl:with-param>
                <xsl:with-param name="pageContentNode" select="." />
            </xsl:call-template>
        </xsl:variable>
        <!-- save the page -->
        <xsl:variable name="theFileName">
            <xsl:call-template name="generateFileName" />
        </xsl:variable>
        <xsl:variable name="theFilePath" select="concat($outputDir,'/',$theFileName)" />
        <xsl:call-template name="writeFile">
            <xsl:with-param name="saveFilePath" select="$theFilePath" />
            <xsl:with-param name="resultContent">
                <xsl:copy-of select="$htmlPageContent"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:message>Done processing page element <xsl:value-of select="local-name()"/></xsl:message>
</xsl:template>


<!-- Different high-level template for Articles - they will be exported onto a single index.html page -->
<xsl:template match="/article">
    <xsl:call-template name="generatePage">
        <xsl:with-param name="bookTitle">
            <xsl:value-of select="/article/title" />
        </xsl:with-param>
        <xsl:with-param name="pageTitle">
            <xsl:value-of select="/article/title" />
        </xsl:with-param>
        <xsl:with-param name="prevFile">
            <xsl:text></xsl:text>
        </xsl:with-param>
        <xsl:with-param name="nextFile">
            <xsl:text></xsl:text>
        </xsl:with-param>
        <xsl:with-param name="todayDate" select="$currentDate" />
        <xsl:with-param name="tocText">
            <xsl:text></xsl:text>
        </xsl:with-param>
        <xsl:with-param name="pageContentNode" select="." />
    </xsl:call-template>    
</xsl:template>
    
   
 
     
</xsl:stylesheet>
