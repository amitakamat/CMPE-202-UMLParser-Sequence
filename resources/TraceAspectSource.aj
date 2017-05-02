/**
 * @author Amita Vasudev Kamat
 * 
 * CMPE - 202 - Personal Project - Sequence Diagram
 *  Spring 2017
 */

import org.aspectj.lang.JoinPoint;
import java.lang.Object;
import java.util.Stack;
import java.util.ArrayList;
import org.aspectj.lang.reflect.MethodSignature;
import java.lang.reflect.Method;

/**
 * 
 * Aspect for tracing source program
 */
public aspect TraceAspectSource {
    private int callDepth;
    private int count = 0;
    boolean isConst = false;
    String currentParticipant = "Main";
    Stack methodStack = new Stack();

	pointcut traced() : !within(TraceAspectSource) && execution(* *.*(..)) ;

	before() : traced() {
		generateGrammarFromTrace("Before", thisJoinPoint);
		callDepth++;
	}

	after() : traced() {
		callDepth--;
		generateGrammarFromTrace("After", thisJoinPoint);
	}

	// Uncomment code for getting contructors in trace
	/*pointcut constTrace() : execution(*.new(..)) && !within(TraceAspectSource);

    before() : constTrace() {
    	isConst = true;
    	print("Before", thisJoinPoint);
		callDepth++;
		isConst = false;
    }
    
    after() : constTrace() {
    	isConst = true;
    	callDepth--;
		print("After", thisJoinPoint);
		isConst = false;
    }*/

	
	/**
	 * Method to trace the program and generate grammar from the trace.
	 * @param sourceFolder
	 * @return List of the names of java files in the source folder
	 */
	private void generateGrammarFromTrace(String prefix, JoinPoint m) { 
		if(methodStack.empty()){
			methodStack.push("Main");
		}
		if (m.getSignature().toString().toLowerCase().indexOf("main.main") == -1 ) {
				if(prefix == "Before"){
					if(m.getTarget() != null){
						Method method = ((MethodSignature) m.getSignature()).getMethod();
						String returnType = method.getReturnType().getName().toString().replace("java.lang.","");
						String targetParticipant = m.getTarget().toString();// + ":" + m.getTarget().getClass().getName();
						System.out.println("Target is " + m.getTarget());
						String parameters = "";
						for (int i=0; i<m.getArgs().length; i++)
						{
							Object obj = m.getArgs()[i];
							if(obj != null){
								if(i == m.getArgs().length - 1)
								{
									parameters += obj.toString() + " : " + obj.getClass().getName().replace("java.lang.", "");
								}
								else
								{
									parameters += obj.toString()  + " : " + obj.getClass().getName().replace("java.lang.", "") + ", ";
								}
							}
						}
						String methodName = String.format("%s(%s) : %s",method.getName() , parameters , returnType);
						System.out.println(String.format("%s -> %s : %s", methodStack.peek().toString(), targetParticipant, methodName));
						methodStack.push(targetParticipant);
						System.out.println(String.format("activate %s", targetParticipant));
					}
				}
				else{
					String sourceParticipant = methodStack.pop().toString();
					System.out.println(sourceParticipant + " : " + methodStack.peek().toString());
					if(!sourceParticipant.equals(methodStack.peek().toString())){
						System.out.println(sourceParticipant + " --> " + methodStack.peek().toString());
					}
					System.out.println(String.format("deactivate %s", sourceParticipant));
				}
		}
	}
}

