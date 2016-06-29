import java.io.PrintStream;


/*
 * Two interfaces, two overloaded run() methods, and two run() calls, passing 
 * different data types to each.
 *
 * Works as expected.
 */


interface Executable {
    int execute( int a );
}
interface StringExecutable {
    String execute( String a );
}


class Runner {
    public void run(Executable e) {
        int retval = e.execute( 7 );
        System.out.println( "Int retval is: " + retval );
    }

    public void run(StringExecutable e) {
        String retval = e.execute( "Hello" );
        System.out.println( "String retval is: " + retval );
    }
}


class AmbigParamResolution {

    public static void main( String[] args ) {
        Runner runner = new Runner();

        runner.run( (int a) -> {
            System.out.println("Calling our runner with an int");
            return 7 + a;
        });

        runner.run( (String a) -> {
            System.out.println("Calling our runner with a string");
            return a + " foobar";
        });

    }
}

