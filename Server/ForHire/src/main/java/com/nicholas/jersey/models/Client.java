package com.nicholas.jersey.models;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.nicholas.jersey.common.Messages;
 
/* 
 * To use //@GeneratedValue(strategy=GenerationType.IDENTITY)
 * then private static final String CREATE_TABLE_SQL = "create table " + CLIENT_TABLE_NAME + "(CLIENT_ID_PRIMARY_KEY int primary key not null AUTO_INCREMENT,"
 * and id field type must be long not String	
 */
@Entity
@Table(name="CLIENT")
public class Client {
	@Id
	@GeneratedValue(generator = "uuid")
	@GenericGenerator(name="uuid", strategy="uuid2")
	@Column(name="CLIENT_ID_PRIMARY_KEY")
	private String userIdPrimarKey;
	
	@Column(name="EMAIL_ADDRESS")
	private String emailAddress;

	@Column(name="USER_TOKEN")
	private String userToken;

	@JsonIgnore
	@Column(name="PASSWORD")
	private String password;
	
	@Column(name="PHONE_NUMBER")
	private String phoneNumber;
	
	@Column(name="ACCOUNT_NAME")
	private String accountName;
	
	@Column(name="DESCRIPTION")
	private String description;
	
	@Column(name="CATEGORIES")
	private String[] categories = new String[300];
	
	@Column(name="ADDRESS")
	private String address;
	
	@Column(name="REGION")
	private String region;
	
	@Column(name="RATING")
	private String rating;
	
	@Column(name="ACCOUNT_TYPE")
	private String accountType;
	
	@Column(name="PRICE_RATING")
	private double priceRating;
	
	@Column(name="RELIABILITY_RATING")
	private double reliabilityRating;
	
	@Column(name="QUALITY_RATING")
	private double qualityRating;
	
	@Column(name="NUM_REVIEWS")
	private int numReviews;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="CLIENT_ID_FK")
	private List<Review> reviews;
	
	public String toString() {
		return getPhoneNumber();
	}
	
	public Client() {
		setEmailAddress(Messages.UNKNOWN);
		setPassword(Messages.UNKNOWN);
		setUserToken(Messages.UNKNOWN);
		setPhoneNumber(Messages.UNKNOWN);
		setAccountName(Messages.UNKNOWN);
		setDescription(Messages.UNKNOWN);
		setAddress(Messages.UNKNOWN);
		setRegion(Messages.UNKNOWN);
		setRating(Messages.UNKNOWN);
		setPriceRating(0.0);
		setReliabilityRating(0.0);
		setQualityRating(0.0);
		setNumReviews(0);
		setAccountType(Messages.UNKNOWN);
		setReviews(new ArrayList<Review>());
	}
	
	public Client(String email, String password, String phoneNumber, String accountName, String description, String[] categories, String address, String region, String accountType) {
		setEmailAddress(email);
		setPassword(password);
		setUserToken(Messages.UNKNOWN);
		setPhoneNumber(phoneNumber);
		setAccountName(accountName);
		setDescription(description);
		setCategories(categories);
		setAddress(address);
		setRegion(region);
		setRating(Messages.UNKNOWN);
		setPriceRating(0.0);
		setReliabilityRating(0.0);
		setQualityRating(0.0);
		setNumReviews(0);
		setAccountType(accountType);
		setReviews(new ArrayList<Review>());
	}

	public boolean equals(Client client) {
		return getClientIdPrimarKey() == (client.getClientIdPrimarKey());
	}

	public String getClientIdPrimarKey() {
		return userIdPrimarKey;
	}


	public void setClientIdPrimarKey(String clientIdPrimarKey) {
		this.userIdPrimarKey = clientIdPrimarKey;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassword() {
		return password;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}
	
	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

	public String getAccountName() {
		return accountName;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}
	
	public void setCategories(String[] categories) {
		this.categories = categories;
	}

	public String[] getCategories() {
		return categories;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}

	public String getAddress() {
		return address;
	}
	
	public void setRegion(String region) {
		this.region = region;
	}

	public String getRegion() {
		return region;
	}
	
	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getRating() {
		return rating;
	}
	
	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	public String getAccountType() {
		return accountType;
	}
	
	public String getUserIdPrimarKey() {
		return userIdPrimarKey;
	}

	public void setUserIdPrimarKey(String userIdPrimarKey) {
		this.userIdPrimarKey = userIdPrimarKey;
	}

	public String getUserToken() {
		return userToken;
	}

	public void setUserToken(String userToken) {
		this.userToken = userToken;
	}

	public double getPriceRating() {
		return priceRating;
	}

	public void setPriceRating(double priceRating) {
		this.priceRating = priceRating;
	}

	public double getReliabilityRating() {
		return reliabilityRating;
	}

	public void setReliabilityRating(double reliabilityRating) {
		this.reliabilityRating = reliabilityRating;
	}

	public double getQualityRating() {
		return qualityRating;
	}

	public void setQualityRating(double qualityRating) {
		this.qualityRating = qualityRating;
	}

	public int getNumReviews() {
		return numReviews;
	}

	public void setNumReviews(int numReviews) {
		this.numReviews = numReviews;
	}

	public void updateFromClient(Client client) {
		setClientIdPrimarKey(client.getClientIdPrimarKey());
		setEmailAddress(client.getEmailAddress());
		setUserToken(client.getUserToken());
		setPassword(client.getPassword());
		setPhoneNumber(client.getPhoneNumber());
		setAccountName(client.getAccountName());
		setDescription(client.getDescription());
		setCategories(client.getCategories());
		setAddress(client.getAddress());
		setRegion(client.getRegion());
		setRating(client.getRating());
		setRating(client.getAccountType());
		setReviews(client.getReviews());
		setPriceRating(client.getPriceRating());
		setReliabilityRating(client.getReliabilityRating());
		setQualityRating(client.getQualityRating());
		setNumReviews(client.getNumReviews());
	}
	
	public Client copy() {
		Client client = new Client();
		client.updateFromClient(this);
		return client;
	}
	
	public List<Review> getReviews() {
		return reviews;
	}
	
	public void setReviews(List<Review> reviews) {
		this.reviews = reviews;
	}
	
	public void addReview(Review review) {
		getReviews().add(review);
	}
 
}
