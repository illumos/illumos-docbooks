<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_toc_template_indiana.xsl
    Created on : April 22, 2008
    Author     : Mark Brundege
    Description: The HTML template for generating the page-specific TOC for SolBook in project indiana style.
        This should be provided with the context node for the page. Should be chapter or equivalent.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
<xsl:include href="solbook_navlink_template_indiana.xsl" />
<xsl:include href="solbook_HTML_inlines.xsl" />

<!-- generates a file name for the given context node, which should be a child of the book node -->
<xsl:template name="generatePageToc">
    <xsl:variable name="currPageName" select="local-name()" />
    <!--

	Traditionally the position() function was used to try and determine
	whether or not we were in the same section. Unfortunately that is not
	actually a valid way to determine this information because it is
	relative to the context node. That means that as we iterate over each
	part, it will be seen as the same value which ultimately just breaks us.
	Instead, we rely on a variant of the id. Most sections have an id, aside
	from the partintro. Therefore because there is only one partintro, we
	simply grab the id of the part itself.

     -->
    <xsl:variable name="currPageId" >
    	<xsl:choose>
		<xsl:when test="local-name() = 'partintro'">
			<xsl:value-of select="ancestor::part/@id" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@id" />
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="currPagePosition" select="position()" />
    <!-- book kids: title | bookinfo | preface | glossary | reference | chapter | appendix | bibliography | index -->
    <!-- book/part kids: part/partintro | part/chapter | part/reference | part/glossary | part/appendix | part/bibliography -->
    <xsl:for-each select="/book/* | /book/part/*">
        <xsl:choose>
            <xsl:when test="local-name() = 'part'">
                <!-- do nothing -->
		<xsl:for-each select="./*">
		<!-- XXX -->
		<!-- XXX -->

		</xsl:for-each>
            </xsl:when>
            <xsl:when test="local-name() = 'title'">
                <!-- do nothing -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="currFileName">
                    <xsl:call-template name="generateFileName" />
                </xsl:variable>
                <xsl:variable name="currTitle">
                    <xsl:choose>
                        <xsl:when test="local-name() = 'chapter'">
                            <xsl:number count="chapter" level="any" />
                            <xsl:text>.&#32;&#32;</xsl:text>
                            <xsl:apply-templates select="title" />
                        </xsl:when>
                        <xsl:when test="local-name() = 'partintro'">
                            <xsl:text>Part </xsl:text>
                            <xsl:number count="partintro" level="any"  format="I"/>
                            <xsl:text>.&#32;&#32;</xsl:text>
                            <xsl:value-of select="../title" />
                        </xsl:when>
                        <xsl:when test="local-name() = 'title'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">title_page</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name() = 'bookinfo'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">document_information</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name() = 'preface'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">preface</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name() = 'appendix'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">appendix</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:number count="appendix" />
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="title" />
                        </xsl:when>
                        <xsl:when test="local-name() = 'reference'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">reference</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:number count="reference" />
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="title" />
                        </xsl:when>
                        <xsl:when test="local-name() = 'glossary'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">glossary</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name() = 'bibliography'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">bibliography</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name() = 'index'">
                            <xsl:call-template name="localizer">
                                <xsl:with-param name="wordName">index</xsl:with-param>
                                <xsl:with-param name="languageCode" select="$langCode" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="local-name()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
		   <xsl:variable name="loopid" >
			<xsl:choose>
				<xsl:when test="local-name() = 'partintro'">
					<xsl:value-of select="ancestor::part/@id" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@id" />
				</xsl:otherwise>
			</xsl:choose>
		    </xsl:variable>

                <xsl:if test="$currPageId != $loopid">
                    <p class="toc level1 tocsp"><a href="{$currFileName}"><xsl:value-of select="$currTitle" /></a></p>
                </xsl:if>
                <!-- if this current iteration is for the current calling page, then also populate sub-menu -->
                <xsl:if test="$currPageId = $loopid">
                    <div class="onpage">
                        <p class="toc level1 tocsp"><a href="{$currFileName}"><xsl:value-of select="$currTitle" /></a></p>
                    <xsl:for-each select="sect1">
                        <xsl:variable name="sect1title">
                            <xsl:value-of select="title"/>
                        </xsl:variable>
                        <xsl:variable name="sect1id">
                            <xsl:value-of select="@id" />
                        </xsl:variable>
                        <p class="toc level2"><a href="#{$sect1id}"><xsl:value-of select="$sect1title" /></a></p>
                        <xsl:for-each select="task">
                            <xsl:variable name="tasktitle">
                                <xsl:value-of select="title"/>
                            </xsl:variable>
                            <xsl:variable name="taskid">
                                <xsl:value-of select="@id" />
                            </xsl:variable>
                            <p class="toc level3"><a href="#{$taskid}"><xsl:value-of select="$tasktitle" /></a></p>
                        </xsl:for-each>
                    </xsl:for-each>
                    </div>
                </xsl:if>
            </xsl:otherwise><!-- if it was not a book/part -->
        </xsl:choose>
    </xsl:for-each><!-- foreach book/child or /book/part/child -->
</xsl:template>    

</xsl:stylesheet> 
