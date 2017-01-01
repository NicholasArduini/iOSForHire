package com.nicholas.jersey.persistence;

import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.ObjectNotFoundException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.exception.JDBCConnectionException;

import com.nicholas.jersey.LoggerManager;
import com.nicholas.jersey.common.Messages;
import com.nicholas.jersey.models.Review;


public class HibernateDatabaseReviewManager extends
		AbstractHibernateDatabaseManager {

	private static String REVIEW_TABLE_NAME = "REVIEW";
	private static String REVIEW_CLASS_NAME = "Review";

	private static String SELECT_ALL_REVIEWS = "from "
			+ REVIEW_TABLE_NAME + " as reviews";

	private static final String DROP_TABLE_SQL = "drop table "
			+ REVIEW_TABLE_NAME + ";";
	
	private static String SELECT_NUMBER_REVIEWS = "select count (*) from "
		+ REVIEW_CLASS_NAME;
	private static String SELECT_REVIEWS_FOR_USER = "from " + REVIEW_CLASS_NAME
			+ " as review where review.writtenForUser = :writtenForUser";
	private static String SELECT_REVIEWS_FOR_USER_BY_USER = "from " + REVIEW_CLASS_NAME
			+ " as review where review.writtenForUser = :writtenForUser and review.writtenByUser = :writtenByUser";
	
	private static final String CREATE_TABLE_SQL = "create table REVIEW(REVIEW_PRIMARY_KEY char(36) primary key not null,"
			+ "PRICE_RATING tinytext, RELIABILITY_RATING tinytext, QUALITY_RATING tinytext, REVIEW_TEXT text, CATEGORY tinytext, "
			+ "WRITTEN_BY_USER tinytext, WRITTEN_FOR_USER tinytext, CLIENT_ID_FK char(36));";
	
	private static HibernateDatabaseReviewManager manager;

	HibernateDatabaseReviewManager() {
		super();
	}

	/**
	 * Returns default instance.
	 * 
	 * @return
	 */
	public static HibernateDatabaseReviewManager getDefault() {
		
		if (manager == null) {
			manager = new HibernateDatabaseReviewManager();
		}
		return manager;
	}

	public String getClassName() {
		return REVIEW_CLASS_NAME;
	}

	@Override
	public boolean setupTable() {
		HibernateUtil.executeSQLQuery(DROP_TABLE_SQL);
		return HibernateUtil.executeSQLQuery(CREATE_TABLE_SQL);
	}


	/**
	 * Adds given object (review) to the database 
	 */
	public synchronized boolean add(Object object) {
		Transaction transaction = null;
		Session session = null;
		Review review = (Review) object;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.save(review);
			transaction.commit();
			return true;

		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_ADD_REVIEW,
					"error.addReviewToDatabase", exception);

			rollback(transaction);
			return false;
		} finally {
			closeSession();
		}
	}
	
	@SuppressWarnings("unchecked")
	public synchronized List<Review> getReviewsForUser(String writtenForUser) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_REVIEWS_FOR_USER);
			query.setParameter("writtenForUser", writtenForUser);
			List<Review> reviews = query.list();
			transaction.commit();

			if (reviews.isEmpty()) {
				return null;
			} else {
				return reviews;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_REVIEWS_FOR_USER,
					"error.getReviewsForUserInDatabase", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	public synchronized Review getReviewsForUserByUser(String writtenForUser, String writtenByUser) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_REVIEWS_FOR_USER_BY_USER);
			query.setParameter("writtenForUser", writtenForUser);
			query.setParameter("writtenByUser", writtenByUser);
			
			List<Review> reviews = query.list();
			transaction.commit();

			if (reviews.isEmpty()) {
				return null;
			} else {
				return reviews.get(0);
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_REVIEWS_FOR_USER_BY_USER,
					"error.getReviewsForUserByUserInDatabase", exception);
			return null;
		} finally {
			closeSession();
		}
	}
	
	/**
	 * Updates given object (Review).
	 * 
	 * @param object
	 * @return
	 */
	public synchronized boolean update(Review review) {
		boolean result = super.update(review);	
		return result;
	}

	
	/**
	 * Deletes given review from the database.
	 * Returns true if successful, otherwise returns false.
	 * 
	 * @param object
	 * @return
	 */
	public synchronized boolean delete(Review review){
		
		Session session = null;
		Transaction transaction = null;
		boolean errorResult = false;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.delete(review);
			transaction.commit();
			return true;
		}
		catch (HibernateException exception) {
			rollback(transaction);
			LoggerManager.current().error(this, Messages.METHOD_DELETE_REVIEW, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		}	
		catch (RuntimeException exception) {
			rollback(transaction);
			LoggerManager.current().error(this, Messages.METHOD_DELETE_REVIEW, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}

	/**
	 * Returns review from the database with given id.
	 * Upon exception returns null.
	 * 
	 * @param id
	 * @return
	 */
	public synchronized Review getReviewById(String id) {
		
		Session session = null;
		try {
			session = HibernateUtil.getCurrentSession();
			Review review = (Review) session.load(Review.class, id);
			return review;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this,
					Messages.METHOD_GET_REVIEW_BY_ID, "error.getReviewById",
					exception);
			return null;
		} finally {
			closeSession();
		}
	}

	/**
	
	/**
	 * Returns reviews, 
	 * from database.
	 * If not found returns null.
	 * Upon error returns null.
	 * 
	 * @param phonenumber
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized  List<Review> getNReviewsStartingAtIndex(int index, int n) {
		List<Review> errorResult = null;
		Session session = null;
		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session.createQuery(SELECT_ALL_REVIEWS);
			query.setFirstResult(index);
			query.setMaxResults(n);
			List<Review> reviews = query.list();

			return reviews;
		} catch (ObjectNotFoundException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_N_REVIEWS,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		}  catch (JDBCConnectionException exception) {
			HibernateUtil.clearSessionFactory();
			LoggerManager.current().error(this, Messages.METHOD_GET_N_REVIEWS,
					Messages.HIBERNATE_CONNECTION_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_N_REVIEWS,
					Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_N_REVIEWS,
					Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}
	
	public String getTableName() {
		return REVIEW_TABLE_NAME;
	}
	
	
	/**
	 * Returns number of reviews.
	 * 
	 * Upon error returns empty list.
	 * 
	 * @param a charge status
	 * @return
	 */
	
	public synchronized int getNumberOfReviews() {
		
		Session session = null;
		Long aLong;

		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session
					.createQuery(SELECT_NUMBER_REVIEWS);
			aLong = (Long) query.uniqueResult();
			return aLong.intValue();
		} catch (ObjectNotFoundException exception) {
			LoggerManager.current().error(this,
					Messages.METHOD_GET_NUMBER_OF_REVIEWS,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return 0;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this,
					Messages.METHOD_GET_NUMBER_OF_REVIEWS,
					Messages.HIBERNATE_FAILED, exception);
			return 0;
		} catch (RuntimeException exception) {
			LoggerManager.current().error(this,
					Messages.METHOD_GET_NUMBER_OF_REVIEWS,
					Messages.GENERIC_FAILED, exception);
			return 0;
		} finally {
			closeSession();
		}
	}
}

