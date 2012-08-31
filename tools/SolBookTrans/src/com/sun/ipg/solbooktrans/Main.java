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

import java.io.File;
import javax.swing.SwingUtilities;

/**
 * For running the app from the command line - either to start the GUI or to provide all args for a transform from the command line
 * @author Mark Brundege
 */
public class Main {
    
    final static boolean amTesting = false;
    
    public final static String VERSION = "1.3";
    public final static String RELEASE = "October 22, 2008";
    
    static File srcFile = null;
    static File outDir = null;
    static File xsltDir = null;
    static String transformType = null;
    static String langCode = "en";
    

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (amTesting) {
            setTestingSpecs();
            runApp();
        } else {
            try {
                if (parseArgsForSpecs(args)) {
                    runApp();
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
                System.out.println(generateUsage());
                System.exit(0);
            }
        }
           
    } 
    
    /**
     *  Runs the app with the static specs in place
     */
    public static void runApp () {
        // instantiate a new SolBookTransformer and send it the data for the transform
        SolBookTransTypeFactory transSettings = SolBookTransTypeFactory.getInstance();
        SolBookTransType transType = transSettings.getTypeForName(transformType);
        SolBookTransformer solbookTransform = null;
        try {
            solbookTransform = SolBookTransformerFactory.getInstance().createSolBookTransformer();
            solbookTransform.setProcessLogger(null);
            solbookTransform.setLangCode(langCode);
            solbookTransform.setOutputDir(outDir);
            solbookTransform.setXmlSrcFile(srcFile);
            solbookTransform.setSolBookTransType(transType);
            solbookTransform.setResDir(xsltDir);
            if ( (transType.getCategory().equals(SolBookTransTypeFactory.CATEGORY_XML)) && (transType.getLaunchFileName() == null) ) {
                transType.setLaunchFileName(srcFile.getName());
            }
            solbookTransform.validateParameters();
            // now run transform as separate thread
            System.out.println("Preparing to run transform " + transType.getTransName() + " on file " + srcFile.getPath());
            solbookTransform.runTransform();
        } catch (Exception e) {
            System.err.println(e.getMessage());
	    System.exit(1);
        }
    }
    
    
    /**
     *  Sets the specs to be used for testing
     */
    public static void setTestingSpecs () {
        srcFile = new File("/home/mb114135/Documents/SolBookXMLDocs/20080215/TRSSUG/TRSSUG.book");
        outDir = new File("/home/mb114135/Documents/SolBookXMLDocs/OUTPUT");
        transformType = SolBookTransTypeFactory.NAME_INDIANA;
        xsltDir = new File("resources");
    }
    
    
    /**
     *  Parses the given array of arguments to set the operating specs
     * @param argList The args to parse
     * @returns true if the args indicate that it should be run from the command line
     * @throws Exception if any improper args
     */
    public static boolean parseArgsForSpecs (String [] argList) throws Exception {
        if ( (argList == null) || (argList.length == 0) ) {
            throw new Exception("No arguments entered.");
        } else if ( (argList.length == 1) && (argList[0].equals("-g")) ) {
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    SolBookTransGUI gui = new SolBookTransGUI();
                    gui.setVisible(true);
                }
            });
            return false;
        } else {
            String srcPath = null;
            String outPath = null;
            String transType = null;
            for (int a=0; a<argList.length-1; a++) {
                if (argList[a].equals("-s")) {
                    srcPath = argList[a+1];
                } else if (argList[a].equals("-o")) {
                    outPath = argList[a+1];
                } else if (argList[a].equals("-t")) {
                    transType = argList[a+1];
                } else if (argList[a].equals("-L")) {
                    Main.langCode = argList[a+1];
                }
            }
            if (srcPath == null){
                throw new Exception("ARG ERROR: No path to source file entered.");
            }
            if (outPath == null){
                throw new Exception("ARG ERROR: No path to output directory entered.");
            }
            if (transType == null){
                throw new Exception("ARG ERROR: No transformation type entered.");
            }
            boolean confirmTransType = false;
            for (int t=0; t<SolBookTransTypeFactory.TRANSFORM_NAMES.length; t++) {
                if (transType.equals(SolBookTransTypeFactory.TRANSFORM_NAMES[t])) {
                    confirmTransType = true;
                    Main.transformType = transType;
                }
            }
            if (! confirmTransType) {
                throw new Exception("ARG ERROR: Unrecognized transform type entered: " + transType);
            }
            srcFile = new File(srcPath);
            outDir = new File(outPath);
            File myDir = new File(".");
            myDir = myDir.getCanonicalFile();
            xsltDir = new File(myDir, "resources");
            return true;
        }
    }
    
    
        
    /**
     *  Generates String of usage info
     *  @return usage info
     */
     public static String generateUsage () {
         String usg = "==========================================================================================\r\n";
         usg += "SolBookTrans: Converts SolBook XML files to HTML or to DocBook XML using XSLT stylesheets.\r\n";
         usg += "Version: " + VERSION + "\r\n";
         usg += "Release Date: " + RELEASE + "\r\n";
         usg += "TO USE:\r\n";
         usg += "cd to the directory containing the SolBookTrans.jar file.\r\n";
         usg += "The resources directory must be in the same directory as the jar file.\r\n";
         usg += "Use the -g option to launch the GUI: java -jar SolBookTrans.jar -g\r\n";
         usg += "   OR, to run from the command line:\r\n";
         usg += "Use the -s option to indicate a path to the SolBook XML file to convert.\r\n";
         usg += "Use the -o option to indicate a path to the directory to output the HTML files into.\r\n";
         usg += "Use the -t option to indicate the XML transformation type to perform. The following strings are available to indicate the transform type:\r\n";
         String [] tStrings = SolBookTransTypeFactory.TRANSFORM_NAMES;
         for (int i=0; i<tStrings.length; i++) {
             usg += tStrings[i] + "\r\n";
         }
         usg += "EXAMPLE: java -jar SolBookTrans.jar -s /home/114135/Docs/sysadm1.xml -o /home/114135/Docs/html -t " + SolBookTransTypeFactory.NAME_INDIANA + "\r\n";
         usg += "At this time, the stylesheets are only available in English, but in the future if this changes another option will be provided to use localized stylesheets.\r\n";
         return usg;
     }
        
        
        
        
    

}
