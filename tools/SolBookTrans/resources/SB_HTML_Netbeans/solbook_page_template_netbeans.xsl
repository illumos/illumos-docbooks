<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_page_template_netbeans.xsl
    Created on : June 13, 2008
    Author     : Mark Brundege
    Description: The HTML template for each single page of a SolBook XML book.
                 This template should be provided with content at the chapter level
                 or the equivalent (a direct child of book or article).
        
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:include href="solbook_HTML_blocks.xsl" />
    <xsl:include href="solbook_HTML_inlines.xsl" />
    <xsl:include href="solbook_HTML_info.xsl" />
    <xsl:include href="solbook_HTML_links.xsl" />
    <xsl:include href="solbook_HTML_media.xsl" />
    <xsl:include href="solbook_HTML_tables.xsl" />
    <xsl:template name="generatePage">
        <xsl:param name="bookTitle" />
        <xsl:param name="subTitle" />
        <xsl:param name="pageTitle" />
        <xsl:param name="updateDate" />
        <xsl:param name="todayDate" />
        <xsl:param name="author" />
        <xsl:param name="description" />
        <xsl:param name="pageContentNode" />
    
    <!-- the actual page template -->
        <html>
            <head>
                <script src="http://www.netbeans.org/branding/scripts/tigris.js" type="text/javascript">
                </script>
                <link rel="stylesheet" type="text/css" href="http://www.netbeans.org/netbeans.css"/>
                <title>
                    <xsl:value-of select="$bookTitle" />
                </title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <meta http-equiv="Content-Style-Type" content="text/css" />
                <meta name="SourceCastVersion" content="3.5.1.19.10" />
                <link rel="shortcut icon" href="http://www.netbeans.org/favicon.ico" type="image/x-icon" />
                <xsl:element name="meta">
                    <xsl:attribute name="name">description
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:value-of select="$description"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="meta">
                    <xsl:attribute name="name">author
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:value-of select="$author"/>
                    </xsl:attribute>
                </xsl:element>
                <link rel="stylesheet" type="text/css" href="http://www.netbeans.org/netbeans.css" media="screen"/>
                <script src="http://www.netbeans.org/branding/scripts/lang-pulldown.js" type="text/javascript">
                </script>
                <script src="http://www.netbeans.org/branding/scripts/loginbox.js" type="text/javascript">
                </script>
                <script src="http://www.netbeans.org/images/js/switcher.js" type="text/javascript">
                </script>
                <script language="JavaScript" type="text/javascript">
<!--
function get_sc_login() {
  var sclogin = "guest";
  if(sclogin.indexOf("()")==-1) {
  	 return (sclogin);
  } else {
  	 return "guest";
  }

}
var username=get_sc_login();
//-->
                </script>
            </head>
            <body onload="startList()" class="composite blue-bg">
 
 
 <!-- begin TopTabs  -->

<!-- end TopTabs -->

 
<!-- Servlet-Specific template -->
                <div style="background-color:#CCD2E2;height:50px;">
                    <div id="floating-logo">
                        <div id="search">
                            <form method="get" action="http://www.google.com/custom" style="display:inline;">
                                <table>
                                    <tr>
                                        <td>
                                            <a href="http://www.netbeans.org/community/search.html">Search:
                                            </a>
                                        </td>
                                        <td>
                                            <input type="text" name="q" class="text"/>
                                        </td>
                                        <td>
                                            <input type="image" src="http://www.netbeans.org/images/v5/search-button.gif" alt="Search netbeans.org" name="Button"/>
                                            <input type="hidden" name="cof" VALUE="GIMP:#FF0F12;LW:193;ALC:#FF0F12;L:http://www.netbeans.org/images/logo.gif;GFNT:#8A8DB0;LC:#0E0E76;LH:45;AH:center;VLC:#0E0E76;S:http://www.netbeans.org/;AWFID:a8753e5d03543916;"/>
                                            <input type="hidden" name="domains" value="netbeans.org"/>
                                            <input type="hidden" name="sitesearch" value="netbeans.org"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                        <div  class="lang-dropdown">
                            <ul id="nav">
                                <li>
                                    <a href="#" style="text=decoration:none;">Choose page language
                                        <img src="http://www.netbeans.org/images/v5/ar-down2.gif" border="0" style="margin-left:3px;"/>
                                    </a>
                                    <ul class="submenu">
                                        <li>
                                            <a href="javase-intro_ja.html">Japanese
                                            </a>
                                        </li>
                                        <li>
                                            <a href="javase-intro_zh_CN.html">Chinese - simplified
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div class="float-left">
                            <a href="http://www.netbeans.org/index.html">
                                <img src="http://www.netbeans.org/images/v5/nb-logo2.gif" class="logo-link" width="159" height="60" alt="netbeans.org - go to homepage"  title="NetBeans.org - go to the homepage" border="0"  style="padding-top:10px;"/>
                            </a>
                        </div>
                    </div>
                </div>
                <div id="center-container"><!-- layer centering whole page -->
                    <div id="floating-page"><!-- margins for whole page -->
                        <table class="colapse" id="wrap-table"><!-- top level table -->
                            <tr>
                                <td class="floating-wrap-table">
                                    <div id="floating-tabs-container">
                                        <img src="http://www.netbeans.org/images/v5/corner-left.png" class="float-left"  width="11" height="26" style="_margin-left:-3px;"/>
                                        <img src="http://www.netbeans.org/images/v5/corner-right.png" class="float-right"  width="14" height="26" style="_margin-right:-3px;"/>
                                        <div id="floating-tabs">
                                            <a href="http://www.netbeans.org/index.html" title="">
                                                <img src="http://www.netbeans.org/images/v5/home-off.png" alt="" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                            <a href="http://www.netbeans.org/products/index.html" title="Products">
                                                <img src="http://www.netbeans.org/images/v5/products-off.png" alt="Products" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                            <a href="http://www.netbeans.org/catalogue/index.html" title="Plugins">
                                                <img src="http://www.netbeans.org/images/v5/catalogue-off.png" alt="Plugins" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                            <a href="http://www.netbeans.org/kb/index.html" title="Docs Support">
                                                <img src="http://www.netbeans.org/images/v5/kb-on.png" alt="Docs Support" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                            <a href="http://www.netbeans.org/community/index.html" title="Community">
                                                <img src="http://www.netbeans.org/images/v5/community-off2.png" alt="Community" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                            <a href="http://www.netbeans.org/community/partners/index.html" title="Partners">
                                                <img src="http://www.netbeans.org/images/v5/partners-off.png" alt="Partners" width="120" height="26" border="0" class="iMenu"/>
                                            </a>
                                        </div>
                                    </div>
                                    <div id="shade-left">
                                        <div id="shade-right">
                                            <table id="floating-contenttable" class="colapse">
                                                <tr>
                                                    <div id="navig-breadcrumbs" style="margin-left:3px;_margin-left:0px;">
                                                        <a href="http://www.netbeans.org/index.html">HOME
                                                        </a>  /
                                                        <a href="http://www.netbeans.org/kb/index.html">Docs and Support
                                                        </a>  /
                                                        <a href="http://www.netbeans.org/kb/55/index.html">NetBeans 5.5
                                                        </a>
                                                    </div>
                                                    <td class="valign-top b-right full-width"><!-- main content column -->
						<!-- this is hack over the wrong IE box model - fix for problems when using 100% width -->
                                                        <div style="_width:95%;"><!-- IE hack-->
                                                            <div id="print">
                                                                <a href='#' onClick='window.open("http://testwww.netbeans.org/kb/55/javase-intro.html","","left=0,top=0,scrollbars=yes,resizable=yes,toolbar=yes,location=yes,menubar=yes");'>
                                                                    <img src="http://www.netbeans.org/images/v5/print.gif" alt="" width="105" height="15" border="0"/>
                                                                </a>
                                                            </div>
                                                            <div class="f-page-cell" id="doc" >
<!-- Begin Content Area -->
<!--      Copyright (c) 2006 Sun Microsystems, Inc. All rights reserved. -->
<!--     Use is subject to license terms.-->
                                                                <a name="top">
                                                                </a>
                                                                <h1>
                                                                    <xsl:value-of select="$bookTitle" />
                                                                </h1>
                                                                <div class="articledate" style="margin-left: 0px;">Last Updated:
                                                                    <xsl:value-of select="$updateDate" />
                                                                </div>
                                                                <xsl:choose>
                                                                    <xsl:when test="local-name($pageContentNode) = 'title'">
                                                                        <!--<h1>
                                                                            <xsl:value-of select="." />
                                                                        </h1>-->
                                                                        <xsl:if test="$subTitle">
                                                                            <h2>
                                                                                <xsl:value-of select="$subTitle" />
                                                                            </h2>
                                                                        </xsl:if>
                                                                    </xsl:when>
                                                                    <xsl:when test="local-name($pageContentNode) = 'bookinfo'">
                                                                        <xsl:call-template name="infotemplate">
                                                                            <xsl:with-param name="infoNode" select="$pageContentNode" />
                                                                            <xsl:with-param name="includeLegal">
                                                                                <xsl:text>yes</xsl:text>
                                                                            </xsl:with-param>
                                                                        </xsl:call-template>
                                                                    </xsl:when>
                                                                    <xsl:when test="local-name($pageContentNode) = 'chapter'">
                                                                        <a name="{@id}">
                                                                        </a>
                                                                        Chapter
                                                                        <xsl:text> </xsl:text>
                                                                        <xsl:number count="chapter" />
                                                                        <!--<h3>
                                                                            <xsl:value-of select="$pageTitle"/>
                                                                        </h3>-->
                                                                        <xsl:apply-templates select="$pageContentNode" />
                                                                    </xsl:when>
                                                                    <xsl:when test="local-name($pageContentNode) = 'article'">
                                                                        <a name="{@id}">
                                                                        </a>
                                                                        <xsl:call-template name="infotemplate">
                                                                            <xsl:with-param name="infoNode" select="$pageContentNode/articleinfo" />
                                                                            <xsl:with-param name="includeLegal">
                                                                                <xsl:text></xsl:text>
                                                                            </xsl:with-param>
                                                                        </xsl:call-template>
                                                                        <xsl:apply-templates select="$pageContentNode/highlights" />
                                                                        <xsl:apply-templates select="$pageContentNode/sect1" />
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                <!-- apply general SolBook to HTML templates for rest of content -->
                                                                        <a name="{@id}">
                                                                        </a>
                                                                        <xsl:apply-templates select="$pageContentNode" />
                                                                    </xsl:otherwise>
                                                                </xsl:choose>




<!-- End Content Area -->
                                                            </div>
                                                        </div><!-- end IE hack -->
                                                    </td>
                                                    <td class="valign-top">
                                                        <div id="floating-col-right"><!-- right content column -->
                                                            <div class="f-page-cell b-bottom bg-face">
                                                                <h2 style="border:0px;">Learning Trails
                                                                </h2>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/java-se.html">Basic Java Programming
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/matisse.html">Java GUIs and Project Matisse
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/web.html">Web Applications
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/java-ee.html">Java EE Applications
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/mobility.html">Mobile Applications
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/soa.html">SOA Applications and UML
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/trails/platform.html">NetBeans Modules and Rich-Client Applications
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="f-page-cell bg-bege b-bottom">
                                                                <h2 style="border:0px;">Docs for Packs
                                                                </h2>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/55/mobility.html">Mobility Pack
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/55/vwp-index.html">Visual Web Pack
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/55/entpack-index.html">Enterprise Pack
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/55/cnd-index.html ">C/C++ Pack
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                                <div class="rrrarticle">
                                                                    <div class="rarticletitle">
                                                                        <a href="http://www.netbeans.org/kb/55/profiler-index.html">Profiler
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="floating-wrap-table">
	<!-- flexible page footer -->
                                    <div id="floating-footer" class="clear">
                                        <img src="http://www.netbeans.org/images/v5/footer-floating-corner-r.png" class="float-right" width="13" height="42" style="_margin-right:-3px;" />
                                        <img src="http://www.netbeans.org/images/v5/footer-floating-corner-l.png" width="10" height="42" class="float-left" style="_margin-left:-3px;"/>
                                        <div id="footer-text">
                                            <div id="footer-navig" class="float-left font-12">
                                                <a href="http://www.cafeshops.com/netbeans/" >Shop
                                                </a>
                                                <a href="http://www.netbeans.org/download/sitemaps/www_map.html">SiteMap
                                                </a>
                                                <a href="http://www.netbeans.org/about/index.html">About Us
                                                </a>
                                                <a href="http://www.netbeans.org/about/contact.html">Contact
                                                </a>
                                                <a href="http://www.netbeans.org/about/legal/index.html">Legal
                                                </a>
                                            </div>
                                            <div id="tof" class="float-right">
			By use of this website, you agree to the
                                                <a href="http://www.netbeans.org/about/legal/terms-of-use.html">NetBeans Policies and Terms of Use
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
	<!-- /Servlet-Specific template -->

<!-- end of right navigation -->

<!-- servlets and anything not on www or testwww -->


<!-- Begin SiteCatalyst code -->
                <script language="JavaScript" src="http://www.netbeans.org/images/js/s_code_remote.js">
                </script>
<!-- End SiteCatalyst code -->
 <!-- Google webtracking analytics -->
                <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
                </script>
                <script type="text/javascript">
 _uacct = "UA-198771-2";
 urchinTracker();
                </script>
            
    </body>
</html>
</xsl:template>
</xsl:stylesheet>
    
    
    
    