<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbookToHTML_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML block elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    
                    
   <!-- any title for any block -->
   <xsl:template match="title">
       <xsl:variable name="titleParent" select=".." />
       <xsl:choose>
           <xsl:when test="local-name($titleParent) = 'chapter'">
                <h3><xsl:apply-templates /></h3>
           </xsl:when>
           <xsl:when test="local-name($titleParent) = 'sect1'">
                <h3><xsl:value-of select="." /></h3>
           </xsl:when>
           <xsl:when test="local-name($titleParent) = 'sect2'">
                <h3><xsl:value-of select="." /></h3>
           </xsl:when>
           <xsl:when test="local-name($titleParent) = 'sect3'">
                <h4><xsl:value-of select="." /></h4>
           </xsl:when>
           <xsl:when test="local-name($titleParent) = 'sect4'">
                <h5><xsl:value-of select="." /></h5>
           </xsl:when>
           <xsl:when test="local-name($titleParent) = 'task'">
                <h4><xsl:value-of select="." /></h4>
           </xsl:when>
           <xsl:otherwise>
               <h4><xsl:value-of select="." /></h4>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:template>
    
   
   <!-- sect 1 -->
   <xsl:template match="//sect1">
        <a name="{@id}"></a>
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- sect 2 -->
   <xsl:template match="//sect2">
        <a name="{@id}"></a>
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="//sect3">
        <a name="{@id}"></a>
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="//sect4">
        <a name="{@id}"></a>
        <xsl:apply-templates />
    </xsl:template>
    
    
    
    <!-- note, tip, caution -->
    <xsl:template match="//note/para">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">note</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    <xsl:template match="//note">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">note</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    <xsl:template match="//tip/para">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">tip</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    <xsl:template match="//tip">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">tip</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    <xsl:template match="//caution/para">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">caution</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    <xsl:template match="//caution">
        <hr/><p><b><xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">caution</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template> - </b><xsl:apply-templates /></p><hr/>
    </xsl:template>
    
   
   
    <!-- task -->
    <xsl:template match="//task/procedure/step/para[1]">
        <p><b><xsl:apply-templates /></b></p>
    </xsl:template>
    <xsl:template match="//step">
        <li class="step"><xsl:apply-templates /></li>
    </xsl:template>
    <xsl:template match="//task/procedure">
        <p><b>
            <xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">procedure</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template>
        </b></p>
        <ol class="procedure"><xsl:apply-templates /></ol>
    </xsl:template>
    <xsl:template match="//task">
        <a name="{@id}"></a>
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="//tasksummary">
        <p><b>
            <xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">summary</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template>
        </b></p>
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="//taskprerequisites">
        <p><b>
            <xsl:call-template name="localizer">
                 <xsl:with-param name="wordName">prerequisites</xsl:with-param>
                 <xsl:with-param name="languageCode" select="$langCode" />
            </xsl:call-template>
        </b></p>
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="//example">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <!-- <p><b><xsl:value-of select="title" /></b></p> -->
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="//substeps">
        <ol class="substeps" type="a"><xsl:apply-templates /></ol>
    </xsl:template>
    <xsl:template match="//stepalternatives">
        <ul class="stepalternatives"><xsl:apply-templates /></ul>
    </xsl:template>
       
    
    <!-- Q and A set -->
    <xsl:template match="//qandaset">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <xsl:apply-templates select="qandaentry" />
    </xsl:template>
    
    <xsl:template match="qandaentry">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <xsl:apply-templates select="question" />
        <xsl:apply-templates select="answer" />
    </xsl:template>
    
    <xsl:template match="question">
        <p><b><xsl:apply-templates /></b></p>
    </xsl:template>
    
    <xsl:template match="answer">
        <blockquote><xsl:apply-templates /></blockquote>
    </xsl:template>
    
    
    
   
 
     
</xsl:stylesheet>
