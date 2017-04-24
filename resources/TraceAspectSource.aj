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
		//for (int i = 0; i < callDepth; i++) {
			//System.out.print(".");
		//} 
		if(methodStack.empty()){
			methodStack.push("Main");
		}
		if (m.getSignature().toString().toLowerCase().indexOf("main.main") == -1 ) {
			/*if(isConst){
				if(prefix == "Before"){
					/*if(methodStack.peek().toString().equals("Main")){
						System.out.println("activate Main");
					}
					if(m.getTarget() != null){
						System.out.println("Current object: " + m.getTarget().getClass().getName());
				
						String method = m.getSignature().toString();
						//String targetParticipant = ":" + m.getTarget().getClass().getName();
						String targetParticipant = m.getTarget().getClass().getName();
						System.out.println(methodStack.peek().toString() + " -> " + targetParticipant + " : <<create>>\n" );
						methodStack.push(targetParticipant);
						System.out.println(String.format("activate %s", targetParticipant));
					}
					/*System.out.println(method.indexOf("("));
					System.out.println(method.split("("));
					String targetParticipant = m.toString().split("(")[1];
					System.out.println(methodStack.peek().toString() + " -> " + targetParticipant + " : <<create>>\n" );
					methodStack.push(targetParticipant);
				}
				else{
					String sourceParticipant = methodStack.pop().toString();
					//System.out.println(sourceParticipant + " : " + methodStack.peek().toString());
					if(!sourceParticipant.equals(methodStack.peek().toString())){
						System.out.println(sourceParticipant + " --> " + methodStack.peek().toString());
						//System.out.println(String.format("deactivate %s", sourceParticipant));
					}
					System.out.println(String.format("deactivate %s", sourceParticipant));
					/*if(methodStack.peek().toString().equals("Main")){
						System.out.println("deactivate Main");
					}
				}
				
			}
			else{*/
				//System.out.println(prefix);
				if(prefix == "Before"){
					/*if(methodStack.peek().toString().equals("Main")){
						System.out.println("activate Main");
					}*/
					if(m.getTarget() != null){
						Method method = ((MethodSignature) m.getSignature()).getMethod();
						String returnType = method.getReturnType().getName().toString().replace("java.lang.","");
						//String targetParticipant = ":" + m.getTarget().getClass().getName();
						String targetParticipant = m.getTarget().getClass().getName();
						String methodName = method.getName() + "():" + returnType;
						/*String fullMethod = m.toString().split("(")[1];
						String[] type = fullMethod.split(" ");
						String returnType = type[0];
						String[] method = type[1].split(".");
						String targetParticipant = method[0];
						//MethodSignature ms = m.getSignature();
						//Method method = ms.getMethod();
						System.out.println(m.toString());//.toString().split("."));
						//String targetParticipant = "";// = method.[0];*/
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

