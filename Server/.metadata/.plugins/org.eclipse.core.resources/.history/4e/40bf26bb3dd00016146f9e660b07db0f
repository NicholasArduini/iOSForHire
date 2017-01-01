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
import com.nicholas.jersey.models.Client;

public class HibernateDatabaseClientManager extends AbstractHibernateDatabaseManager {

	private static String CLIENT_TABLE_NAME = "CLIENT";
	private static String CLIENT_CLASS_NAME = "Client";

	private static String SELECT_ALL_CLIENTS = "from " + CLIENT_CLASS_NAME + " as client";
	private static String SELECT_CLIENT_WITH_EMAIL_ADDRESS = "from " + CLIENT_CLASS_NAME
			+ " as client where client.emailAddress = :email";
	private static String SELECT_CLIENT_WITH_USER_TOKEN = "from " + CLIENT_CLASS_NAME
			+ " as client where client.userToken = :userToken";
	private static String SELECT_CLIENT_WITH_PHONENUMBER = "from " + CLIENT_CLASS_NAME
			+ "  as client where client.phoneNumber = :phoneNumber";
	private static String SELECT_CLIENT_WITH_EMAIL_PASSWORD = "from " + CLIENT_CLASS_NAME
			+ " as client where client.emailAddress = :email and client.password = :password";
	private static String SELECT_CLIENT_WITH_REGION_CATEGORY = "from " + CLIENT_CLASS_NAME
			+ " as client where client.region = :region and str(client.categories) like :category";
	/*
	 * private static String DELETE_CLIENT_WITH_PRIMARY_KEY = " delete from " +
	 * CLIENT_CLASS_NAME + " as client where client.id = ?";
	 */
	/*
	 * private static String SELECT_ALL_CLIENT_EMAIL_ADDRESSES =
	 * "select client.emailAddress from " + CLIENT_CLASS_NAME + " as client";
	 */

	private static final String DROP_TABLE_SQL = "drop table " + CLIENT_TABLE_NAME + ";";

	private static String SELECT_NUMBER_CLIENTS = "select count (*) from " + CLIENT_CLASS_NAME;

	private static final String CREATE_TABLE_SQL = "create table " + CLIENT_TABLE_NAME
			+ "(CLIENT_ID_PRIMARY_KEY char(36) primary key not null,"
			+ "EMAIL_ADDRESS tinytext, PASSWORD tinytext, "
			+ "PHONE_NUMBER tinytext, ACCOUNT_NAME tinytext, DESCRIPTION text, "
			+ "CATEGORIES varchar(300), ADDRESS tinytext, REGION tinytext, RATING tinytext,"
			+ "ACCOUNT_TYPE tinytext, PRICE_RATING float,  RELIABILITY_RATING float, QUALITY_RATING float,"
			+ "NUM_REVIEWS int, USER_TOKEN tinytext);";

	private static final String METHOD_GET_N_CLIENTS = "getNClientsStartingAtIndex";

	private static HibernateDatabaseClientManager manager;

	HibernateDatabaseClientManager() {
		super();
	}

	/**
	 * Returns default instance.
	 * 
	 * @return
	 */
	public static HibernateDatabaseClientManager getDefault() {

		if (manager == null) {
			manager = new HibernateDatabaseClientManager();
		}
		return manager;
	}

	public String getClassName() {
		return CLIENT_CLASS_NAME;
	}

	@Override
	public boolean setupTable() {
		HibernateUtil.executeSQLQuery(DROP_TABLE_SQL);
		return HibernateUtil.executeSQLQuery(CREATE_TABLE_SQL);
	}

	public synchronized boolean add(Object object) {
		Transaction transaction = null;
		Session session = null;
		Client client = (Client) object;

		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_EMAIL_ADDRESS);
			query.setParameter("email", client.getEmailAddress());
			
			@SuppressWarnings("unchecked")
			List<Client> clients = query.list();

			if (!clients.isEmpty()) {
				return false;
			}

			session.save(client);
			transaction.commit();
			return true;

		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_ADD_CLIENT, "error.addClientToDatabase", exception);

			rollback(transaction);
			return false;
		} finally {
			closeSession();
		}
	}

	public synchronized boolean update(Client client) {
		boolean result = super.update(client);
		return result;
	}

	public synchronized boolean delete(Client client) {

		Session session = null;
		Transaction transaction = null;
		boolean errorResult = false;

		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.delete(client);
			transaction.commit();
			return true;
		} catch (HibernateException exception) {
			rollback(transaction);
			LoggerManager.current().error(this, Messages.METHOD_DELETE_CLIENT, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			rollback(transaction);
			LoggerManager.current().error(this, Messages.METHOD_DELETE_CLIENT, Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}
	
	@SuppressWarnings("unchecked")
	public synchronized List<Client> getClientsByRegionAndCategory(String region, String category) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_REGION_CATEGORY);
			query.setParameter("region", region);
			query.setParameter("category", "%"+category+"%");
			List<Client> clients = query.list();
			transaction.commit();

			if (clients.isEmpty()) {
				return null;
			} else {
				return clients;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENTS_BY_REGION_CATEGORY,
					"error.getClientsByRegionCategoryInDataBase", exception);
			return null;
		} finally {
			closeSession();
		}
	}
	
	@SuppressWarnings("unchecked")
	public synchronized Client getClientByUserToken(String userToken) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_USER_TOKEN);
			query.setParameter("userToken", userToken);
			List<Client> clients = query.list();
			transaction.commit();

			if (clients.isEmpty()) {
				return null;
			} else {
				Client client = clients.get(0);
				return client;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENT_BY_USER_TOKEN,
					"error.getClientByUserTokenInDatabase", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	public synchronized Client getClientByEmailAddress(String emailAddress) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_EMAIL_ADDRESS);
			query.setParameter("email", emailAddress);
			List<Client> clients = query.list();
			transaction.commit();

			if (clients.isEmpty()) {
				return null;
			} else {
				Client client = clients.get(0);
				return client;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENT_BY_EMAIL_ADDRESS,
					"error.getClientByEmailAddressInDatabase", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	public synchronized Client getClientByPhonenumber(String phonenumber) {

		Session session = null;
		Transaction transaction = null;
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_PHONENUMBER);
			query.setParameter("phoneNumber", phonenumber);
			List<Client> clients = query.list();
			transaction.commit();

			if (clients.isEmpty()) {
				return null;
			} else {
				Client client = clients.get(0);
				return client;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENT_BY_PHONENUMBER,
					"error.getClientByPhonenumber", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	@SuppressWarnings("unchecked")
	public synchronized Client getClientByEmailAddressPasssword(String emailAddress, String password) {

		Session session = null;
		Transaction transaction = null;

		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_CLIENT_WITH_EMAIL_PASSWORD);
			query.setParameter("email", emailAddress);
			query.setParameter("password", password);
			List<Client> clients = query.list();
			transaction.commit();

			if (clients.isEmpty()) {
				return null;
			} else {
				Client client = clients.get(0);
				return client;
			}
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENT_BY_EMAIL_ADDRESS_PASSWORD,
					"error.getClientByEmailAddressInDatabase", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	public synchronized Client getClientById(String id) {

		Session session = null;
		try {
			session = HibernateUtil.getCurrentSession();
			Client client = (Client) session.load(Client.class, id);
			return client;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_CLIENT_BY_ID, "error.getClientById", exception);
			return null;
		} finally {
			closeSession();
		}
	}

	public Client getClient(String emailAddress, String password) {

		Client client = getClientByEmailAddress(emailAddress);
		if ((client != null) && (client.getPassword().equals(password))) {
			return client;
		} else {
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	public synchronized List<Client> getNClientsStartingAtIndex(int index, int n) {
		List<Client> errorResult = null;
		Session session = null;
		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session.createQuery(SELECT_ALL_CLIENTS);
			query.setFirstResult(index);
			query.setMaxResults(n);
			List<Client> clients = query.list();

			return clients;
		} catch (ObjectNotFoundException exception) {
			LoggerManager.current().error(this, METHOD_GET_N_CLIENTS, Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (JDBCConnectionException exception) {
			HibernateUtil.clearSessionFactory();
			LoggerManager.current().error(this, METHOD_GET_N_CLIENTS, Messages.HIBERNATE_CONNECTION_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, METHOD_GET_N_CLIENTS, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			LoggerManager.current().error(this, METHOD_GET_N_CLIENTS, Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}

	public String getTableName() {
		return CLIENT_TABLE_NAME;
	}

	public synchronized int getNumberOfClients() {

		Session session = null;
		Long aLong;

		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session.createQuery(SELECT_NUMBER_CLIENTS);
			aLong = (Long) query.uniqueResult();
			return aLong.intValue();
		} catch (ObjectNotFoundException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_NUMBER_OF_CLIENTS, Messages.OBJECT_NOT_FOUND_FAILED,
					exception);
			return 0;
		} catch (HibernateException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_NUMBER_OF_CLIENTS, Messages.HIBERNATE_FAILED,
					exception);
			return 0;
		} catch (RuntimeException exception) {
			LoggerManager.current().error(this, Messages.METHOD_GET_NUMBER_OF_CLIENTS, Messages.GENERIC_FAILED,
					exception);
			return 0;
		} finally {
			closeSession();
		}
	}
}
