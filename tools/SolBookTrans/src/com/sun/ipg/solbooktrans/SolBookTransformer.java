/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 1997-2007 Sun Microsystems, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common
 * Development and Distribution License("CDDL") (collectively, the
 * "License"). You may not use this file except in compliance with the
 * License. You can obtain a copy of the License at
 * http://www.netbeans.org/cddl-gplv2.html
 * or nbbuild/licenses/CDDL-GPL-2-CP. See the License for the
 * specific language governing permissions and limitations under the
 * License.  When distributing the software, include this License Header
 * Notice in each file and include the License file at
 * nbbuild/licenses/CDDL-GPL-2-CP.  Sun designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Sun in the GPL Version 2 section of the License file that
 * accompanied this code. If applicable, add the following below the
 * License Header, with the fields enclosed by brackets [] replaced by
 * your own identifying information:
 * "Portions Copyrighted [year] [name of copyright owner]"
 *
 * Contributor(s):
 *
 * If you wish your version of this file to be governed by only the CDDL
 * or only the GPL Version 2, indicate your decision by adding
 * "[Contributor] elects to include this software in this distribution
 * under the [CDDL or GPL Version 2] license." If you do not indicate a
 * single choice of license, a recipient has the option to distribute
 * your version of this file under either the CDDL, the GPL Version 2 or
 * to extend the choice of license to its licensees as provided above.
 * However, if you add GPL Version 2 code and therefore, elected the GPL
 * Version 2 license, then the option applies only if the new code is
 * made subject to such option by the copyright holder.
 */
package com.sun.ipg.solbooktrans;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.swing.SwingWorker;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.w3c.dom.Document;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 * Runs the transformation based on given parameters.
 * These are created with the SolBookTransformerFactory.
 * Here is their lifecycle:
 * - When user begins to request a SolBook transformation, create a new one of these with the SolBookTransformerFactory
 * - Add transform data to this as the user selects it
 * - If the user cancels the transform before it is run, then delete this from the SolBookTransformerFactory
 * - When the user says to run the transform, validate the parameters, then run this as a separate thread
 * - When the transform is complete, this stays in the SolBookTransformerFactory, but is marked as having already run.
 * @author Mark Brundege
 */
public class SolBookTransformer implements ErrorListener, ErrorHandler {
    
    public final static String DOM_ENGINE = "DOM";
    public final static String SAX_ENGINE = "SAX";
    public final static String ENGINE_TYPES [] = new String [] {DOM_ENGINE, SAX_ENGINE};
    
    public final static String PAGE_BREAK_SECTION = "section";
    public final static String PAGE_BREAK_CHAPTER = "chapter";
    public final static String PAGE_BREAK_POINTS [] = new String [] {PAGE_BREAK_SECTION, PAGE_BREAK_CHAPTER};

    private ProcessLogger processLogger;
    private File resDir;
    private File xmlSrcFile;
    private File outputDir;
    private String langCode;
    private String pageBreakPoint;
    private SolBookTransType solBookTransType;
    private File launchFile;
    
    private boolean hasTransformed = false;
    private boolean isTransforming = false;
    private String myLog = "";

    /**
     * Constructor should only be called from SolBookTransformerFactory
     * @param resDir The directory containing the SolBook resource files
     */
    protected SolBookTransformer(File resDir) {
        this.xmlSrcFile = null;
        this.langCode = null;
        this.pageBreakPoint = null;
        this.processLogger = null;
        this.outputDir = null;
        this.solBookTransType = null;
        this.resDir = resDir;
    }

    /**
     * Validates the parameters provided to this instance to ensure they meet the minimum requirements for a transformation.
     * This should be called immediately at the start of a transformation
     * @throws Exception if any needed parameters are missing or incorrect.
     */
    public void validateParameters() throws Exception {
        String errMsg = "";
        if (xmlSrcFile == null) {
            errMsg += "ERROR no XML source file!\r\n";
        } else if (!xmlSrcFile.canRead()) {
            errMsg += "ERROR cannot read XML source file! " + xmlSrcFile.getPath() + "\r\n";
        }
        if (outputDir == null) {
            errMsg += "ERROR no output directory \r\n";
        } else if (!outputDir.exists()) {
            errMsg += "ERROR specified output directory cannot be found: " + getOutputDir().getPath() + " \r\n";
        } else if ((!outputDir.isDirectory()) || (!outputDir.canWrite())) {
            errMsg += "ERROR specified output directory is not a directory or cannot be written to: " + getOutputDir().getPath() + " \r\n";
        }
        if (getLangCode() == null) {
            errMsg += "ERROR no language code defined\r\n";
        }
        if (solBookTransType == null) {
            errMsg += "ERROR no transformation type has been defined\r\n";
        } else if (!this.solBookTransType.getXsltFile(resDir).canRead()) {
            errMsg += "ERROR the needed XSLT file cannot be read: " + this.solBookTransType.getXsltFile(resDir).getPath() + "\r\n";
        }
        if (getPageBreakPoint() == null) setPageBreakPoint(SolBookTransformer.PAGE_BREAK_CHAPTER);
        if (errMsg.length() > 0) {
            throw new Exception(errMsg);
        }
    }
    
    
    
    
    

    /**
     *  Writes the given string as a new line in the GUI
     * @param msg The String to write
     */
    private void loggit(String msg) {
        if (processLogger == null) {
            System.out.println(msg);
        } else {
            this.processLogger.addToLog(msg);
        }
        this.myLog += msg + "\r\n";
    }

    /**
     * Runs the transform. Called as part of SwingWorker thread execution.
     * 
     */
    public String runTransform() throws Exception {
        loggit("Begining transform ...");
        this.isTransforming = true;
        // show transform parameters
        loggit("Transformation Parameters:");
        loggit("XML source file: " + getXmlSrcFile().getPath());
        loggit("XSLT file: " + this.solBookTransType.getXsltFile(resDir).getPath());
        loggit("Output directory: " + getOutputDir().getPath());
        loggit("Transformation name: " + solBookTransType.getTransName());
        loggit("Language: " + getLangCode());
        // See if this is a SolBook doc or not
        String srcConfirmMsg = confirmSolBookSource(this.getXmlSrcFile());
        if (srcConfirmMsg != null) {
            throw new Exception(srcConfirmMsg);
        } else {
            loggit("  Confirmed that source file is a SolBook XML file");
        }
        // see if dtd needs to be copied to source root dir
        try {
            checkAndOrCopyDtdsToSrc();
        } catch (Exception e) {
            throw new Exception("ERROR copying DTDs to source directory: " + e.getMessage());
        }
        // run transform
        this.setLaunchFile(null);
        try {
            if (solBookTransType.getTransformEngine().equals(SolBookTransformer.DOM_ENGINE)) {
                setLaunchFile(performDOMTransform());
            } else if (solBookTransType.getTransformEngine().equals(SolBookTransformer.SAX_ENGINE)) {
                setLaunchFile(performSAXTransform());
            } else {
                throw new Exception("ERROR undefined transformation engine specified: " + solBookTransType.getTransformEngine());
            }
        } catch (Exception e) {
            throw new Exception("ERROR running transformation: " + e.getMessage());
        }
        // copy over additional files
        try {
            performPostTransformFileCopy();
        } catch (Exception e) {
            throw new Exception("ERROR Copying over other files such as media files, css, etc: " + e.getMessage());
        }
        this.isTransforming = false;
        this.hasTransformed = true;
        loggit("TRANSFORM SUCCESSFUL");
        return "TRANSFORM SUCCESSFUL";
    }
    
     
     /**
      * Analyzes the given source file to see if it contains the SolBook Doctype or not. Returns null if it DOES.
      * @param srcFile The main source file to process
      * @return A message about the source file if it DOES NOT contain the SolBook XML doctype, or null IF IT DOES
      * @throws Exception if the file cannot be read
      */
     public String confirmSolBookSource (File srcFile) throws Exception {
         String srcString = TextFileIOUtil.createTextString(srcFile);
         String genMsgEnd = "\r\nThe source file must specify the SolBook XML doctype in order to be transformed by this application.";
         int doctypeStart = srcString.indexOf("<!DOCTYPE");
         if (doctypeStart == -1) return "The source file does not specify a DOCTYPE at the top of the document." + genMsgEnd;
         int firstQuotePos = srcString.indexOf("\"", doctypeStart);
         if (firstQuotePos == -1) return "The DOCTYPE specified in the source file is malformed." + genMsgEnd;
         int secQuotePos = srcString.indexOf("\"", firstQuotePos+1);
         if (secQuotePos == -1) return "The DOCTYPE specified in the source file is malformed." + genMsgEnd;
         String docTypeStr = srcString.substring(firstQuotePos+1, secQuotePos);
         if (docTypeStr.indexOf("-//Sun Microsystems//DTD SolBook-XML 3.5") == -1) return "Wrong doctype in source file. This file specifies the type: " + docTypeStr + genMsgEnd;
         return null;
     }
     
    

    /**
     * Looks up any required DTDs for this transform in the SolBookTransType.
     * Sees if they are already present in source directory or not. If not,
     * copies them over.
     * @throws Exception if the DTDs need to be copied but cannot be
     */
    private void checkAndOrCopyDtdsToSrc() throws Exception {
        String[] dtdNames = solBookTransType.getDtdNames();
        for (int i = 0; i < dtdNames.length; i++) {
            File currDtdSrcFile = new File(this.xmlSrcFile.getParentFile(), dtdNames[i]);
            if (!currDtdSrcFile.exists()) {
                loggit("  copying DTD file or directory: " + currDtdSrcFile.getPath());
                File dtdFile = new File(this.getResDir(), dtdNames[i]);
                if (dtdFile.isFile()) {
                    TextFileIOUtil.copyFile(dtdFile, currDtdSrcFile);
                } else if (dtdFile.isDirectory()) {
                    RecursiveFileUtil.recursiveCopy(this.getXmlSrcFile().getParentFile(), dtdFile);
                }
            }
        }
    }

    /**
     * Copies over graphics files, css files, etc. as specified for this transform type.
     * @throws Exception if IO problems
     */
    private void performPostTransformFileCopy() throws Exception {
        // first copy over directories
        loggit("  copying over support and media directories ...");
        HashMap <String, String> dirMap = solBookTransType.getDirsToCopyMap();
        Iterator <String> keyIter = dirMap.keySet().iterator();
        while (keyIter.hasNext()) {
            String srcDirPath = keyIter.next();
            String outDirPath = dirMap.get(srcDirPath);
            File srcDir = new File(this.getResDir(), srcDirPath);
            if (! srcDir.exists()) throw new Exception("ERROR: Cannot find specified source directory: " + srcDir.getPath());
            File outDir = new File(this.outputDir, outDirPath);
            if (outDirPath.equals("root")) outDir = this.outputDir;
            loggit("  copying directory " + srcDir.getPath() + " to " + outDir.getPath());
            RecursiveFileUtil.recursiveCopy(srcDir, outDir);
        }
        // then copy over files
        loggit("  copying over support and media files ...");
        HashMap <String, String> fileMap = solBookTransType.getFilesToCopyMap();
        Iterator <String> keyFileIter = fileMap.keySet().iterator();
        while (keyFileIter.hasNext()) {
            String srcFilePath = keyFileIter.next();
            String outFilePath = fileMap.get(srcFilePath);
            File srcFile = new File(this.getResDir(), srcFilePath);
            if (! srcFile.exists()) throw new Exception("ERROR: Cannot find specified source file: " + srcFile.getPath());
            File outFile = new File(this.outputDir, outFilePath);
            loggit("  copying directory " + srcFile.getPath() + " to " + outFile.getPath());
            TextFileIOUtil.copyFile(srcFile, outFile);
        }
        // then copy over any subdirectories found in the src directory - these are usually media directories
        copyMediaSubDirs(this.xmlSrcFile.getParentFile(), outputDir);
        loggit(" Done copying over support and media files and directories");
    }



    /**
     *  Copies any media subdirectories found in the given src dir to the given output dir
     * @param srcDir The parent source directory to look for media subdirectories in
     * @param outDir The parent output directory to copy any found directories to
     * @throws Exception if needed dirs could not be copied
     */
    public void copyMediaSubDirs(File srcDir, File outDir) throws Exception {
        ArrayList badDirNames = new ArrayList();
        badDirNames.add("html");
        File dirKids[] = srcDir.listFiles();
        for (int i = 0; i < dirKids.length; i++) {
            if ((dirKids[i].isDirectory()) && (!badDirNames.contains(dirKids[i].getName()))) {
                File newDir = new File(outDir, dirKids[i].getName());
                RecursiveFileUtil.recursiveCopy(dirKids[i], newDir);
            }
        }
    }

    /**
     * Method to use when performing a DOM transform. Uses attributes for xmlSrcFile, xsltFile, outputDir, solbookTransType.
     * @return The launch File generated by the transform
     * @throws Exception for any transform errors
     */
    private File performDOMTransform() throws Exception {
        Document xmlSrcDoc = null;
        try {
            xmlSrcDoc = fileToDOMDoc(this.getXmlSrcFile());
            loggit("  read in XML source as DOM");
        } catch (Exception e) {
            throw new Exception("ERROR while trying to input XML source document: " + e.getMessage());
        }
        // do XSLT transform
        try {
            DOMSource srcDomSource = new DOMSource(xmlSrcDoc);
            StreamSource xsltStream = new StreamSource(this.solBookTransType.getXsltFile(resDir));
            TransformerFactory tFactory = TransformerFactory.newInstance();
            tFactory.setErrorListener(this);
            Transformer xTransformer = tFactory.newTransformer(xsltStream);
            xTransformer.setErrorListener(this);
            loggit("  created transformer with XSLT stylesheets");
            HashMap <String, String> parameterMap = this.solBookTransType.getParameterMap();
            Iterator <String> paramIter = parameterMap.keySet().iterator();
            while (paramIter.hasNext()) {
                String paramName = paramIter.next();
                String paramValue = parameterMap.get(paramName);
                xTransformer.setParameter(paramName, paramValue);
            }
            // the params below are used for all SolBook to HTML transforms and so are left as defaults for now
            if (this.solBookTransType.getUseDefaultTransParams()) {
                xTransformer.setParameter("outputDir", this.getOutputDir().getPath());
                xTransformer.setParameter("currentDate", DateFormat.getDateInstance(DateFormat.MEDIUM).format(Calendar.getInstance().getTime()));
                xTransformer.setParameter("langCode", this.getLangCode());
                xTransformer.setParameter("pageBreakLevel", this.pageBreakPoint);
            }
            // main output will go into launch file in outputDir
            String launchName = this.solBookTransType.getLaunchFileName();
            if (launchName == null) {
                launchName = this.getXmlSrcFile().getName();
                if (launchName.endsWith(".book")) {
                    launchName = launchName.substring(0,launchName.lastIndexOf(".book")) + ".xml";
                }
            }
            File launchFile = new File(this.getOutputDir(), launchName);
            StreamResult indexResult = new StreamResult(launchFile);
            loggit(" Beginning to run actual XSLT transform ....");
            xTransformer.transform(srcDomSource, indexResult);
            loggit(" Successfully completed XSLT transform");
            return launchFile;
        } catch (TransformerConfigurationException tce) {
            tce.printStackTrace();
            throw new Exception("ERROR configuring transformer: " + tce.getMessage());
        } catch (TransformerException e) {
            e.printStackTrace();
            throw new Exception("ERROR during transformation: " + e.getMessage());
        }
    }

    /**
     *  Convenience utility method generates a DOM Document for given XML file
     * @param xmlFile The File to convert to a DOM Document object
     * @return DOM Document
     * @throws Exception if problems occurred
     */
    private Document fileToDOMDoc(File xmlFile) throws Exception {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = dbFactory.newDocumentBuilder();
            docBuilder.setErrorHandler(this);
            Document xmlDoc = docBuilder.parse(xmlFile);
            return xmlDoc;
        } catch (IOException ioe) {
            throw new Exception(ioe.getMessage());
        } catch (SAXException saxe) {
            throw new Exception("XML DOM parser error: " + saxe.getMessage());
        } catch (IllegalArgumentException iae) {
            throw new Exception("Source XML file is null");
        }
    }
    
    
    /**
     * Method to use when performing a SAX transform. Uses attributes for xmlSrcFile, xsltFile, outputDir, solbookTransType.
     *  TO DO - test and fix this method!!!!
     * @return The launch File generated by the transform
     */
    private File performSAXTransform() throws Exception {
        // Instantiate a TransformerFactory.
        javax.xml.transform.TransformerFactory tFactory = javax.xml.transform.TransformerFactory.newInstance();
        // Verify that the TransformerFactory implementation you are using supports SAX input and output (Xalan-Java does!).
        if (tFactory.getFeature(javax.xml.transform.sax.SAXSource.FEATURE) && tFactory.getFeature(javax.xml.transform.sax.SAXResult.FEATURE)) { 
            // Cast the TransformerFactory to SAXTransformerFactory.
            javax.xml.transform.sax.SAXTransformerFactory saxTFactory =  ((javax.xml.transform.sax.SAXTransformerFactory) tFactory);
            // Create a Templates ContentHandler to handle parsing of the stylesheet.
            javax.xml.transform.sax.TemplatesHandler templatesHandler = saxTFactory.newTemplatesHandler();
            // Create an XMLReader and set its ContentHandler.
            org.xml.sax.XMLReader reader = org.xml.sax.helpers.XMLReaderFactory.createXMLReader();
            reader.setContentHandler(templatesHandler);
            // Parse the stylesheet.
            BufferedInputStream bufS = new BufferedInputStream(new FileInputStream(this.solBookTransType.getXsltFile(resDir)));
            InputSource styleSource = new InputSource(bufS);
            reader.parse(styleSource);
            // Get the Templates object (generated during the parsing of the stylesheet)
            // from the TemplatesHandler.
            javax.xml.transform.Templates templates = templatesHandler.getTemplates();
            // Create a Transformer ContentHandler to handle parsing of the XML Source.  
            javax.xml.transform.sax.TransformerHandler transformerHandler = saxTFactory.newTransformerHandler(templates);
            // Reset the XMLReader's ContentHandler to the TransformerHandler.
            reader.setContentHandler(transformerHandler);
            // Set the ContentHandler to also function as a LexicalHandler, which
            // can process "lexical" events (such as comments and CDATA). 
            reader.setProperty("http://xml.org/sax/properties/lexical-handler", transformerHandler);
            // Set up a Serializer to serialize the Result to a file.
            //Serializer serializer = SerializerFactory.getSerializer(OutputProperties.getDefaultMethodProperties("xml"));
            //serializer.setOutputStream(new java.io.FileOutputStream("foo.out"));
            // The Serializer functions as a SAX ContentHandler.
            //javax.xml.transform.Result result = new javax.xml.transform.sax.SAXResult(serializer.asContentHandler());
            //transformerHandler.setResult(result);
            // Parse the XML input document.
            reader.parse("foo.xml");
        } else {
            loggit("NOTE: The requested SAX engine cannot be used - a DOM transformation will be performed instead.");
            this.performDOMTransform();
        }
        return new File(".");
    }
    
    

    public void fatalError(TransformerException exception) throws TransformerException {
        loggit(exception.getMessageAndLocation());
    }

    public void error(TransformerException exception) throws TransformerException {
        loggit(exception.getMessageAndLocation());
    }

    public void warning(TransformerException exception) throws TransformerException {
        loggit(exception.getMessageAndLocation());
    }

    public void fatalError(SAXParseException exception) throws SAXException {
        loggit("Fatal SAX parse error");
    }

    public void error(SAXParseException exception) throws SAXException {
        loggit(exception.getMessage());
    }

    public void warning(SAXParseException exception) throws SAXException {
        loggit(exception.getMessage());
    }

    public ProcessLogger getprocessLogger() {
        return processLogger;
    }

    public void setProcessLogger(ProcessLogger processLogger) {
        this.processLogger = processLogger;
    }

    public File getResDir() {
        return resDir;
    }

    public void setResDir(File resDir) {
        this.resDir = resDir;
    }

    public File getXmlSrcFile() {
        return xmlSrcFile;
    }

    public void setXmlSrcFile(File xmlSrcFile) {
        this.xmlSrcFile = xmlSrcFile;
    }

    public File getOutputDir() {
        return outputDir;
    }

    public void setOutputDir(File outputDir) {
        this.outputDir = outputDir;
    }

    public String getLangCode() {
        return langCode;
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    public SolBookTransType getSolBookTransType() {
        return solBookTransType;
    }

    public void setSolBookTransType(SolBookTransType solBookTransType) {
        this.solBookTransType = solBookTransType;
    }

    public boolean hasTransformed() {
        return hasTransformed;
    }

    public boolean isTransforming() {
        return isTransforming;
    }

    public String getMyLog() {
        return myLog;
    }

    public File getLaunchFile() {
        return launchFile;
    }

    public void setLaunchFile(File launchFile) {
        this.launchFile = launchFile;
    }

    public String getPageBreakPoint() {
        return pageBreakPoint;
    }

    public void setPageBreakPoint(String pageBreakPoint) {
        this.pageBreakPoint = pageBreakPoint;
    }
}
