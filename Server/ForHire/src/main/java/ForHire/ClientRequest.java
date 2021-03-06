package ForHire;

import java.util.List;

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

import com.nicholas.jersey.common.Messages;
import com.nicholas.jersey.models.Client;
import com.nicholas.jersey.persistence.*;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

@Singleton
@Path("/clientRequest")
public class ClientRequest {
	
	@GET
	@Path("byRegionCategory")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response byRegionCategory(@QueryParam("region") String region, @QueryParam("category") String category) {
		
		try {
			List<Client> clients = HibernateDatabaseClientManager.getDefault().getClientsByRegionAndCategory(region, category);
			
			if(clients != null){
				return Response.ok(clients).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NO_ADS_FOUND + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
	
	
	@POST
	@Path("updateClient")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response updateClient(@FormParam("userToken") String userToken, @FormParam("phoneNumber") String phoneNumber, @FormParam("accountName") String accountName,
								@FormParam("description") String description, @FormParam("address") String address, 
								@FormParam("region") String region, @FormParam("accountType") String accountType) {
		
		try {			
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByUserToken(userToken);
			if(dataBaseClient != null){
				dataBaseClient.setPhoneNumber(phoneNumber);
				dataBaseClient.setAccountName(accountName);
				dataBaseClient.setDescription(description);
				dataBaseClient.setAddress(address);
				dataBaseClient.setRegion(region);
				dataBaseClient.setAccountType(accountType);
				HibernateDatabaseClientManager.getDefault().update(dataBaseClient);
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
	
	@POST
	@Path("updateCategories")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response updateCategories(@FormParam("userToken") String userToken, @FormParam("categories") String categories) {
		
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
			
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByUserToken(userToken);
			
			if(dataBaseClient != null){
				dataBaseClient.setCategories(catArray);
				HibernateDatabaseClientManager.getDefault().update(dataBaseClient);
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
			
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
	
	@POST
	@Path("updatePassword")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response updatePassword(@FormParam("userID") String userID, @FormParam("password") String password,
								   @FormParam("newPassword") String newPassword) {
		
		try {			
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByEmailAddressPasssword(userID, password);
			
			if(dataBaseClient != null){
				dataBaseClient.setPassword(newPassword);
				HibernateDatabaseClientManager.getDefault().update(dataBaseClient);
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
	
	@GET
	@Path("deleteAccount")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response updatePassword(@QueryParam("userToken") String userToken) {
		
		try {			
			Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByUserToken(userToken);
			
			if(dataBaseClient != null){
				HibernateDatabaseClientManager.getDefault().delete(dataBaseClient);
				return Response.ok(dataBaseClient).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
}
