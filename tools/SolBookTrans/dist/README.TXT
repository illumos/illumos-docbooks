SolBookTrans: Converts SolBook XML files to HTML or to DocBook XML using XSLT stylesheets.

TO USE:
cd to the directory containing the SolBookTrans.jar file.
The resources directory must be in the same directory as the jar file.
Use the -g option to launch the GUI: java -jar SolBookTrans.jar -g
   OR, to run from the command line:
Use the -s option to indicate a path to the SolBook XML file to convert.
Use the -o option to indicate a path to the directory to output the HTML files into.
Use the -t option to indicate the XML transformation type to perform. The following strings are available to indicate the transform type:
    HTML_Project_Indiana_Style
    HTML_NetBeans_Style
    DocBook_v4.0
    DocBook_v4.4
    DocBook_v5.0
	
 EXAMPLE: java -jar SolBookTrans.jar -s /home/114135/Docs/sysadm1.xml -o /home/114135/Docs/html -t HTML_Project_Indiana_Style
 At this time, the stylesheets are only available in English, but in the future if this changes another option will be provided to use localized stylesheets.

IMPORTANT NOTE ABOUT MEDIA IN SOLBOOK: SolBook 3.5 XML files only allow a reference to a single media file in each mediaobject element. In many cases this 
reference will be to a .tiff or a .eps file because these are used for PDFs. However, only .gif or .jpg files can be used for HTML 
output for the Web. So this conversion tool will convert each .tiff or .eps reference to a .gif reference of the same name.
HOWEVER, the conversion tool will not actually convert the graphic files themselves. So if the figures directory of a book contains
only .tiff or .eps files, you will have to use an external method to convert them to .gif files. This can be done with any of many 
commercial image editing applications such as Photoshop or Paint Shop Pro, or from the freely available ImageMagick application which  
can be used on many platforms including Solaris (http://www.imagemagick.org).

Note that this version (1.0) is capable of handing the part element in SolBook, which the previous version could not handle properly.








