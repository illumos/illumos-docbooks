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
import java.util.HashMap;

/**
 * Holds the data for a single SolBook XML transformation.
 * One of these can be provided to SolBookTrans to provide the specs for a transformation
 * @author Mark Brundege
 */
public class SolBookTransType {
    
    
    private String transName;
    private String transDescription;
    private String xsltFileName;
    private String launchFileName;
    private String transformEngine;
    // the default output parameters are outputDir, langCode, and currentDate
    private boolean useDefaultTransParams;
    // map of parameter names and values to set on the transformation engine - the XSLT stylesheets should be able to receive these parameters
    // this is where different or additional parameters may be set besides the defaults
    private HashMap <String, String> parameterMap;
    // list of DTD files or directories which should be confirmed as present in the source directories.
    private String [] dtdNames;
    // the map below maps file paths to be copied as keys to paths to copy to as values
    // key paths are relative to XML source files, value paths are relative to output directory
    // example: figures=figures or media/images=images or css=css
    private HashMap <String, String> dirsToCopyMap;
    // the map below maps individual files to be copied as keys to the paths to the output dirs as values
    // use an empty string to indicate that a file should be copied into the output root
    // example: style.css="" or style.css=css
    private HashMap <String, String> filesToCopyMap;
    // the category of this transform, such as XML or HTML
    private String category;
    
    
    /**
     *  Provide name, desc, and xsltFile for constructor
     * @param category The category of this transform, such as XML or HTML - defined as static Strings in SolBookTransTypeFactory
     * @param transName The publicly viewable name of this transformation
     * @param transDescription The description of the transformation
     * @param xsltFileName The name of the top level XSLT file
     * @param launchFileName The String of the launch file for the transformation output
     * @param transformEngine - String should be one of SolBookTransformer.ENGINE_TYPES (SAX or DOM)
     */
    public SolBookTransType (String category, String transName, String transDescription, String xsltFileName, String launchFileName, String transformEngine) {
        this.category = category;
        this.transName = transName;
        this.transDescription = transDescription;
        this.xsltFileName = xsltFileName;
        this.launchFileName = launchFileName;
        this.transformEngine = transformEngine;
    }

    public String getTransName() {
        return transName;
    }

    public String getTransDescription() {
        return transDescription;
    }

    public File getXsltFile(File resDir) {
        return new File(resDir, xsltFileName);
    }

    public HashMap<String, String> getDirsToCopyMap() {
        return dirsToCopyMap;
    }

    public void setDirsToCopyMap(HashMap<String, String> dirsToCopyMap) {
        this.dirsToCopyMap = dirsToCopyMap;
    }

    public HashMap<String, String> getFilesToCopyMap() {
        return filesToCopyMap;
    }

    public void setFilesToCopyMap(HashMap<String, String> filesToCopyMap) {
        this.filesToCopyMap = filesToCopyMap;
    }

    public String getLaunchFileName() {
        return launchFileName;
    }

    public void setLaunchFileName(String launchFileName) {
        this.launchFileName = launchFileName;
    }

    public String[] getDtdNames() {
        return dtdNames;
    }

    public void setDtdNames(String[] dtdNames) {
        this.dtdNames = dtdNames;
    }

    public String getTransformEngine() {
        return transformEngine;
    }

    public HashMap getParameterMap() {
        return parameterMap;
    }

    public void setParameterMap(HashMap parameterMap) {
        this.parameterMap = parameterMap;
    }

    
    public boolean getUseDefaultTransParams() {
        return useDefaultTransParams;
    }

    public void setUseDefaultTransParams(boolean useDefaultTransParams) {
        this.useDefaultTransParams = useDefaultTransParams;
    }

    public String getCategory() {
        return category;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
