package com.nicholas.jersey.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.nicholas.jersey.common.Messages;

@Entity
@Table(name="REVIEW")
public class Review {
	@Id
	@GeneratedValue(generator = "uuid")
	@GenericGenerator(name="uuid", strategy="uuid2")
	@Column(name="REVIEW_PRIMARY_KEY")
	private String reviewPrimaryKey;
	
	@Column(name="PRICE_RATING")
	private String priceRating;
	
	@Column(name="RELIABILITY_RATING")
	private String reliabilityRating;
	
	@Column(name="QUALITY_RATING")
	private String qualityRating;
	
	@Column(name="REVIEW_TEXT")
	private String reviewText;
	
	@Column(name="CATEGORY")
	private String category;
	
	@Column(name="WRITTEN_BY_USER")
	private String writtenByUser;
	
	@Column(name="WRITTEN_FOR_USER")
	private String writtenForUser;
	
	public Review() {
		setPriceRating(Messages.UNKNOWN);
		setReliabilityRating(Messages.UNKNOWN);
		setQualityRating(Messages.UNKNOWN);
		setReviewText(Messages.UNKNOWN);
		setCategory(Messages.UNKNOWN);
		setWrittenByUser(Messages.UNKNOWN);
		setWrittenForUser(Messages.UNKNOWN);
	}
	
	public Review(String priceRating, String reliabilityRating, String qualityRating, String reviewText, String category, String writtenByUser, String writtenForUser){
		setPriceRating(priceRating);
		setReliabilityRating(reliabilityRating);
		setQualityRating(qualityRating);
		setReviewText(reviewText);
		setCategory(category);
		setWrittenByUser(writtenByUser);
		setWrittenForUser(writtenForUser);
	}

	public String getReviewPrimaryKey() {
		return reviewPrimaryKey;
	}
	
	public void setReviewPrimaryKey(String reviewPrimaryKey) {
		this.reviewPrimaryKey = reviewPrimaryKey;
	}

	public void setPriceRating(String priceRating) {
		this.priceRating = priceRating;
	}

	public String getPriceRating() {
		return priceRating;
	}

	public void setReliabilityRating(String reliabilityRating) {
		this.reliabilityRating = reliabilityRating;
	}

	public String getReliabilityRating() {
		return reliabilityRating;
	}

	public String getQualityRating() {
		return qualityRating;
	}

	public void setQualityRating(String qualityRating) {
		this.qualityRating = qualityRating;
	}

	public String getReviewText() {
		return reviewText;
	}

	public void setReviewText(String reviewText) {
		this.reviewText = reviewText;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getWrittenByUser() {
		return writtenByUser;
	}

	public void setWrittenByUser(String writtenByUser) {
		this.writtenByUser = writtenByUser;
	}

	public String getWrittenForUser() {
		return writtenForUser;
	}

	public void setWrittenForUser(String writtenForUser) {
		this.writtenForUser = writtenForUser;
	}
	
}

