package com.nicholas.jersey.models;

import javax.persistence.Entity;
@Entity
public class ClientRating {
	
	private double priceRating;
	private double reliabilityRating;
	private double qualityRating;
	private int numReviews;
		
	public ClientRating(double priceRating, double reliabiltyRating, double qualityRating, int numReviews){
		setPriceRating(priceRating);
		setReliabilityRating(reliabiltyRating);
		setQualityRating(qualityRating);
		setNumReviews(numReviews);
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

	public void setReliabilityRating(double reliabiltyRating) {
		this.reliabilityRating = reliabiltyRating;
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

}
