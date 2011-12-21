<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_tables.xsl
    Created on : April 24, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML inline elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    
      <xsl:template match="//table | //informaltable">
          <!-- id and title are not present in informaltables -->
          <xsl:if test="@id">
            <a name="{@id}"></a>
          </xsl:if>
          <xsl:if test="title">
              <h6><xsl:value-of select="title" /></h6>
          </xsl:if>
          <!-- determine border for table: either 0 or 1 -->
          <xsl:variable name="tableBorder">
              <xsl:choose>
                  <xsl:when test="@frame = 'top' or @frame = 'bottom'  or @frame = 'topbot' or @frame = 'all' or @frame = 'sides' ">
                      <xsl:text>1</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:text>0</xsl:text>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:variable>
          <!-- make main table and rows, call entry template for cells -->
          <table border="{$tableBorder}" cellspacing="2" cellpadding="8">
              <xsl:for-each select=".//row">
                  <tr>
                      <xsl:apply-templates select="entry" />
                  </tr>
              </xsl:for-each>
          </table>
      </xsl:template>
      
      <xsl:template match="entry">
          <xsl:variable name="cellAlign" select="@align" />
          <xsl:variable name="cellValign" select="@valign" />
          <xsl:choose>
              <xsl:when test="ancestor::thead">
                  <th align="{$cellAlign}" valign="{$cellValign}"><xsl:apply-templates /></th>
              </xsl:when>
              <xsl:otherwise>
                  <td align="{$cellAlign}" valign="{$cellValign}"><xsl:apply-templates /></td>
              </xsl:otherwise>
          </xsl:choose>
      </xsl:template>
          
          
          
          
          
      
                    
                    
                    
                    
   
 
     
</xsl:stylesheet>
