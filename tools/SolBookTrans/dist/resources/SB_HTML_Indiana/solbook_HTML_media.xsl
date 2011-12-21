<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_media.xsl
    Created on : April 24, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML media elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    
                    
    <xsl:template match="//figure">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <xsl:if test="title">
            <h6><xsl:value-of select="title" /></h6>
        </xsl:if>
        <xsl:apply-templates select="mediaobject" />
    </xsl:template>
    
    <xsl:template match="//mediaobject | //inlinemediaobject">
        <!-- get a unique number for this - use its absolute element position in source doc -->
        <xsl:variable name="mediaNumber">
            <xsl:number level="any" />
        </xsl:variable>
        <!-- deal with text description first - simpara means alt tag (or equivalent), para means separate file -->
        <xsl:variable name="altText">
            <xsl:value-of select="normalize-space(.//textobject/simpara)" />
        </xsl:variable>
        <xsl:variable name="longDescFile">
            <xsl:if test=".//textobject/para">
                <xsl:value-of select="concat('longDesc_', $mediaNumber, '.html')" />
                <!-- call to writeFile template: note the dependence on the $outputDir variable -->
                <xsl:call-template name="writeFile">
                    <xsl:with-param name="saveFilePath" select="concat($outputDir, '/', 'longDesc_', $mediaNumber, '.html')" />
                    <xsl:with-param name="resultContent">
                        <xsl:value-of select=".//textobject/para" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <!-- get path names and dimensions regardless of type -->
        <xsl:variable name="mediaFilePath">
            <xsl:value-of select="unparsed-entity-uri(.//@entityref)"/>
        </xsl:variable>
        <!-- SolBook 3.5 XML only contains a single image file ref, and it is only tiff or eps! -->
        <!-- so the below var will translate the tiff or eps name to a gif name. Is this bad? Yes! -->
        <xsl:variable name="webMediaFilePath">
            <xsl:choose>
                <xsl:when test="contains($mediaFilePath,'.tif')">
                    <xsl:value-of select="substring-before($mediaFilePath, '.tif')" /><xsl:text>.gif</xsl:text>
                </xsl:when>
                <xsl:when test="contains($mediaFilePath,'.eps')">
                    <xsl:value-of select="substring-before($mediaFilePath, '.eps')" /><xsl:text>.gif</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mediaFilePath" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mediaWidth">
            <xsl:value-of select=".//@width" />
        </xsl:variable>
        <xsl:variable name="mediaHeight">
            <xsl:value-of select=".//@depth" />
        </xsl:variable>
        <!-- if its a Flash file, use Flash HTML regardless of type otherwise -->
        <xsl:choose>
            <xsl:when test="contains($mediaFilePath, '.swf')">
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="{$mediaWidth}" height="{$mediaHeight}">
                    <param name="movie" value="{$mediaFilePath}" />
                    <param name="quality" value="high" />
                    <embed src="{$mediaFilePath}" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="{$mediaWidth}" height="{$mediaHeight}"></embed>
                </object>
                <xsl:if test="string($altText)">
                    <p><i><xsl:value-of select="$altText" /></i></p>
                </xsl:if>
                <xsl:if test="string($longDescFile)">
                    <p><i><a href="{$longDescFile}" target="_blank">
                        <xsl:call-template name="localizer">
                            <xsl:with-param name="wordName">view_media_description</xsl:with-param>
                            <xsl:with-param name="languageCode" select="$langCode" />
                        </xsl:call-template>
                    </a></i></p>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- use img tag for images, use anchor tag for everything else for now -->
                    <xsl:when test=".//imageobject">
                        <xsl:element name="img">
                            <xsl:attribute name="src"><xsl:value-of select="$webMediaFilePath" /></xsl:attribute>
                            <xsl:attribute name="alt"><xsl:value-of select="$altText" /></xsl:attribute>
                            <xsl:attribute name="border">0</xsl:attribute>
                            <!-- position img differently for inline vs. normal -->
                            <xsl:if test="local-name() = 'inlinemediaobject'">
                                <xsl:attribute name="align">middle</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="string($mediaWidth) and string($mediaHeight)">
                                <xsl:attribute name="width"><xsl:value-of select="$mediaWidth" /></xsl:attribute>
                                <xsl:attribute name="height"><xsl:value-of select="$mediaHeight" /></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="string($longDescFile)">
                                <xsl:attribute name="longdesc"><xsl:value-of select="$longDescFile" /></xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test=".//videoobject">
                        <a href="{$mediaFilePath}" target="_blank">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">launch_video_clip</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </a>
                        <xsl:if test="string($altText)">
                            <p><i><xsl:value-of select="$altText" /></i></p>
                        </xsl:if>
                        <xsl:if test="string($longDescFile)">
                            <p><i><a href="{$longDescFile}" target="_blank">
                        <xsl:call-template name="localizer">
                            <xsl:with-param name="wordName">view_media_description</xsl:with-param>
                            <xsl:with-param name="languageCode" select="$langCode" />
                        </xsl:call-template>
                    </a></i></p>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test=".//audioobject">
                        <a href="{$mediaFilePath}" target="_blank">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">launch_audio_clip</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </a>
                        <xsl:if test="string($altText)">
                            <p><i><xsl:value-of select="$altText" /></i></p>
                        </xsl:if>
                        <xsl:if test="string($longDescFile)">
                            <p><i><a href="{$longDescFile}" target="_blank">
                        <xsl:call-template name="localizer">
                            <xsl:with-param name="wordName">view_media_description</xsl:with-param>
                            <xsl:with-param name="languageCode" select="$langCode" />
                        </xsl:call-template>
                    </a></i></p>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
   
 

     
</xsl:stylesheet>
