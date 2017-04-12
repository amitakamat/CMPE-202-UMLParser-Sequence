/**
 * 


/**
 * @author amita
 *
 */
import org.aspectj.lang.JoinPoint;
/*import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;*/

public aspect TraceSequence {
	private int callDepth;

	//pointcut traced() : !within(TraceSequence) && execution(public * *.*(..)) ;
	pointcut traced() : !within(TraceSequence) && execution(* *.*(..)) ;

	before() : traced() {
		print("Before", thisJoinPoint);
		callDepth++;
	}

	after() : traced() {
		callDepth--;
		print("After", thisJoinPoint);
	}

	private void print(String prefix, JoinPoint m) {
		for (int i = 0; i < callDepth; i++) {
			System.out.print(".");
		} 
		System.out.print(prefix + ": " + m.getKind() + " " + m.getSignature() );
		System.out.print( " args : [ " ) ;
		for (Object obj : m.getArgs())
		{
			System.out.print( obj + " " ) ;
		}
		System.out.println("]") ;
}
}
