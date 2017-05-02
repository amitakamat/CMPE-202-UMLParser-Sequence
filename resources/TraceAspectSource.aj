import org.aspectj.lang.JoinPoint;
import java.lang.Object;
import java.util.Stack;
import java.util.ArrayList;
import org.aspectj.lang.reflect.MethodSignature;
import java.lang.reflect.Method;

public aspect TraceAspectSource {
    private int callDepth;
    private int count = 0;
    boolean isConst = false;
    String currentParticipant = "Main";
    Stack methodStack = new Stack();

	//pointcut traced() : !within(TraceAspectSource) && execution(public * *.*(..)) ;
	pointcut traced() : !within(TraceAspectSource) && execution(* *.*(..)) ;

	before() : traced() {
		print("Before", thisJoinPoint);
		callDepth++;
	}

	after() : traced() {
		callDepth--;
		print("After", thisJoinPoint);
	}

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

	private void print(String prefix, JoinPoint m) { 
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
						//System.out.println( + " -> " + targetParticipant + " : " + methodName + "()\n" );
						methodStack.push(targetParticipant);
						System.out.println(String.format("activate %s", targetParticipant));
					}
				}
				else{
					String sourceParticipant = methodStack.pop().toString();
					System.out.println(sourceParticipant + " : " + methodStack.peek().toString());
					if(!sourceParticipant.equals(methodStack.peek().toString())){
						System.out.println(sourceParticipant + " --> " + methodStack.peek().toString());
						//System.out.println(String.format("deactivate %s", sourceParticipant));
					}
					System.out.println(String.format("deactivate %s", sourceParticipant));
					/*if(methodStack.peek().toString().equals("Main")){
						System.out.println("deactivate Main");
					}*/
				}
				/*System.out.println("Method:" + m.getSignature());
				//System.out.println() ;
				if(m.getArgs().length > 0){
					System.out.println("BeginArguments:");
				}
				for (Object obj : m.getArgs())
				{
					System.out.println( obj.toString().split("@")[0]) ;
				}
				if(m.getArgs().length > 0){
					System.out.println("EndArguments:");
				}*/
			//}
			//System.out.println();
		}
	}
}

