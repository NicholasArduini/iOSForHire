package com.nicholas.jersey.common;

public class Messages {
	
	public static final String HIBERNATE_FAILED = "hibernate failed";
	public static final String HIBERNATE_CONNECTION_FAILED = "hibernate connection failed";
	
	public static final String OBJECT_NOT_FOUND_FAILED = "object not found failed";
	public static final String GENERIC_FAILED = "generic failed";	
	public static final String EXCESSIVE_MESSAGE_BEING_SENT = "excessive message being sent";
	
	public static final String METHOD_ROLLBACK = "rollback";
	public static final String METHOD_ADD = "add";
	public static final String METHOD_DELETE = "delete";
	public static final String METHOD_UPDATE = "update";
	public static final String METHOD_UPDATE_AND_ADD = "update and add";
	public static final String METHOD_DELETE_ALL = "deleteAll";
	public static final String METHOD_GET_OBJECT_WITH_PRIMARY_KEY = "getObjectWithPrimaryKey";
	
	public static final String METHOD_ADD_CLIENT = "addClient";
	public static final String METHOD_UPDATE_CLIENT = "updateClient";
	public static final String METHOD_DELETE_CLIENT = "deleteClient";
	public static final String METHOD_GET_CLIENT_BY_EMAIL_ADDRESS = "getClientByEmailAddress";
	public static final String METHOD_GET_CLIENT_BY_PHONENUMBER = "getClientByPhonenumber";
	public static final String METHOD_GET_CLIENT_BY_EMAIL_ADDRESS_PASSWORD = "getClientByEmailAddressPasssword";
	public static final String METHOD_GET_CLIENT_BY_USER_TOKEN = "getClientByUserToken";
	public static final String METHOD_GET_CLIENTS_BY_REGION_CATEGORY = "getClientsByRegionCategory";
	public static final String METHOD_GET_CLIENT_BY_ID = "getClientById";
	public static final String METHOD_GET_NUMBER_OF_CLIENTS = "getNumberOfClients";
	
	public static final String METHOD_ADD_REVIEW = "addReview";
	public static final String METHOD_GET_REVIEWS_FOR_USER = "getReviewsForUser";
	public static final String METHOD_GET_REVIEWS_FOR_USER_BY_USER = "getReviewsForUserByUser";
	public static final String METHOD_UPDATE_REVIEW = "updateReview";
	public static final String METHOD_DELETE_REVIEW = "deleteReview";
	public static final String METHOD_GET_REVIEW_BY_ID = "getReviewById";
	public static final String METHOD_GET_NUMBER_OF_REVIEWS = "getNumberOfReviews";
	public static final String METHOD_GET_N_REVIEWS = "getNReviewsStartingAtIndex";
	
	public static final String METHOD_ADD_OPTION_SETTING = "addOptionSetting";
	public static final String METHOD_UPDATE_OPTION_SETTING = "updateOptionSetting";
	public static final String METHOD_DELETE_OPTION_SETTING = "deleteOptionSetting";
	public static final String METHOD_GET_OPTION_SETTING_BY_ID = "getOptionSettingById";
	public static final String METHOD_GET_NUMBER_OF_OPTION_SETTINGS = "getNumberOfOptionSetting";
	public static final String METHOD_GET_N_OPTION_SETTINGS = "getNOptionSettingsStartingAtIndex";
	
	//server errors messages
	public static final String EMAIL_ALREADY_USED = "email already used";
	public static final String NOT_VALID_USER = "not valid user";
	public static final String NO_ADS_FOUND = "no ads found";
	public static final String REVIEW_ALREADY_EXISTS = "review already exists";

	public static final String TRUE = "true";
	public static final String TAB = "\t";
	public static final String NEW_LINE = "\n";
	public static final String CRLF = "\r\n";
	public static final String UNKNOWN = "unknown";
	public static final String EMPTY_STRING = "";
	public static final String SPACE = " ";
	public static final String COMMA_SPACE = ", ";
	public static final String ZERO = "0";
	public static final String LEFT_BRACE = "(";
	public static final String RIGHT_BRACE = ")";
	public static final String COLON = ":";
}
