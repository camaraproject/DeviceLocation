@Geofencing 
Feature: Camara Geofencing Subscriptions API, vwip - Operations on subscriptions

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  # * A device object which location is known by the network when connected. 2 distinct device are required for some scenario.
  # * A moveable device to trigger area-left / area-entered events.
  #
  # References to OAS spec schemas refer to schemas specifies in geofencing-subscriptions.yaml

  Background: Common Geofencing Subscriptions setup
    Given the resource "{apiroot}/geofencing-subscriptions/vwip/" as geofencing base-url
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

############################ Happy Path Scenarios ########################
  @geofencing_subscriptions_01_Create_geofencing_subscription_for_a_device_sync
  Scenario:  Create geofencing subscription (sync creation)
    Given that subscriptions are created synchronously
    And a valid subscription request body 
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_02_Create_geofencing_subscription_for_a_device_async
  Scenario:  Create geofencing subscription (async creation)
    Given that subscriptions are created asynchronously
    And a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @geofencing_subscriptions_03_Operation_to_retrieve_list_of_subscriptions_when_no_records
  Scenario: Get a list of subscriptions when no subscriptions available
    Given a client without subscriptions created
    When the request "retrieveGeofencingSubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an empty array

  @geofencing_subscriptions_04_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions
    Given a client with subscriptions created
    When the request "retrieveGeofencingSubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body has an array of items and each item complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_05_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
  Scenario: Get a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_06_Operation_to_delete_subscription_based_on_an_existing_subscription-id
  Scenario: Delete a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 202 or 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And if the response property $.status is 204 then response body is not available
    And if the response property $.status is 202 then response body complies with the OAS schema at "/components/schemas/SubscriptionAsync"	

  @geofencing_subscriptions_07_Receive_notification_when_device_enters_geofence
  Scenario: Receive notification for area-entered event
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-entered"	
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201
    Then the device entered location "Place1"
    Then event notification "area-entered" is received on callback-url
    And sink credentials are received as expected
    And notification body complies with the OAS schema at "##/components/schemas/EventAreaEntered"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-entered"
	
  @geofencing_subscriptions_08_receive_notification_when_device_leaves_geofence
  Scenario: Receive notification for area-left event
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-left" 
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201
    Then the device left from location "Place1" 
    Then event notification "area-left" is received on callback-url
    And sink credentials are received as expected
    And notification body complies with the OAS schema at "##/components/schemas/EventAreaLeft"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-left"
	
  @geofencing_subscriptions_09_subscription_ends_on_expiry
  Scenario: Receive notification for subscription-ended event on expiry
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-left"
    And the request body property "$.subscriptionExpireTime" is set to a value in the near future
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 
    Then the subscription is expired
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_EXPIRED"
    
  @geofencing_subscriptions_10_subscription_ends_on_max_events
  Scenario: Receive notification for subscription-ended event on max events reached
    Given a valid subscription request body
    And the request body property "$.area" is set to circle which covers location "Place1"
    And the request body property "$.type" is "area-left"
    And the request body property "$.subscriptionMaxEvents" is set to 1
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201
    Then the device left from location "Place1"
    Then event notification "area-left" is received on callback-url
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"And the response property "$.terminationReason" is "MAX_EVENTS_REACHED"
		
  @geofencing_subscriptions_11_subscription_delete_event_validation
  Scenario: Receive notification for subscription-ended event on deletion
    Given a valid subscription request body 
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 
    And path parameter "subscriptionId" is set to the identifier of an existing subscription created 
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 202 or 204	
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_DELETED"

######################### Scenario in case initialEvent is managed ##############################

  @geofencing_subscriptions_12_subscription_creation_initial_event
  Scenario: Receive initial event notification on creation
    Given the API supports initial events to be sent
    And a valid subscription request body with property "$.config.initialEvent" set to true
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And an event notification of the subscribed type is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/CloudEvent"

########################### Error response scenarios ############################################
  @geofencing_subscriptions_12_create_geofencing_subscription_for_a_device_with_invalid_parameter
  Scenario:  Create geofencing subscription with invalid parameter
    Given the request body is not compliant with the schema "/components/schemas/SubscriptionRequest"
    When the  request "createGeofencingSubscription" is sent
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_13_creation_of_subscription_with_expiry_time_in_past
  Scenario: Expiry time in past
    Given a valid subscription request body 
    And request body property "$.subscriptionexpiretime" in past
    When the request "createGeofencingSubscription" is sent
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
	  	
  @geofencing_subscription_14_creation_with_invalid_eventType
  Scenario: Subscription creation with invalid event type
    Given a valid subscription request body 
    And the request body property "$.types" is set to invalid value  
    When the request "createGeofencingSubscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
    
  @geofencing_subscription_15_invalid_protocol
  Scenario: Subscription creation with invalid protocol
    Given a valid subscription request body 
    When the request "createGeofencingSubscription" is sent
    And the request property "$.types" is set to "org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And the request property "$.protocol" is not set to "HTTP"
    And the request property "$.config.subscriptionDetail.phoneNumber" is set with provided phoneNumber
    And the request property "$.sink" is set to provided callbackUrl
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscription_16_invalid_credential
  Scenario: Subscription creation with invalid credential
    Given a valid subscription request body 
    When the request "createGeofencingSubscription" is sent
    And the request property "$.types" is set to "org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And the request property "$.protocol" is set to "HTTP"
    And the request property "$.config.subscriptionDetail.phoneNumber" is set with with provided phoneNumber
    And the request property "$.sink" is set to provided callbackUrl
    And the request property "$.sinkCredential.credentialType" is not set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredential.accessToken" is valued with a valid value
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscription_17_invalid_token
  Scenario: Subscription creation with invalid token
    Given a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    And  the request property "$.types"="org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And  the request property "$.protocol" is set to "HTTP"
    And the request property "$.sink" is set to provided callbackUrl
    And the request property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is not set to "bearer"
    And the request property "$.sinkCredential.accessToken" is valued with a valid value
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" or "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscription_17_invalid_url
  Scenario: Subscription creation with sink
    Given a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    And the request property "$.sink" is not matching the defined pattern
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_SINK"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_18_no_authorization_header_for_create_subscription
  Scenario: No Authorization header for create subscription
    Given a valid subscription request body and header "Authorization" is not set to 
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_19_expired_access_token_for_create_subscription
  Scenario: Expired access token for create subscription
    Given a valid subscription request body and header "Authorization" is expired
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_20_invalid_access_token_for_create_subscription
  Scenario: Invalid access token for create subscription
    Given a valid subscription request body 
    And header "Authorization" set to an invalid access token
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
		
  @geofencing_subscriptions_21_no_authorization_header_for_get_subscription
  Scenario: No Authorization header for get subscription
    Given header "Authorization" is not set to valid token
    And path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "retrieveGeofencingSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_22_expired_access_token_for_get_subscription
  Scenario: Expired access token for get subscription
    Given the header "Authorization" is set to expired token
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
    
  @geofencing_subscriptions_23_invalid_access_token_for_get_subscription
  Scenario: Invalid access token for get subscription
    Given the header "Authorization" set to an invalid access token
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
    
  @geofencing_subscriptions_23_no_authorization_header_for_delete_subscription
  Scenario: No Authorization header for delete subscription
    Given header "Authorization" is set without a token
    When the request "deleteGeofencingSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_24_expired_access_token_for_delete_subscription
  Scenario: Expired access token for delete subscription
    Given header "Authorization" is set with an expired token
    When the request "deleteGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_25_invalid_access_token_for_delete_subscription
  Scenario: Invalid access token for delete subscription
    Given header "Authorization" set to an invalid access token
    When the request "deleteGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_26_get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get method for geofencing subscription with subscription-id unknown to the system  
    Given the path parameter "subscriptionId" is set to the value unknown to system
    When the request "retrieveGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_27_delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with subscription-id unknown to the system
    Given the path parameter "subscriptionId" is set to the value unknown to system
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_28_create_with_an_unsupported_area
  Scenario: Create subscription with an invalid area
    Given the request body property "$.area" is set to an unsupported or invalid area
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "GEOFENCING_SUBSCRIPTIONS.AREA_NOT_COVERED"
    And the response property "$.message" contains "Unable to cover the requested area"

  # @geofencing_subscriptions_29_create_with_identifier_mismatch deprecated

  @geofencing_subscriptions_30_create_with_service_not_applicable
  Scenario: Create subscription for a device not supported by the service
    Given the request body includes a device identifier not applicable for this service
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains "Service is not available for the provided device identifier."

  @geofencing_subscriptions_31_create_with_unnecessary_identifier
  Scenario: Create subscription with an unnecessary identifier
    Given the request body explicitly includes a device identifier when it is not required
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains "Device is already identified by the access token."

  @geofencing_subscriptions_32_create_with_unsupported_identifier
  Scenario: Create subscription with an unsupported identifier
    Given the request body includes an identifier type not supported by the implementation
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains "The identifier provided is not supported."

  @geofencing_subscriptions_33_create_with_an_invalid_area
  Scenario: Create subscription with an invalid area
    Given the request body property "$.area" is set with an too small area-size
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "GEOFENCING_SUBSCRIPTIONS.INVALID_AREA"
    And the response property "$.message" contains "The requested area is too small"

  @geofencing_subscriptions_33_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text
