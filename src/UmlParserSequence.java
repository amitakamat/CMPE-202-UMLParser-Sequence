/**
 * @author Amita Vasudev Kamat
 * 
 * CMPE - 202 - Personal Project - Sequence Diagram
 *  Spring 2017
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import net.sourceforge.plantuml.SourceStringReader;

/**
 * 
 * Class for generating UML sequence diagram from java code
 */

public class UmlParserSequence {
	private static File ClassDir;
	private static String grammar = "@startuml\n";
	private static String outputFileName;

	public static void main(String[] args) throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, IllegalArgumentException, InvocationTargetException, MalformedURLException {
		// TODO Auto-generated method stub

		//Check for input arguments
				if(args.length == 0)
					System.out.println("Input Invalid. Please provide source code folder path.");

				else if(args.length > 2)
					System.out.println("Input Invalid. Too many input arguments.");
				
				else
				{
					try{
						String sourceFolder = args[0];
						
						if(args.length == 1)
						{
							outputFileName = "OutputSequenceDiagram.png";
						}
						else
						{
							outputFileName = args[1];
						}
						
						ClassDir = new File(sourceFolder);
						ArrayList<String> sourceCodeFiles = getJavaSourceFiles(sourceFolder);
						if(sourceCodeFiles.size() == 0)
						{
							System.out.println("No java files found in the source folder.");
						}
						else
						{
							injectAspect(sourceFolder);
							runProgram(sourceFolder);
							grammar += "@enduml";
							System.out.println("Grammar: " + grammar);
							String outputFile = "../Output-Diagrams/" + outputFileName;
							System.out.println("Creating sequence diagram....");
							try{
								SourceStringReader grammarReader = new SourceStringReader(grammar);
								FileOutputStream outputStream = new FileOutputStream(outputFile);
								grammarReader.generateImage(outputStream);
								System.out.println("Sequence diagram created successfully....");
							}
							catch(Exception e){
								System.out.println("Sequence diagram creation failed....");
								System.out.println(e.getMessage());
							}
						}
					}
					catch(Exception e)
					{
						System.out.println(e.getMessage());
					}
				}
	}
	
	/**
	 * Method to retrieve all the java files from the source folder
	 * @param sourceFolder
	 * @return List of the names of java files in the source folder
	 */
	private static ArrayList<String> getJavaSourceFiles(String sourceFolder){
		ArrayList<String> javaFiles = new ArrayList<String>();
		
		try
		{		
			File sourceDirectory = new File(sourceFolder);
			
			//Check if source folder provided in input exists t the given path
			if(sourceDirectory.isDirectory())
			{
		
			  for (File file : sourceDirectory.listFiles()) 
			  {
				  if (file.getName().endsWith((".java"))) 
				  {
			    	javaFiles.add(file.getName());
				  }
			  }
			}
			else
			{
				System.out.println("Source Directory not found. Please ensure the path is correct and try again.");
			}
			
		}
		catch(Exception e)
		{
		  System.out.println(e.getMessage());
		}
		return javaFiles;

	}
	
	/**
	 * Method to compile and run the source code
	 * @param path path of source folder
	 */
	private static void runProgram(String path){
		Runtime rt = Runtime.getRuntime();
		String compileCommand = "ajc -1.5 -classpath .:aspectjrt.jar *.java *.aj";
		String runCommand = "java -classpath .:aspectjrt.jar Main";
	    String line;
		try{
			System.out.println("Attempting source program compilation...");
			Process p = rt.exec(compileCommand, null, new File(path));
			p.waitFor();
			System.out.println("Program compiled properly");

			System.out.println("Attempting source program execution...");
			p = rt.exec(runCommand, null, new File(path));
			p.waitFor();
			System.out.println("Program execution stdout: ");

			BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
			while ((line = input.readLine()) != null) {
			    System.out.println(line);
			    generateGrammar(line);
			}
			System.out.println("Program execution stderr:");

			BufferedReader error = new BufferedReader(new InputStreamReader(p.getErrorStream()));
			while ((line = error.readLine()) != null) {
				System.out.println(line);
			}

		  input.close();
		  error.close();
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
	 }
	 
	/**
	 * Method to inject aspect and dependency jar in source code
	 * @param path path of source folder
	 */
	 private static void injectAspect(String path){
		 File[] source = {new File("../resources/TraceAspectSource.aj"),new File("../resources/aspectjrt.jar")};
         File[] dest = {new File(path + "/TraceAspectSource.aj"), new File(path + "/aspectjrt.jar")};
		 try{
			 for(int i=0; i<source.length; i++){
				 InputStream is = null;
				 OutputStream os = null;
				 try {
			        is = new FileInputStream(source[i]);
			        os = new FileOutputStream(dest[i]);
			        byte[] buffer = new byte[1024];
			        int length;
			        while ((length = is.read(buffer)) > 0) {
			            os.write(buffer, 0, length);
			        }
				 } 
				 finally {
			        is.close();
			        os.close();
			     }
			 }
		 }
		 catch(Exception ex){
				System.out.println(ex.getMessage());
		}
	 }
	 
	/**
	 * Method to filter grammar based on trace output of source code
	 * @param trace trace of source code
	 */
	 private static void generateGrammar(String trace){
		 try{
		 	if(trace.contains("->") || trace.contains("-->") || trace.contains("activate") || trace.contains("deactivate"))
			 {
				 grammar += trace + "\n";
			 }
		 }
		 catch(Exception ex){
				System.out.println(ex.getMessage());
		}
	 }
}
