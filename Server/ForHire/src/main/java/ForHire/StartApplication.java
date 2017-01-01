package ForHire;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import java.util.HashSet;
import java.util.Set;

@ApplicationPath("/")
public class StartApplication extends Application {
    @Override
    public Set<Class<?>> getClasses() {
    	
    	final Set<Class<?>> classes = new HashSet<Class<?>>();
        classes.add(Authentication.class);
        classes.add(ClientRequest.class);
        classes.add(Reviews.class);
        return classes;
    }
}

