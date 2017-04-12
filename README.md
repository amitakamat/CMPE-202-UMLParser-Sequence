# CMPE-202-UMLParser-Sequence

Steps to run the program:

1. Navigate to src folder.
~/GitHub 202/CMPE-202-UMLParser-Sequence/src

2. Compile the files. Make sure the dependencies are in the path provided.
ajc -1.5 -classpath ".:../../../Dependency/javaparser-core-3.1.0.jar:../../../Dependency/aspectjrt.jar" *.java *.aj

3. Run the java file.
java -classpath ".:../../../Dependency/javaparser-core-3.1.0.jar:../../../Dependency/aspectjrt.jar" UmlParserSequence

