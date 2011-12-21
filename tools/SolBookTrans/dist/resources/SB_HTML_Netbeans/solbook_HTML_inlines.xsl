<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbookToHTML_indiana.xsl
    Created on : April 18, 2008
    Author     : Mark Brundege
    Description:
        Contains templates for transforming individual SolBook XML inline elements to HTML.
        Should be included from a higher-level stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:template match="//para">
        <p><xsl:apply-templates /></p>
    </xsl:template>
    
    <xsl:template match="//remark">
        <p><xsl:apply-templates /></p>
    </xsl:template>
    
    <!-- Variable List and kids -->
    <xsl:template match="//variablelist">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <dl>
            <xsl:apply-templates select="varlistentry" />
        </dl>
    </xsl:template>
    
    <xsl:template match="varlistentry">
        <xsl:apply-templates select="term" />
        <xsl:for-each select="listitem">
            <dd><xsl:apply-templates /></dd>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="term">
        <dt><xsl:apply-templates /></dt>
    </xsl:template>
    
    <!-- Other lists and kids -->
    <xsl:template match="//itemizedlist">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <ul>
            <xsl:for-each select="listitem">
                <li><xsl:apply-templates /></li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="//orderedlist">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <ol>
            <xsl:for-each select="listitem">
                <li><xsl:apply-templates /></li>
            </xsl:for-each>
        </ol>
    </xsl:template>
    
    <xsl:template match="//simplelist">
        <ul>
            <xsl:for-each select="listitem">
                <li><xsl:apply-templates /></li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    
    
    
    <xsl:template match="//member">
        <li><xsl:apply-templates /></li>
    </xsl:template>
    
    <xsl:template match="//emphasis">
        <b><xsl:apply-templates /></b>
    </xsl:template>
    
    <xsl:template match="//command">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//application">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//classname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//computeroutput">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//constant">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//envar">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//errorcode">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//errorname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//errortype">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//exceptionname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//function">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//interfacename">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//keysym">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
	
	<xsl:template match="//literallayout">
		<pre><xsl:apply-templates /></pre>
	</xsl:template>
    
    <xsl:template match="//methodname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//parameter">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
	
	<xsl:template match="//programlisting">
		<pre><tt><xsl:apply-templates /></tt></pre>
	</xsl:template>
    
    <xsl:template match="//property">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//returnvalue">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//structfield">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//structname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//symbol">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//systemitem">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//type">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//guibutton">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//guimenuitem">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//guisubmenu">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//interface">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//userinput">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//option">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//filename">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//systemitem">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//replaceable">
        <tt><i><xsl:apply-templates /></i></tt>
    </xsl:template>
    
    <xsl:template match="//literal">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//varname">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//Arg | //Group| //SynopFragment| //FuncSynopsisInfo| //FuncPrototype| //FuncDef| //Void| //VarArgs| //ParamDef| //FuncParams">
        <tt><xsl:apply-templates /></tt>
    </xsl:template>
    
    <xsl:template match="//screen">
        <pre><tt><xsl:apply-templates /></tt></pre>
    </xsl:template>
    
    <xsl:template match="//trademark">
        <xsl:value-of select="." /><sup>TM</sup>
    </xsl:template>
    
    <xsl:template match="//subscript">
        <sub><xsl:apply-templates /></sub>
    </xsl:template>
    
    <xsl:template match="//superscript">
        <sup><xsl:apply-templates /></sup>
    </xsl:template>
    
    <xsl:template match="//glossentry">
        <xsl:if test="@id">
            <a name="{@id}"></a>
        </xsl:if>
        <dl>
            <xsl:apply-templates select="glossterm" />
            <xsl:apply-templates select="glossdef" />
        </dl>
    </xsl:template>
    
    <xsl:template match="//glossterm">
        <dt><xsl:apply-templates /></dt>
    </xsl:template>
    
    <xsl:template match="//glossdef">
        <dd><xsl:apply-templates /></dd>
    </xsl:template>
    
    <xsl:template match="//blockquote">
        <blockquote><xsl:apply-templates /></blockquote>
    </xsl:template>
    
    <xsl:template match="//@id">
        <a name="{@id}"></a>
    </xsl:template>
   
 
     
</xsl:stylesheet>
