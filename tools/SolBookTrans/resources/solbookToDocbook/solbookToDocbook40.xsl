<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbookToDocbook.xsl
    Created on : June 20, 2006, 11:30 AM
    Author     : mb114135
    Description:
        Transforms XML files derived from the dscxml tool into DocBook v. 4.4 compliant XML files.
        Note that at this time this file does not do 100% of the conversion, some of the things 
        such as chunking files, XInclude resolution, external entity copying and resolution,
        doctype declaration modification, olink targetdoc referencing, and root namespace addition are done with the 
        DocBookTransformer Java app, which this file always needs to be used with.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" doctype-system="http://www.oasis-open.org/docbook/xml/4.0/docbookx.dtd" 
     doctype-public="-//OASIS//DTD DocBook XML V4.0//EN" 
     indent="yes" />
     
     
     
     <!-- remove fpi attribute from any element -->
     <xsl:template match="@fpi"></xsl:template>
     
     <!-- remove all xml:base attributes, not needed here -->
     <xsl:template match="@base"></xsl:template>
     
    
    <!-- remove gentext elements and content -->
    <xsl:template match="//gentext"></xsl:template>
    
    
    <!-- put indexlocation element attribute values into the indexentry element (its parent) -->
    <xsl:template match="//indexentry">
    	<xsl:variable name = "indexlocContext" ><xsl:value-of select = "./indexlocation/@context" /></xsl:variable>
        <xsl:variable name = "indexID" ><xsl:value-of select = "./indexlocation/@id" /></xsl:variable>
        <xsl:element name="indexentry">
            <xsl:if test="string-length($indexID) &gt; 0">
                <xsl:attribute name="id"><xsl:value-of select="$indexID" /></xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($indexlocContext) &gt; 0">
                <xsl:attribute name="xreflabel"><xsl:value-of select="$indexlocContext" /></xsl:attribute>
            </xsl:if>    
	    <xsl:for-each select = "@*" >
	    	    <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
            </xsl:for-each> 
	    <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- delete indexlocation elements (now that their content has been pulled into indexentry by above -->
    <xsl:template match="//indexlocation"></xsl:template>
    
    <!-- replace taskrelated-custom with taskrelated -->
    <xsl:template match="//taskrelated-custom">
            <xsl:element name="taskrelated"> 
            <xsl:for-each select = "@*" >
	    	    <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
            </xsl:for-each> 
            <xsl:apply-templates/> 
    </xsl:element>
    </xsl:template>
    
    <!-- it also appears that the option element is not allowed within the command element -->
    <!-- so remove options from inside commands -->
    <xsl:template match="//command">
          <xsl:element name="command">   
             <xsl:for-each select = "@*" >
	    	    <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
                </xsl:for-each>  
             <xsl:for-each select = "./*" >
                 <xsl:choose>
                     <xsl:when test="name() = 'option'"></xsl:when>
                     <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                 </xsl:choose>
             </xsl:for-each> 
          </xsl:element>
    </xsl:template>
    
    <!-- Insert the PDL legal notice at the beginning of any legalnotice elements -->
    <xsl:template match="//legalnotice">
        <xsl:element name="legalnotice">
            <xsl:element name="para">The contents of this Documentation are subject to the 
Public Documentation License Version 1.01 (the "License"); 
you may only use this Documentation if you comply with the terms of this License. 
A copy of the License is available at 
http://www.opensolaris.org/os/community/documentation/license.
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- DocBook did not add TASK as an element until v4.3! -->
    <!-- So tasks must be converted to sect#s, and other task-sub-elements must be -->
    <!-- converted to lower sect elements. Ug! -->
    <xsl:template match="//sect1/task">
        <xsl:element name="sect2">
            <xsl:for-each select = "@*" >
               <xsl:attribute name="{name()}">
                   <xsl:value-of select="." />
               </xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="./*">
                <xsl:choose>
                    <xsl:when test="name() = 'title'">
                        <xsl:element name="title">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'taskprerequisites'">
                        <xsl:element name="sect3">
                            <title>Task Prerequisites</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'tasksummary'">
                        <xsl:element name="sect3">
                            <title>Task Summary</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'taskrelated'">
                        <xsl:element name="sect3">
                            <title>Task Related</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//sect2/task">
        <xsl:element name="sect3">
            <xsl:for-each select = "@*" >
               <xsl:attribute name="{name()}">
                   <xsl:value-of select="." />
               </xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="./*">
                <xsl:choose>
                    <xsl:when test="name() = 'title'">
                        <xsl:element name="title">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'taskprerequisites'">
                        <xsl:element name="sect4">
                            <title>Task Prerequisites</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'tasksummary'">
                        <xsl:element name="sect4">
                            <title>Task Summary</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'taskrelated'">
                        <xsl:element name="sect4">
                            <title>Task Related</title>
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- MORE ON TASKS -->
    <xsl:template match="stepalternative">
        <xsl:element name="para">
            Step alternative:
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    
    
    <!-- change olinks to links - otherwise will need to mess around with entities and linkmodes ... -->
    <xsl:template match="//olink">
        <xsl:choose>
            <xsl:when test="./@targetdoc">
                <!-- remove olink element, but keep text within it -->
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="./@targetptr">
                <xsl:element name="link">
                    <xsl:for-each select = "@*" >
                        <xsl:choose>
                            <xsl:when test="name() = 'targetptr'">
                                <xsl:attribute name="linkend"><xsl:value-of select="." /></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- nothing -->
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                <xsl:apply-templates/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- remove olink element, but keep text within it -->
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- The stem must be specified as a title in an itemizedlist -->
    <xsl:template match="//itemizedlist/para">
        <xsl:element name="title">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    
    <!-- change structname element to varname -->
    <xsl:template match="//structname">
        <xsl:element name="varname"> 
            <xsl:for-each select = "@*" >
	    	    <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
            </xsl:for-each> 
            <xsl:apply-templates/> 
        </xsl:element>
    </xsl:template>
    
    <!-- change imagedata entityref to imagedata fileref AND indicate figures subdirectory before fileref value -->
    <xsl:template match="//imagedata">
        <xsl:element name="imagedata">
            <xsl:for-each select = "@*" >
	    	    <xsl:choose>
                        <xsl:when test="name() = 'entityref'">
                            <xsl:attribute name="fileref">
                                <xsl:text>figures/</xsl:text><xsl:value-of select="." />
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="{name()}"><xsl:value-of select="." /></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
            </xsl:for-each> 
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    
    
   
    <!-- copy over everything else as is -->
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>
