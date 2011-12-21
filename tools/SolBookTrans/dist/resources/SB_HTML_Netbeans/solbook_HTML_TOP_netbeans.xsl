<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document   : solbook_HTML_TOP_netbeans.xsl
    Created on : June 13, 2008
    Author     : Mark Brundege
    Description:
        Transforms a SolBook 3.5 XML book document into a series of HTML pages,
	1 page for each chapter, in HTML with the NetBeans style
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
                    
    <xsl:include href="solbook_page_template_netbeans.xsl" />
    <xsl:include href="solbook_toc_template_netbeans.xsl" />
    <xsl:include href="html_fileWriter.xsl" />
    <xsl:include href="solbook_HTML_LOCALIZER.xsl" />
                    
    <xsl:output method="html" indent="yes" encoding="UTF-8" />
    
    <!-- outputDir and currentDate should be supplied from processor - either add as command-line options -->
    <!-- or use SolBookTrans which will add them -->
    <xsl:param name="outputDir" />
    <xsl:param name="currentDate" />
    <xsl:param name="langCode" />
    
<!-- create a separate HTML page for each child of the book element -->
<xsl:template match="/book">
   <!-- book kids: title | bookinfo | preface | glossary | reference | chapter | appendix | bibliography | index -->
   <!-- book/part kids: part/partintro | part/chapter | part/reference | part/glossary | part/appendix | part/bibliography -->
   <xsl:for-each select="*">
       <xsl:choose>
           <xsl:when test="local-name() = 'subtitle'">
               <!-- do nothing -->
           </xsl:when>
           <xsl:when test="local-name() = 'part'">
               <xsl:for-each select="part/*">
                   <xsl:call-template name="processPageElement" />
               </xsl:for-each>
           </xsl:when>
           <xsl:otherwise>
               <xsl:call-template name="processPageElement" />
           </xsl:otherwise>
       </xsl:choose>
   </xsl:for-each>
    <!-- make a TOC index.html page -->
    <html>
        <head>
            <title><xsl:value-of select="/book/title" /></title>
            <link rel="stylesheet" type="text/css" href="http://www.netbeans.org/netbeans.css"/>
            <link rel="shortcut icon" href="http://www.netbeans.org/favicon.ico" type="image/x-icon" />
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
        <h1><xsl:value-of select="/book/title"/></h1>
        
        
        
        <xsl:call-template name="generatePageToc" />

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


<!-- Named template for processing most children of book or book/part - each will become new file -->
<xsl:template name="processPageElement">
    <xsl:message>Beginning to process page element <xsl:value-of select="local-name()"/> </xsl:message>
        <xsl:variable name="htmlFileName">
            <xsl:call-template name="generateFileName">
                <xsl:with-param name="myName" select="local-name()" />
                <xsl:with-param name="myPosition" select="position()" />
            </xsl:call-template>
        </xsl:variable>
        <!-- generate a variable which will contain the html output for each page -->
        <xsl:variable name="htmlPageContent">
            <xsl:call-template name="generatePage">
                <xsl:with-param name="bookTitle">
                    <xsl:value-of select="/book/title" />
                </xsl:with-param>
                <xsl:with-param name="subTitle">
                    <xsl:value-of select="/book/subtitle" />
                </xsl:with-param>
                <xsl:with-param name="pageTitle">
                    <xsl:value-of select="./title" />
                </xsl:with-param>
                <xsl:with-param name="updateDate">
                    <xsl:value-of select="/book/bookinfo/pubdate" />
                </xsl:with-param>
                <xsl:with-param name="todayDate" select="$currentDate" />
                <xsl:with-param name="author">
                    <xsl:value-of select="/book/bookinfo/authorgroup/author"/>
                </xsl:with-param>
                <xsl:with-param name="description">
                    <xsl:value-of select="/book/bookinfo/abstract"/>
                </xsl:with-param>
                <xsl:with-param name="pageContentNode" select="." />
            </xsl:call-template>
        </xsl:variable>
        <!-- save the page -->
        <xsl:variable name="theFileName">
            <xsl:call-template name="generateFileName">
                <xsl:with-param name="myName" select="local-name()" />
                <xsl:with-param name="myPosition" select="position()" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="theFilePath" select="concat($outputDir,'/',$theFileName)" />
        <xsl:call-template name="writeFile">
            <xsl:with-param name="saveFilePath" select="$theFilePath" />
            <xsl:with-param name="resultContent">
                <xsl:copy-of select="$htmlPageContent"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:message>Done processing page element <xsl:value-of select="local-name()"/></xsl:message>
</xsl:template>


<!-- Different high-level template for Articles - they will be exported onto a single index.html page -->
<xsl:template match="/article">
    <xsl:call-template name="generatePage">
        <xsl:with-param name="bookTitle">
            <xsl:value-of select="/article/title" />
        </xsl:with-param>
        <xsl:with-param name="pageTitle">
            <xsl:value-of select="/article/title" />
        </xsl:with-param>
        <xsl:with-param name="updateDate">
            <xsl:value-of select="/article/articleinfo/pubdate" />
        </xsl:with-param>
        <xsl:with-param name="todayDate" select="$currentDate" />
        <xsl:with-param name="author">
              <xsl:value-of select="/article/articleinfo/authorgroup/author"/>
        </xsl:with-param>
        <xsl:with-param name="description">
              <xsl:value-of select="/article/articleinfo/abstract"/>
        </xsl:with-param>
        <xsl:with-param name="pageContentNode" select="." />
    </xsl:call-template>    
</xsl:template>
    
   
 
     
</xsl:stylesheet>
