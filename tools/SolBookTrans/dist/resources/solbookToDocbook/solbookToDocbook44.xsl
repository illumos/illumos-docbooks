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
    <xsl:output method="xml" doctype-system="http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" 
     doctype-public="-//OASIS//DTD DocBook XML V4.4//EN" 
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
    
    <!-- it appears that indexterms are not allowed inside tasks (at least not directly within them) -->
    <!-- so remove indexterms from inside tasks -->
    <xsl:template match="//task">     
        <xsl:element name="task">
             <xsl:for-each select = "@*" >
                   <xsl:attribute name="{name()}">
                          <xsl:value-of select="." />
                    </xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select = "./*" >
                <xsl:choose>
                        <xsl:when test="name() = 'indexterm'">
                        </xsl:when>
                        <xsl:when test="name() = 'gentext'">
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="{name()}">
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
	    	</xsl:choose>
            </xsl:for-each>
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
    
    <!-- The various sect elements do not allow tasks after lower sects. -->
    <!-- That is, a sect1 can contain: task, task, task, sect2, sect2 but -->
    <!-- it cannot contain: task, task, sect2, sect2, task, task -->
    <!-- So any sect with a task after lower sects must be wrapped in a new -->
    <!-- instance of that lower sect element, and the title must be duplicated from the task -->
    <!-- to the new sect element. UGGG! -->
    <xsl:template match="//sect1/task">
        <xsl:element name="sect2">
                <title></title>
                <xsl:element name="task">
                    <xsl:for-each select = "@*" >
                        <xsl:attribute name="{name()}">
                          <xsl:value-of select="." />
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:for-each select = "." >
	    	        <xsl:apply-templates />
                    </xsl:for-each>
                </xsl:element>
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
