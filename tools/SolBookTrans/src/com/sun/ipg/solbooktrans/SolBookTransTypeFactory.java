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
import java.util.Arrays;
import java.util.HashMap;
import java.util.Set;

/**
 * This singleton class behaves as both a Factory and a Warehouse for the available transform types.
 * It creates each of the various pre-defined SolBookTransType objects when it is first instantiated.
 * It stores references to each type and can provide them as needed.
 *
 * Note the means of getting the data for the initial creation of the SolBookTransType objects will 
 * evolve over time. Right now, it is hard coded into this class. In the future, it should be 
 * defined in an external XML file which is read in by this class.
 * @author Mark Brundege
 */
public class SolBookTransTypeFactory {
    
    
    // the names of the transformations currently supported
    public final static String NAME_INDIANA = "HTML_Project_Indiana_Style";
    public final static String NAME_NETBEANS = "HTML_NetBeans_Style";
    public final static String NAME_DOCBOOK40 = "DocBook_v4.0";
    public final static String NAME_DOCBOOK44 = "DocBook_v4.4";
    public final static String NAME_DOCBOOK50 = "DocBook_v5.0";
    public final static String [] TRANSFORM_NAMES = new String [] {NAME_INDIANA, NAME_NETBEANS, NAME_DOCBOOK40, NAME_DOCBOOK44, NAME_DOCBOOK50};
    
    // names of transformation categories
    public final static String CATEGORY_XML = "XML";
    public final static String CATEGORY_HTML = "HTML";
    
    static SolBookTransTypeFactory instance = null;
    
    private HashMap <String, SolBookTransType>transTypeMap;
    private String currentTransformName;
    private File currentXmlSrcFile;
    private File currentOutputDir;
    private String currentLangCode;
    private ProcessLogger processLogger;
    
    /**
     * Factory method for obtaining instance
     * @return The single instance of this
     */
    public static SolBookTransTypeFactory getInstance() {
        if (SolBookTransTypeFactory.instance == null) {
            SolBookTransTypeFactory transFactory = new SolBookTransTypeFactory();
            SolBookTransTypeFactory.instance = transFactory;
        }
        return SolBookTransTypeFactory.instance;
    }
    
    /**
     * Use factory method instead of this constructor
     */
    protected SolBookTransTypeFactory () {
        this.currentOutputDir = null;
        this.currentTransformName = null;
        this.currentXmlSrcFile = null;
        this.processLogger = null;
        // FOR NOW the specific details of each transform type are hard-coded into the following methods
        // TODO - longer term removes these from here, and put those details into an XML config file
        // which can be read here and then used to make the specific SolBookTransTypes
        this.transTypeMap = new HashMap();
        for (int n=0; n<TRANSFORM_NAMES.length; n++) {
            SolBookTransType currType = generateTransTypeForName(TRANSFORM_NAMES[n]);
            if (currType != null) transTypeMap.put(TRANSFORM_NAMES[n], currType);
        }
    }
    
    
    
    /**
     * Does the work for creating each type.
     * TO DO - eventually have this done from an XML config files instead of hard-coded here?
     * @param transName The name String of the trans type to generate
     */
    private SolBookTransType generateTransTypeForName (String transName) {
        if (transName.equals(NAME_INDIANA)) {
            String xsltFileName = "SB_HTML_Indiana/solbook_HTML_TOP_indiana.xsl";
            String htmlIndianaDesc = "Converts SolBook 3.5 XML into HTML using the Project Indiana style for OpenSolaris.org. ";
            htmlIndianaDesc += "This style consists of an OpenSolaris header up top, a static TOC on the left side of each page, ";
            htmlIndianaDesc += "and a single HTML page for each chapter of content.";
            SolBookTransType htmlIndiana = new SolBookTransType(CATEGORY_HTML, NAME_INDIANA, htmlIndianaDesc, xsltFileName, "index.html", "DOM");
            HashMap <String, String> parameterMap = new HashMap();
            htmlIndiana.setParameterMap(parameterMap);
            htmlIndiana.setUseDefaultTransParams(true);
            // no extra parameters beyond the default 3 dom ones at this time
            String [] dtdNames = new String [] {"xsolbook.dtd", "sun-iso-map.xml", "solbook.dtd"};
            htmlIndiana.setDtdNames(dtdNames);
            HashMap <String, String> dirsToCopyMap = new HashMap();
            htmlIndiana.setDirsToCopyMap(dirsToCopyMap);
            // no extra dirs to copy
            HashMap <String, String> filesToCopyMap = new HashMap();
            filesToCopyMap.put("SB_HTML_Indiana/elements.css", "css/elements.css");
            filesToCopyMap.put("SB_HTML_Indiana/indiana.css", "css/indiana.css");
            filesToCopyMap.put("SB_HTML_Indiana/header.png", "graphics/header.png");
            htmlIndiana.setFilesToCopyMap(filesToCopyMap);
            return htmlIndiana;
        } else if (transName.equals(NAME_NETBEANS)) {
            String xsltFileName = "SB_HTML_Netbeans/solbook_HTML_TOP_netbeans.xsl";
            String htmlNetbeansDesc = "Converts SolBook 3.5 XML into HTML using the style of NetBeans.org. ";
            htmlNetbeansDesc += "This style consists of the NetBeans.org header, top menu, and right-hand menu. ";
            htmlNetbeansDesc += "There is a single HTML page for each chapter of content.";
            htmlNetbeansDesc += "The NetBeans.org stylesheets are linked to using their external URL.";
            SolBookTransType htmlNetbeans = new SolBookTransType(CATEGORY_HTML, NAME_NETBEANS, htmlNetbeansDesc, xsltFileName, "index.html", "DOM");
            HashMap <String, String> parameterMap = new HashMap();
            htmlNetbeans.setParameterMap(parameterMap);
            htmlNetbeans.setUseDefaultTransParams(true);
            // no extra parameters beyond the default 3 dom ones at this time
            String [] dtdNames = new String [] {"xsolbook.dtd", "sun-iso-map.xml", "solbook.dtd"};
            htmlNetbeans.setDtdNames(dtdNames);
            HashMap <String, String> dirsToCopyMap = new HashMap();
            htmlNetbeans.setDirsToCopyMap(dirsToCopyMap);
            // no extra dirs to copy
            HashMap <String, String> filesToCopyMap = new HashMap();
            htmlNetbeans.setFilesToCopyMap(filesToCopyMap);
            return htmlNetbeans;
        } else if (transName.equals(NAME_DOCBOOK40)) {
            String xsltFileName = "solbookToDocbook/solbookToDocbook40.xsl";
            String desc = "Converts SolBook 3.5 XML into DocBook v4.0 XML.\r\n";
            desc += "Note that DocBook v4.0 is very different from later DocBook versions, so this is provided as a convenience only.\r\n";
            desc += "Significant structural information may be lost in this conversion. For example, there is no task element in v.4.0.";
            SolBookTransType db40Type = new SolBookTransType(CATEGORY_XML, NAME_DOCBOOK40, desc, xsltFileName, null, "DOM");
            HashMap <String, String> parameterMap = new HashMap();
            db40Type.setParameterMap(parameterMap);
            db40Type.setUseDefaultTransParams(false);
            // no extra parameters beyond the default 3 dom ones at this time
            String [] dtdNames = new String [] {"xsolbook.dtd", "sun-iso-map.xml", "solbook.dtd"};
            db40Type.setDtdNames(dtdNames);
            HashMap <String, String> dirsToCopyMap = new HashMap();
            db40Type.setDirsToCopyMap(dirsToCopyMap);
            // no extra dirs to copy
            HashMap <String, String> filesToCopyMap = new HashMap();
            // no extra files to copy
            db40Type.setFilesToCopyMap(filesToCopyMap);
            return db40Type;
        } else if (transName.equals(NAME_DOCBOOK44)) {
            String xsltFileName = "solbookToDocbook/solbookToDocbook44.xsl";
            String desc = "Converts SolBook 3.5 XML into DocBook v4.4 XML";
            SolBookTransType db44Type = new SolBookTransType(CATEGORY_XML, NAME_DOCBOOK44, desc, xsltFileName, null, "DOM");
            HashMap <String, String> parameterMap = new HashMap();
            db44Type.setParameterMap(parameterMap);
            db44Type.setUseDefaultTransParams(false);
            // no extra parameters beyond the default 3 dom ones at this time
            String [] dtdNames = new String [] {"xsolbook.dtd", "sun-iso-map.xml", "solbook.dtd"};
            db44Type.setDtdNames(dtdNames);
            HashMap <String, String> dirsToCopyMap = new HashMap();
            db44Type.setDirsToCopyMap(dirsToCopyMap);
            // no extra dirs to copy
            HashMap <String, String> filesToCopyMap = new HashMap();
            // no extra files to copy
            db44Type.setFilesToCopyMap(filesToCopyMap);
            return db44Type;
        } else if (transName.equals(NAME_DOCBOOK50)) {
            String xsltFileName = "solbookToDocbook/solbookToDocbook5.xsl";
            String desc = "Converts SolBook 3.5 XML into DocBook v5.0 XML";
            SolBookTransType db50Type = new SolBookTransType(CATEGORY_XML, NAME_DOCBOOK50, desc, xsltFileName, null, "DOM");
            HashMap <String, String> parameterMap = new HashMap();
            db50Type.setParameterMap(parameterMap);
            db50Type.setUseDefaultTransParams(false);
            // no extra parameters beyond the default 3 dom ones at this time
            String [] dtdNames = new String [] {"xsolbook.dtd", "sun-iso-map.xml", "solbook.dtd"};
            db50Type.setDtdNames(dtdNames);
            HashMap <String, String> dirsToCopyMap = new HashMap();
            db50Type.setDirsToCopyMap(dirsToCopyMap);
            // no extra dirs to copy
            HashMap <String, String> filesToCopyMap = new HashMap();
            // no extra files to copy
            db50Type.setFilesToCopyMap(filesToCopyMap);
            return db50Type;
        }
        return null;
    }

    
    
    

    public HashMap<String, SolBookTransType> getTransTypeMap() {
        return transTypeMap;
    }

    public String getCurrentTransformName() {
        return currentTransformName;
    }

    public void setCurrentTransformName(String currentTransformName) {
        this.currentTransformName = currentTransformName;
    }
    
    public String [] getTransformNames () {
        Set keySet = transTypeMap.keySet();
        String [] tNames = new String[keySet.size()];
        Object [] tObj = keySet.toArray();
        for (int i=0; i<tObj.length; i++) {
            tNames[i] = (String)tObj[i];
        }
        Arrays.sort(tNames);
        return tNames;
    }
    
    public SolBookTransType getTypeForName (String name) {
        if (transTypeMap.containsKey(name)) return (SolBookTransType)transTypeMap.get(name);
        return null;
    }

    public File getCurrentXmlSrcFile() {
        return currentXmlSrcFile;
    }

    public void setCurrentXmlSrcFile(File currentXmlSrcFile) {
        this.currentXmlSrcFile = currentXmlSrcFile;
    }

    public ProcessLogger getProcessLogger() {
        return processLogger;
    }

    public void setProcessLogger(ProcessLogger processLogger) {
        this.processLogger = processLogger;
    }
    
    /**
     * TO DO - fix this hack to lookup and return langs available for transform
     * @param transformType
     * @return
     */
    public String [] getLangsForTransformType (String transformType) {
        String langs [] = new String[1];
        langs[0] = "en";
        return langs;
    }


    public File getCurrentOutputDir() {
        return currentOutputDir;
    }

    public void setCurrentOutputDir(File currentOutputDir) {
        this.currentOutputDir = currentOutputDir;
    }

    public String getCurrentLangCode() {
        return currentLangCode;
    }

    public void setCurrentLangCode(String currentLangCode) {
        this.currentLangCode = currentLangCode;
    }
    
    
    
    
    
    
    
    
    
    
    

}
