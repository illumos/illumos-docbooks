<!ELEMENT xi:include (xi:fallback?) >
<!ATTLIST xi:include
    xmlns:xi   CDATA       #FIXED    "http://www.w3.org/2001/XInclude"
    href       CDATA       #REQUIRED
    parse      (xml|text)  "xml"
    encoding   CDATA       #IMPLIED >

<!ELEMENT xi:fallback ANY>
<!ATTLIST xi:fallback
    xmlns:xi   CDATA   #FIXED   "http://www.w3.org/2001/XInclude" >

<!ENTITY % local.chapter.class "| xi:include">
<!ENTITY % local.preface.class "| xi:include">
<!ENTITY % local.appendix.class "| xi:include">
<!ENTITY % local.glossary.class "| xi:include">
<!ENTITY % local.index.class "| xi:include">










