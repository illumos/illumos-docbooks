<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xl="http://www.w3.org/1999/xlink"
	version="2.0">

<xsl:template match="//para">
	<p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="//remark">
	<p><xsl:apply-templates /></p>
</xsl:template>

<!--

	 For some reason we have absolutely no xslt rules for the indexterm
	 sections. Without these rules we have two problems

	 1) The keywords we've inserted aren't going to be stripped out and
		instead are going to end up in the actual text.

	 2) The index isn't going to contain anything.

	 The following piece of XSLT solves problem 1, but not problem 2.
	 Problem 2 is much harder problem than the other, but it's all software,
	 so it can be fixed.

-->
<xsl:template match='//indexterm'></xsl:template>


<!--

	The command synopsis has special formatting that the other
	pieces don't have. For example, it's command needs to both be
	<tt> and <b> (TODO This should be handled by CSS).

	Next, we have groups of arguments which need to be put together
	in []s. We also need to be able to handle all this recursively.
	blah.

-->
<xsl:template match='cmdsynopsis'>
	<p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match='cmdsynopsis/command'>
	<code><b><xsl:apply-templates /></b></code>
</xsl:template>

<xsl:template match='group'>
	<xsl:text> [</xsl:text>
	<xsl:for-each select="*">
		<xsl:apply-templates select="." />
		<xsl:if test="(local-name() = 'arg') and (position() != last())">
			<xsl:text> |</xsl:text>
		</xsl:if>
		<xsl:text>&#32;</xsl:text>
	</xsl:for-each>
	<xsl:text>]</xsl:text>
</xsl:template>

<!-- Variable List and kids -->
<xsl:template match="//variablelist">
	<dl>
		<xsl:call-template name="add-id" />
		<xsl:apply-templates select="varlistentry" />
	</dl>
</xsl:template>

<xsl:template match="varlistentry">
	<dt>
		<!-- Add the varlistentry's id to the 1st dt -->
		<xsl:call-template name="add-id" />
		<xsl:apply-templates select="term[1]" />
	</dt>
	<xsl:for-each select="term[position() > 1]">
		<dt><xsl:apply-templates /></dt>
	</xsl:for-each>
	<xsl:for-each select="listitem">
		<dd><xsl:apply-templates /></dd>
	</xsl:for-each>
</xsl:template>

<xsl:template match="term">
	<xsl:apply-templates />
</xsl:template>

<!-- Other lists and kids -->
<xsl:template match="//itemizedlist">
	<ul>
		<xsl:call-template name="add-id" />
		<xsl:for-each select="listitem">
			<li><xsl:apply-templates /></li>
		</xsl:for-each>
	</ul>
</xsl:template>

<xsl:template match="//orderedlist">
	<ol>
		<xsl:call-template name="add-id" />
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
	<em><xsl:apply-templates /></em>
</xsl:template>

<!--
	<xsl:template match="//command">
		<tt><xsl:apply-templates /></tt>
	</xsl:template>
-->
<xsl:template match="command">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//application">
	<tt><xsl:apply-templates /></tt>
</xsl:template>

<xsl:template match="//classname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//computeroutput">
	<samp><xsl:apply-templates /></samp>
</xsl:template>

<xsl:template match="//constant">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//envar">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//errorcode">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//errorname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//errortype">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//exceptionname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//function">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//interfacename">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//keysym">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//literallayout">
	<pre><xsl:apply-templates /></pre>
</xsl:template>

<xsl:template match="//methodname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//parameter">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//programlisting">
	<pre><code><xsl:apply-templates /></code></pre>
</xsl:template>

<xsl:template match="//property">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//returnvalue">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//structfield">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//structname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//symbol">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//systemitem">
	<tt><xsl:apply-templates /></tt>
</xsl:template>

<xsl:template match="//type">
	<code><xsl:apply-templates /></code>
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
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//userinput">
	<kbd><xsl:apply-templates /></kbd>
</xsl:template>

<xsl:template match="//option">
	<code><xsl:text>-</xsl:text><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//filename">
	<kbd><xsl:apply-templates /></kbd>
</xsl:template>

<xsl:template match="//replaceable">
	<kbd><i><xsl:apply-templates /></i></kbd>
</xsl:template>

<xsl:template match="//literal">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//varname">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//Arg | //Group| //SynopFragment| //FuncSynopsisInfo| //FuncPrototype| //FuncDef| //Void| //VarArgs| //ParamDef| //FuncParams">
	<code><xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="//screen">
	<pre><samp><xsl:apply-templates /></samp></pre>
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
	<dl>
		<xsl:call-template name="add-id" />
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

</xsl:stylesheet>
