<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_LOCALIZER.xsl
    Created on : April 28, 2008
    Author     : Mark Brundege
    Description:
        Provides the localized versions of predefined words and phrases.
        Obtains these words and phrases from solbook_HTML_locales.xml
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
        <xsl:template name="localizer">
            <xsl:param name="wordName" />
            <xsl:param name="languageCode" />
            <xsl:variable name="localeData" select="document('solbook_HTML_locales.xml')" />
            <xsl:variable name="retrievedWord">
                <xsl:for-each select="$localeData/root/*">
                    <xsl:if test="local-name() = $languageCode">
                        <xsl:for-each select="current()/*">
                            <xsl:if test="local-name() = $wordName">
                                <xsl:value-of select="current()" />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string($retrievedWord)">
                    <xsl:value-of select="$retrievedWord" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">ERROR: No localized word available 
                    for <xsl:value-of select="$wordName" /> for lang code <xsl:value-of select="$languageCode" />
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>
        
 
     
</xsl:stylesheet>


