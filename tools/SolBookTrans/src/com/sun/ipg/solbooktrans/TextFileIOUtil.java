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

/**
 *
 * @author mb114135
 */
public class TextFileIOUtil {

        public static String ENCODING = "UTF-8";
	
	/**
	 * Sets the encoding for this class.
	 * @param newEncoding The String of the encoding to set
	 */
	public static void setEncoding (String newEncoding) {
		TextFileIOUtil.ENCODING = newEncoding;
	}
	
	

	/**
	 * Static method reads in the specified number of lines from the given file and returns them as a Vector
	 *
	 * @param inputFile		The file to be read
	 * @param numberOfLines The number of lines to read and return. If 0 is entered, all the lines are returned
	 * @return Vector containing the lines of text from the file
	 * @throws		An exception if the file cannot be read or contains no text
	 */
	public static Vector createTextVector (File inputFile, int numberOfLines) throws Exception {
		int lineCount = 0;
		BufferedReader br = null;
		FileInputStream fis = null;
		InputStreamReader isr = null;
		Vector textLines = null;
		try {
			fis = new FileInputStream(inputFile);
			isr = new InputStreamReader(fis, TextFileIOUtil.ENCODING);
			br = new BufferedReader(isr);
			textLines = new Vector();
			String currentLine = null;
			while ((currentLine = br.readLine()) != null) {
				lineCount++;
				textLines.addElement(currentLine);
				if ( (numberOfLines > 0) && (lineCount >= numberOfLines) ) {
					return textLines;
				} // if
			} // while
			if (textLines.size() == 0) {
				throw new Exception ("Error: No text could be read from file " + inputFile.getName());
			} // if
		} catch (Exception e) {
			String eMsg = e.getMessage();
			if (eMsg == null) eMsg = " ";
			throw new Exception (eMsg + " ERROR reading file.");
		} finally {
			if (br != null) br.close();
			if (isr != null) isr.close();
			if (fis != null) fis.close();
		} // try-catch-finally
		return textLines;
	} // createTextVector
	
	
	/**
	 * Static method reads in the lines from the given file and returns them as a String
	 *
	 * @param inputFile		The file to be read
	 * @return String containing the lines of text from the file
	 * @throws		An exception if the file cannot be read or contains no text
	 */
	public static String createTextString (File inputFile) throws Exception {
		if (! inputFile.exists()) throw new Exception("ERROR: Cannot find file: " + inputFile.getPath());
                BufferedReader br = null;
		FileInputStream fis = null;
		InputStreamReader isr = null;
		StringBuffer textLines = null;
		try {
			fis = new FileInputStream(inputFile);
			isr = new InputStreamReader(fis, TextFileIOUtil.ENCODING);
			br = new BufferedReader(isr);
			textLines = new StringBuffer();
			String currentLine = null;
			while ((currentLine = br.readLine()) != null) {
				textLines = textLines.append(currentLine);
				textLines = textLines.append("\r\n");
			} // while
			if (textLines.length() < 1) {
				throw new Exception ("Error: No text could be read from file " + inputFile.getName());
			} // if
		} catch (Exception e) {
			String eMsg = e.getMessage();
			if (eMsg == null) eMsg = " ";
			throw new Exception (eMsg + " ERROR reading file " + inputFile.getPath());
		} finally {
			if (br != null) br.close();
			if (isr != null) isr.close();
			if (fis != null) fis.close();
		} // try-catch-finally
		return textLines.toString();
	} // createTextString
  
  /**
   * Static method writes the given String to the given file
   *
   * @param outputFile The file to write to (create or overwrite)
   * @param doc The String to be written
   * @throws An Exception if anything happens
   */
   public static void writeTextString (File outputFile, String doc) throws Exception {
      FileOutputStream fos = null;
      OutputStreamWriter osw = null;
      BufferedWriter bw = null;
      PrintWriter pw = null;
      try {
          fos = new FileOutputStream(outputFile);
	  osw = new OutputStreamWriter(fos, TextFileIOUtil.ENCODING);
  	  bw = new BufferedWriter(osw);
          pw = new PrintWriter(bw);
          pw.print(doc);
          pw.close();
      } catch (Exception e) { 
          throw new Exception (e.getMessage() + " ERROR: Problem writing to file " + outputFile.getPath());
      } finally {
        if (pw != null) { pw.close(); }
        if (osw != null) { osw.close(); }
        if (fos != null) { fos.close(); }
      } // try-catch
    } // writeTextString
    
    
    /**
     * Static method appends the given String to the given file
     *
     * @param outputFile The file to write to (create or overwrite)
     * @param doc The String to be written
     * @throws An Exception if anything happens (such as if the file is not already present)
     */
     public static void appendTextString (File outputFile, String doc) throws Exception {
	     FileWriter fw = null;
	     BufferedWriter bw = null;
	     PrintWriter pw = null;
	     try {
		     fw = new FileWriter(outputFile, true);
		     bw = new BufferedWriter(fw);
		     pw = new PrintWriter(bw);
		     pw.print(doc);
		     pw.close();
	     } catch (Exception e) { 
		     throw new Exception (e.getMessage() + " ERROR: Problem writing to file " + outputFile.getPath());
	     } finally {
		     if (pw != null) { pw.close(); }
		     if (bw != null) { bw.close(); }
		     if (fw != null) { fw.close(); }
	     } // try-catch
     } // appendTextString
    
    
    /**
     * Converts the given String array into a single string delimited by spaces
     *
     * @param array The String [] to convert
     * @return A single String
     */
    public static String makeString (String [] array) {
	    StringBuffer buff = new StringBuffer();
	    for (int i=0; i<array.length; i++) {
		    buff.append(array[i]);
		    buff.append(" ");
	    } // for
	    return buff.toString();
    } // makeString
    
    
  
    /**
     * IO Utility method creates a BufferedReader for the given File
     * @param file The File
     * @return A BufferedReader for that file
     * @throws Exception if the File cannot be read
     */
    public static BufferedReader createReader (File file) throws Exception {
        try {
            FileInputStream fis = new FileInputStream(file);
            InputStreamReader isr = new InputStreamReader(fis, ENCODING);
            BufferedReader reader = new BufferedReader(isr);
            return reader;
        } catch (Exception e) {
            throw new Exception("ERROR cannot read file " + file.getPath());
        }
    }
    
    
    /**
     * Utility method creates a PrintWriter for the given File
     * @param file The File
     * @return A PrintWriter for the File
     * @throws Exception if the File cannot be written to
     */
    static PrintWriter createWriter (File file) throws Exception {
        try {
            FileOutputStream fos = new FileOutputStream(file);
            OutputStreamWriter osw = new OutputStreamWriter(fos, ENCODING);
            BufferedWriter bw = new BufferedWriter(osw);
            PrintWriter writer = new PrintWriter(bw);
            return writer;
        } catch (Exception e) {
            throw new Exception("ERROR cannot write to file " + file.getPath());
        }
    }
    
  
    /**
     *  Utility method for copying a text file. Note this will read and write the file
     *  in the currently defined encoding for this class (defaults to UTF-8 unless otherwise set).
     *  @param srcFile The File to copy
     *  @param destFile The File to copy to
     *  @throws Exception if it didn't work
     */
    public static void copyTextFile (File srcFile, File destFile) throws Exception {
        String content = TextFileIOUtil.createTextString(srcFile);
        TextFileIOUtil.writeTextString(destFile, content);
    }
    
    /**
     *  Utility method copies the given array of src files into the given dir.
     *  If the dir does not exist, it will be created. Can be bin or text files.
     *  Files will be copied over as binary, so no char encoding will take place.
     *  @param srcFiles The array of source files
     *  @param dir The destination directory to copy them to
     *  @throws Exception if a file cannot be found, a dir created, or a file copied
     */
    public static void copyFiles (File [] srcFiles, File destDir) throws Exception {
        for (int i=0; i<srcFiles.length; i++) {
            File destFile = new File(destDir, srcFiles[i].getName());
            TextFileIOUtil.copyFile(srcFiles[i], destFile);
        }
    }
    
    
    /**
     *  Utility method for copying a binary OR a text file. Will make any needed interim dirs.
     * @param srcFile The File to copy
     * @param destFile The File destination
     * @throws Exception if it didn't work
     */
      public static void copyFile (File sourceFile, File destFile) throws Exception {
            if (! sourceFile.isFile()) throw new Exception("ERROR NOT A FILE: " + sourceFile.getPath());
            if (! sourceFile.exists()) throw new Exception("ERROR: Cannot find file to copy: " + sourceFile.getPath());
            if (! sourceFile.canRead()) throw new Exception("ERROR: Cannot read file to copy: " + sourceFile.getPath());
            // First ensure all needed destination directories are present
            File destParent = new File(destFile.getParent());
            if (! destParent.exists()) {
                if (! destParent.mkdirs()) throw new Exception("ERROR: Cannot make needed dirs for file copy: " + destParent.getPath());
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
	}
      
      
    /**
     * Replaces the given findText in the given File with the given replaceText.
     * Does this by reading the given File into a String until the findText is encountered,
     * then replaces it and continues directly writing the rest of the file.
     * So this is very efficient when replacing near the beginning of the file, but much 
     * less efficient if replacements must be done towards the end of the file.
     * @param file The File to replace text in
     * @param findText The text to find
     * @param replaceText The text to replace the findText with
     * @throws Exception if the file could not be read or written to
     */
    public static void replaceTextInFile (File file, String findText, String replaceText) throws Exception {
        File tmpFile = new File(file.getParentFile(), file.getName() + "rplTmp");
        BufferedReader reader = TextFileIOUtil.createReader(file);
        PrintWriter writer = TextFileIOUtil.createWriter(tmpFile);
        StringBuffer lineBuffer = new StringBuffer();
        boolean didReplace = false;
        String line = null;
        while ((line = reader.readLine()) != null) {
            if (didReplace) {
                writer.println(line);
            } else {
                lineBuffer.append(line);
                lineBuffer.append("\r\n");
                String buffStr = lineBuffer.toString();
                if (buffStr.indexOf(findText) != -1) {
                    String preFound = buffStr.substring(0, buffStr.indexOf(findText));
                    String postFound = buffStr.substring(buffStr.indexOf(findText) + findText.length());
                    buffStr = preFound + replaceText + postFound;
                    writer.println(buffStr);
                    didReplace = true;
                    lineBuffer = null; // save memory
                    buffStr = ""; // save memory
                }
            }
        }
        reader.close();
        writer.close();
        file.delete();
        tmpFile.renameTo(file);
    }
      
      
    
    
}
