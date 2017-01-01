package ForHire;

import java.util.List;

import javax.inject.Singleton;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.core.MediaType;

import com.nicholas.jersey.common.Messages;
import com.nicholas.jersey.models.Client;
import com.nicholas.jersey.models.Review;
import com.nicholas.jersey.persistence.*;

@Singleton
@Path("/reviews")
public class Reviews {

	@POST
	@Path("postReview")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response postReview(@FormParam("priceRating") String priceRating,
							   @FormParam("reliabilityRating") String reliabilityRating,
							   @FormParam("qualityRating") String qualityRating, @FormParam("reviewText") String reviewText,
							   @FormParam("category") String category, @FormParam("writtenByUser") String writtenByUser,
							   @FormParam("writtenForUser") String writtenForUser) {
		try {
			Client writtenForClient = HibernateDatabaseClientManager.getDefault()
					.getClientByEmailAddress(writtenForUser);

			if (writtenForClient != null) {
				Review existingReview = HibernateDatabaseReviewManager.getDefault()
						.getReviewsForUserByUser(writtenForUser, writtenByUser);

				if (existingReview == null) {
					Review newReview = new Review(priceRating, reliabilityRating, qualityRating, reviewText, category,
							writtenByUser, writtenForUser);
					writtenForClient.addReview(newReview);

					int numReviews = writtenForClient.getNumReviews() + 1;
					double priceR = (writtenForClient.getPriceRating() + Double.parseDouble(priceRating));
					double reliabilityR = (writtenForClient.getReliabilityRating()
							+ Double.parseDouble(reliabilityRating));
					double qualityR = (writtenForClient.getQualityRating() + Double.parseDouble(qualityRating));
					String totalRating = String.valueOf(priceR + reliabilityR + qualityR);

					writtenForClient.setNumReviews(numReviews);
					writtenForClient.setPriceRating(priceR);
					writtenForClient.setReliabilityRating(reliabilityR);
					writtenForClient.setQualityRating(qualityR);
					writtenForClient.setRating(totalRating);

					HibernateDatabaseClientManager.getDefault().update(writtenForClient);
					return Response.ok(newReview).build();
				} else {
					return Response.ok("{ \"message\" : \"" + Messages.REVIEW_ALREADY_EXISTS + "\" }").build();
				}
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}

	@GET
	@Path("getReviews")
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	// @Consumes("application/x-www-form-urlencoded")
	public Response getReviews(@QueryParam("writtenForUser") String writtenForUser) {
		try {
			List<Review> reviewsForUser = HibernateDatabaseReviewManager.getDefault().getReviewsForUser(writtenForUser);

			if (reviewsForUser != null) {
				return Response.ok(reviewsForUser).build();
			} else {
				return Response.ok("{ \"message\" : \"" + Messages.NOT_VALID_USER + "\" }").build();
			}
		} catch (Exception exception) {
			return Response.ok(exception.getLocalizedMessage()).build();
		}
	}
}
