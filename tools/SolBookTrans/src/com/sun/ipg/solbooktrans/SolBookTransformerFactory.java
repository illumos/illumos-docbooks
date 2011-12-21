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
import java.util.ArrayList;
import java.util.Iterator;

/**
 * This singleton class is used to create new SolBookTransformer objects.
 * It stores a reference to each SolBookTransformer it has created, and can be accessed to 
 * provide references to those objects.
 * 
 * Note that right now this is only being used to create and deliver a single 
 * SolBookTransformer at a time, because that is all that will be done in NetBeans right now.
 * But if it is later desired to run multiple transforms at a time, then they can be kept 
 * track of in this class.
 *
 * @author Mark Brundege
 */
public class SolBookTransformerFactory {
    
    static SolBookTransformerFactory instance = null;
    
    
    private ArrayList <SolBookTransformer> transformerList;
    
    // the resources directory
    private File resDir;
    
    /**
     * Factory method for obtaining instance
     * @return The single instance of this
     */
    public static SolBookTransformerFactory getInstance() {
        if (SolBookTransformerFactory.instance == null) {
            SolBookTransformerFactory transFactory = new SolBookTransformerFactory();
            SolBookTransformerFactory.instance = transFactory;
        }
        return SolBookTransformerFactory.instance;
    }
    
    /**
     * Constructor
     */
    private SolBookTransformerFactory () {
        this.transformerList = new ArrayList();
    }
    
    /**
     * Generates a SolBookTransformer for an upcoming transformation.
     * It has no data in it yet.
     * @return A new empty SolBookTransformer
     */
    public SolBookTransformer createSolBookTransformer () {
        SolBookTransformer solBookTransformer = new SolBookTransformer(resDir);
        transformerList.add(solBookTransformer);
        return solBookTransformer;
    }
    
    /**
     *  Returns a reference to the most recently created SolBookTransformer
     * @return The most recently created (and not canceled) SolBookTransformer, or null if none
     */
    public SolBookTransformer getMostRecentTransformer () {
        if (transformerList.isEmpty()) return null;
        return transformerList.get(transformerList.size()-1);
    }
    
    /**
     * Deletes the given SolBookTransformer from the factory's list.
     * If not in the list, fails silently.
     * SBTs should not be removed from the list when they complete; the reason 
     * to remove them from the list is when the transformation is canceled prior 
     * to being run.
     * @param The SolBookTransformer to remove
     */
    public void deleteSolBookTransformer (SolBookTransformer solBookTransformer) {
        this.transformerList.remove(solBookTransformer);
    }
    
    
    /**
     * Returns the total list of SolBookTransformers created and not deleted.
     * @return the transformerList
     */
    public ArrayList<SolBookTransformer> getTotalTransformerList () {
        return this.transformerList;
    }
    
    /**
     * Returns a list of those transformers which have already been run.
     * The most recently created ones are at the back of the list.
     * @return ArrayList of SolBookTransformers which have already run.
     */
    public ArrayList<SolBookTransformer> getPastTransformers () {
        ArrayList <SolBookTransformer> pastList = new ArrayList();
        Iterator <SolBookTransformer> listIter  = this.transformerList.iterator();
        while (listIter.hasNext()) {
            SolBookTransformer currTrans = listIter.next();
            if (currTrans.hasTransformed()) pastList.add(currTrans);
        }
        return pastList;
    }
    
    /**
     * Returns a list of those transformers which have been created but not yet run.
     * The most recently created ones are at the back of the list.
     * @return ArrayList of SolBookTransformers which have not yet been run.
     */
    public ArrayList<SolBookTransformer> getFutureTransformers () {
        ArrayList <SolBookTransformer> futureList = new ArrayList();
        Iterator <SolBookTransformer> listIter  = this.transformerList.iterator();
        while (listIter.hasNext()) {
            SolBookTransformer currTrans = listIter.next();
            if ( (! currTrans.hasTransformed()) && (! currTrans.isTransforming()) )  futureList.add(currTrans);
        }
        return futureList;
    }
    
    /**
     * Returns a list of those transformers which are currently running.
     * The most recently created ones are at the back of the list.
     * @return ArrayList of SolBookTransformers which are currently running.
     */
    public ArrayList<SolBookTransformer> getCurrentTransformers () {
        ArrayList <SolBookTransformer> currentList = new ArrayList();
        Iterator <SolBookTransformer> listIter  = this.transformerList.iterator();
        while (listIter.hasNext()) {
            SolBookTransformer currTrans = listIter.next();
            if (currTrans.isTransforming()) currentList.add(currTrans);
        }
        return currentList;
    }

    public File getResDir() {
        return resDir;
    }

    public void setResDir(File resDir) {
        this.resDir = resDir;
    }
    
    
    
    
    
    

}
