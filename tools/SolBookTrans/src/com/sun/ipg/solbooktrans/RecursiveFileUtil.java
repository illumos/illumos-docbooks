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

import java.util.*;
import java.io.*;
 
public class RecursiveFileUtil {
  
  
  /**
   * Gets a list of pathnames to each recursive file in the given source directory
   *
   * @param sourceDir The File of the source directory to examine
   * @return Vector of Files representing each file
   */     
   public static Vector recursiveList (File sourceDir) {
      Vector finalList = new Vector();
      String [] currNames = sourceDir.list();
      for (int i=0; i<currNames.length; i++) {
	      if (! currNames[i].equals("SCCS")) {
		      File currFile = new File(sourceDir,currNames[i]);
		      if ( (currFile.isFile()) && (RecursiveFileUtil.isFileValid(currFile)) ) {
			      finalList.addElement(currFile);
		      } else if ( (currFile.isDirectory()) && (RecursiveFileUtil.isFileValid(currFile)) ) {
			      Vector moreFiles = recursiveList(currFile);
			      for (int j=0; j<moreFiles.size(); j++) {
				      finalList.addElement((File)moreFiles.elementAt(j));
			      } // for
		      } // if
	      } // if
      } // for
      return finalList;
   } // recursiveList
   
   
   /**
    * Copies all of the files recursively present in the given source directory to the given destination directory
    *
    * @param sourceDir The File representing the directory to copy the files from
    * @param destDir The File representing the directory to copy the files to
    */
    public static void recursiveCopy (File sourceDir, File destDir) throws Exception {
        if (! sourceDir.isDirectory()) throw new Exception("ERROR NOT A DIR: " + sourceDir.getPath());
        // Make strings for the source and destination directory paths
      String sourcePath = sourceDir.getPath();
      int sourcePathLength = sourcePath.length();
      String destPath = destDir.getPath();
      // Get recursive list of files in sourceDir
      Vector sourceFiles = RecursiveFileUtil.recursiveList(sourceDir);
      // Copy each source on list to equivalent destination
      for (int i=0; i<sourceFiles.size(); i++) {
        File currSource = (File)sourceFiles.elementAt(i);
        String currPath = currSource.getPath();
        String newPath = currPath.substring(sourcePathLength);
        newPath = destPath + newPath;
        File currDest = new File(newPath);
        try {
          copyFile(currSource,currDest);
        } catch (Exception e) {
          throw new Exception (e.getMessage());
        } // try-catch
      } // for
    }// recursiveCopy
    
    
     /**
      * Finds the first recursive subdir which contains the given name in at least part of its name.
      * @param name The name String to match on the subdir name.
      * @param dir The directory to start the search in. Goes down until a null return is hit.
      * @param useStrictMatch Set to true to indicate that the name must be an exact match. False means if the dir name contains the param name then it matches.
      * @return The File dir whose name contains the given name param, or null.
      */
     public static File findNamedSubdir (String name, File dir, boolean useStrictMatch) {
         File [] kidFiles = dir.listFiles();
         ArrayList <File> dirsToCheck = new ArrayList();
         do {
             dirsToCheck.clear();
             for (int i=0; i<kidFiles.length; i++) {
                 if (kidFiles[i].isDirectory()) {
                     if ( (useStrictMatch) && (kidFiles[i].getName().equals(name)) ) return kidFiles[i];
                     if ( (! useStrictMatch) && (kidFiles[i].getName().indexOf(name) != -1) ) return kidFiles[i];
                     File [] grandKids = kidFiles[i].listFiles();
                     if (grandKids != null) dirsToCheck.addAll(Arrays.asList(grandKids));
                 }
             }
             // there were no matches in immediate children of current dir, now check next level
             // make the current dirsToCheck list into the new kidFiles array to check
             kidFiles = new File[dirsToCheck.size()];
             for (int j=0; j<dirsToCheck.size(); j++) {
                 kidFiles[j] = dirsToCheck.get(j);
             }
         } while (dirsToCheck.size() > 0);
         return null;
     }
    
    
    
    /**
    * Same as recursiveCopy, except won't overwrite existing files in the destination directory
    *
    * @param sourceDir The File representing the directory to copy the files from
    * @param destDir The File representing the directory to copy the files to
    */
    public static void recursiveCopyNoOverwrite (File sourceDir, File destDir) throws Exception {
      // Make strings for the source and destination directory paths
      String sourcePath = sourceDir.getPath();
      int sourcePathLength = sourcePath.length();
      String destPath = destDir.getPath();
      // Get recursive list of files in sourceDir
      Vector sourceFiles = RecursiveFileUtil.recursiveList(sourceDir);
      // Copy each source on list to equivalent destination
      for (int i=0; i<sourceFiles.size(); i++) {
        File currSource = (File)sourceFiles.elementAt(i);
        String currPath = currSource.getPath();
        String newPath = currPath.substring(sourcePathLength);
        newPath = destPath + newPath;
        File currDest = new File(newPath);
	if (! currDest.exists()) {
		try {
			copyFile(currSource,currDest);
		} catch (Exception e) {
			throw new Exception (e.getMessage());
		} // try-catch
	} // if
      } // for
    }// recursiveCopyNoOverwrite
    
    
    
    
    
    /**
    * Copies the source file to the destination file
    * Also creates any interim directories needed
    *
    * @param sourceFile The File to copy
    * @param destFile The new File
    * @throws Exception if files cannot be read or written to
    */
    public static void copyFile (File sourceFile, File destFile) throws Exception {
        if (! sourceFile.isFile()) throw new Exception("ERROR NOT A FILE: " + sourceFile.getPath());
        // First ensure all needed destination directories are present
      File destParent = new File(destFile.getParent());
      if (! destParent.exists()) {
        destParent.mkdirs();
      } // if
      // Now copy the file
  		FileInputStream from = null;
  		FileOutputStream to = null;
  		try {
  			from = new FileInputStream(sourceFile);
  			to = new FileOutputStream(destFile);
  			byte [] buffer = new byte[4096];
  			int bytes_read;
  			while ((bytes_read = from.read(buffer)) != -1) {
  				to.write(buffer,0,bytes_read);
  			} // while
  		} catch (Exception e) {
                    e.printStackTrace();
                    throw new Exception ("ERROR: Could not copy " + sourceFile.getPath() + " to " + destFile.getPath() + ". Details: " + e.getMessage());
  		} finally {
  			if (from != null) try { from.close(); } catch (IOException e) {;}
  			if (to != null) try { to.close(); } catch (IOException e) {;}
  		} // try-catch
	} // copyFile
	
	
	/**
	 * Recursively deletes the given directory and all its files and subdirectories<br>
	 * If a file is provided instead of a directory then the file is deleted.<br>
	 * Nothing happens if the file/directory provided does not exist (maybe because it was already deleted)
	 *
	 * @param dir The File for the directory to be deleted
	 * @throws Exception if items could not be deleted
	 */
	public static void recursiveDelete (File dir) throws Exception {
		if (! dir.exists()) return;
		if (! dir.isDirectory()) {
			if (! dir.delete()) throw new Exception("ERROR cannot delete file: " + dir.getPath());
			return;
		} // if
		File [] dirFiles = dir.listFiles();
		if (dirFiles.length == 0) {
			if (! dir.delete()) throw new Exception("ERROR cannot delete directory: " + dir.getPath());
		} else {
			for (int i=0; i<dirFiles.length; i++) {
				File currFile = (File)dirFiles[i];
				RecursiveFileUtil.recursiveDelete(currFile);
			} // for
			if (! dir.delete()) throw new Exception("ERROR cannot delete directory after removing subitems: " + dir.getPath());
		} // if
	} // recursiveDelete
	
	
	
	
	 /**
	  * Creates a Vector of Files for the given File.<br>
	  * The element at 0 is the File, at 1 is its parent, etc.<br>
	  * So the element with the highest index is the root directory
	  * 
	  * @param file The File to develop the Vector for
	  * @return A Vector of Files representing all the ancestor Files for the File
	  * @throws Exception if the File cannot be canonicized
	  */
	 public static Vector createPathVector (File file) throws Exception {
		 file = file.getCanonicalFile();
		 Vector pathVector = new Vector();
		 pathVector.addElement(file);
		 File parent = file.getParentFile();
		 while (parent != null) {
			 pathVector.addElement(parent);
			 parent = parent.getParentFile();
		 } // while
		 return pathVector;
	 } // createPathVector
	 
	 
	 /**
	  * Validates the given File to make sure that there are no obvious deformities in its path.
	  * Also invalidates certain known files that are never wanted (such as Thumbs.db, etc.)
	  * @param file The File to check
	  * @return true if the File's path is ok, false if it contains characters that should not be present in a File path
	  */
	 public static boolean isFileValid (File file) {
		 String [] deformedChars = new String [] {"\r", "\n", "]", "[", "~"};
		 String filePath = file.getPath();
		 for (int i=0; i<deformedChars.length; i++) {
			 if (filePath.indexOf(deformedChars[i]) != -1) return false;
		 } // for
		 String [] badNames = new String [] {"Thumbs.db"};
		 for (int j=0; j<badNames.length; j++) {
			 if (file.getName().equals(badNames[j])) return false;
		 } // for
		 return true;
	 } // isFileValid
         
         
         	 /**
	  * Calculates the relative path from the given source file to the given destination file.<br>
	  * The path is such that it would be an effective href for launching the destination 
	  * file when placed in the source file (but neither file needs to be HTML).
	  *
	  * @param srcFile The source File
	  * @param destFile The destination File
	  * @return String of the relative path from the source to the destination
	  * @throws Exception if paths cannot be calculated due to permission or security restrictions
	  */
	 public static String calcRelativePath (File srcFile, File destFile) throws Exception {
		 // get a reverse canonical Vector of parent dirs for each
		 Vector srcVector = createPathVector(srcFile);
		 Vector destVector = createPathVector(destFile);
		 // loop thru src dirs until one is found that is present in the dest dir
		 int srcIndexMatch = -1;
		 int destIndexMatch = -1;
		 for (int i=0; i<srcVector.size(); i++) {
			 File currSrc = (File)srcVector.elementAt(i);
			 int destSpot = destVector.indexOf(currSrc);
			 if (destSpot > -1) {
				 srcIndexMatch = i;
				 destIndexMatch = destSpot;
				 break;
			 } // if
		 } // for
		 // number of hops is srcIndexMatch -1
		 String hopStr = "";
		 for (int j=0; j<srcIndexMatch - 1; j++) {
			 hopStr = hopStr + "../";
		 } // for
		 // rest of path is constructed from destIndexMatch -1 back to index 0
		 String downPath = "";
		 for (int k=destIndexMatch - 1; k>=0; k--) {
			 File currFile = (File)destVector.elementAt(k);
			 String currName = currFile.getName();
			 downPath = downPath + currName + "/";
		 } // for
		 downPath = downPath.substring(0, downPath.length() - 1);
		 // now combine paths
		 String relPath = hopStr + downPath;
		 return relPath;
	 } // calcRelativePath
         
        
}
