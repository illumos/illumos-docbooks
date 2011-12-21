<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : identityTransform.xsl
    Created on : June 19, 2008
    Author     : Mark Brundege
    Description:
        Copies 1 XML source tree to an identical XML result tree.
        Useful for combining external parsed entities into a single document.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>

     <!-- remove all xml:base attributes, not needed here -->
     <xsl:template match="@base"></xsl:template>

    <!-- copy over everything else as is -->
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>
