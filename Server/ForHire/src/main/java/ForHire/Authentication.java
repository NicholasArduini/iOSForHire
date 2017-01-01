package ForHire;

import javax.inject.Singleton;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;
import javax.ws.rs.GET;
import javax.ws.rs.core.MediaType;

import com.nicholas.rest.encrypt.*;
import com.nicholas.jersey.common.Messages;
import com.nicholas.jersey.models.Client;
import com.nicholas.jersey.persistence.*;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

@Singleton
@Path("/authentication")
public class Authentication {
	private final String STATUS_RUNNING = "Encryption Running";
	
	@POST
	@Path("create")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	//@Consumes("application/x-www-form-urlencoded")
	public Response createUserQuery(@FormParam("userid") String userID, @FormParam("password") String password,
									@FormParam("phoneNumber") String phoneNumber, @FormParam("accountName") String accountName,
									@FormParam("description") String description, @FormParam("categories") String categories,
									@FormParam("address") String address, @FormParam("region") String region, @FormParam("accountType") String accountType) {
		
		JSONParser parser = new JSONParser();
		
		try {
			String[] catArray = new String[1];
			
			if(categories != null){
				Object obj = parser.parse(categories);
				JSONArray JSONCatArray = (JSONArray)obj;
				
				catArray = new String[JSONCatArray.size()];
				if(JSONCatArray != null){
					for(int i = 0; i < JSONCatArray.size(); i++){
						catArray[i] = (String)JSONCatArray.get(i);
					}
				}
			}
			
			Client newClient = new Client(userID.toLowerCase(), password, phoneNumber, accountName, description, catArray, address, region, accountType);
			String userToken = issueToken(userID);
			newClient.setUserToken(userToken);
			
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByEmailAddress(newClient.getEmailAddress());
			
			if(dataBaseClient == null){
				HibernateDatabaseClientManager.getDefault().add(newClient);
				return Response.ok(newClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.EMAIL_ALREADY_USED + "\" }").build();
			}
			
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}

	@GET
	@Path("login")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response loginUserQuery(@QueryParam("userid") String userID, @QueryParam("password") String password) {
		try {
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByEmailAddressPasssword(userID.toLowerCase(), password);
			
			if(dataBaseClient != null){
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}

	@GET
	@Path("validate")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response validateUserQuery(@QueryParam("userToken") String userToken) {
		try {
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByUserToken(userToken);
			
			if(dataBaseClient != null){
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}

	@SuppressWarnings("static-access")
	private String issueToken(String username) throws Exception {
		try {
			AESEncrypter encrypter = AESEncrypter.getDefaultEncrypter();
			return encrypter.encrypt(username);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Failed to create encrypted token");
		}
	}
	
	// This method is called if JSON is request
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String jsonStatus() {
	  	return "{ \"status\" : \"" + STATUS_RUNNING + "\" }";
    }

    // This method is called if HTML is request
    @GET
    @Produces(MediaType.TEXT_HTML)
    public String htmlStatus() {
      return "<html> " + "<title>" + STATUS_RUNNING + "</title>"
          + "<body><h1>" + STATUS_RUNNING  + " (HTML) </body></h1>" + "</html> ";
    }
}
