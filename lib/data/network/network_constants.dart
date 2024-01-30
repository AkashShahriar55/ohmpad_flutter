abstract class NetworkEnvironment {
  static const DEVELOPMENT = "http://119.160.193.114:3001/api/v1/";
  static const QA = "http://119.160.193.114:9000/api/v1/";
  static const PRODUCTION = "http://119.160.193.114:4100/api/v1/";
}

abstract class NetworkResponse {
  static const STATUS = "status";
  static const DATA = "data";
  static const STATUS_CODE = "status_code";
  static const SUCCESS = "success";
  static const FAILURE = "failure";
  static const EXCEPTION = "exception";
  static const NO_INTERNET = "no_internet";
}

abstract class NetworkAPI {
  static const String BASE_URL = NetworkEnvironment.PRODUCTION;

  static const String RESPONSE_STATUS_CODE_SUCCESS = "1";
  static const String RESPONSE_STATUS_CODE_SUCCESS_ZERO = "0";
  static const String RESPONSE_STATUS_CODE_FORCE_LOGOUT = "-1";

  static const String LOGIN = "admin/login";
  static const String GET_APP_VERSION = "versioning/get-app-version";
  static const String LOGOUT = "admin/logout";
  static const String SUB_ADMIN_LIST = "admin/sub-admin-list";
  static const String CREATE_SUB_ADMIN = "admin/create-sub-admin";
  static const String FORGOT_PASSWORD = "admin/forgot-password";
  static const String GET_USER_PROFILE = "users/get-user-profile";
  static const String CHANGE_PASSWORD = "admin/change-password";
  static const String UPDATE_PROFILE = "admin/profile";
  static const String ACTIVE_DEACTIVE_SUB_ADMIN = "admin/active-deactive-sub-admin";
  static const String RESEND_PASSWORD = "admin/resend-password";
  static const String CREATE_MODULE_CATEGORY = "admin/create-module-categories";
  static const String EDIT_MODULE_CATEGORY = "admin/edit-module-category";
  static const String MODULE_CATEGORY_LIST = "admin/module-categories-list";
  static const String ACTIVE_INACTIVE_CATEGORY = "admin/active-inactive-category";
  static const String MODULES_LIST = "admin/modules-list";
  static const String CREATE_MODULES = "admin/create-module";
  static const String ACTIVE_INACTIVE_MODULES = "admin/active-inactive-module";
  static const String ALL_MODULE_CATEGORY_LIST = "admin/categories-list";
  static const String EDIT_MODULES = "admin/edit-module/";
  static const String DASHBOARD = "admin/dashboard/";
  static const String NOTIFICATION_LIST = "notification/get-all-notifications";
  static const String NOTIFICATION_COUNT = "notification/get-notification-count";
  static const String READ_ALL_NOTIFICATION = "notification/read-all-notifications";
  static const String PROPOSAL_LIST = "admin/get-proposals-list";
  static const String MODULES_LIST_CATEGORY_WISE = "admin/moduleCategories";
  static const String CREATE_PROPOSAL = "admin/create-proposal";
  static const String PROPOSAL_DETAIL = "admin/proposal-detail/";
  static const String PREPARE_CONTRACT = "admin/prepare-contract/";

  /// CMS Pages
  static const String ABOUT_US = "about_us_url";
  static const String TERMS_CONDITIONS = "terms_conditions_url";
  static const String PRIVACY_POLICY = "privacy_policy_url";
  static const String CONTACT_US = "contact_us_url";
}

abstract class NetworkParams {
  // Header field
  static const TOKEN = "Authorization";

  // Login & SignUp
  static const TABLE_USER = "users";
  static const MUSIC = "music";
  static const EMAIL = "email";
  static const FIRST_NAME = "first_name";
  static const LAST_NAME = "last_name";
  static const MOBILE_NO = "mobile_no";
  static const PASSWORD = "password";
}
