@Geofencing 
Feature: Camara Geofencing Subscriptions API, v0.3.0 - Operations on subscriptions 

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in geofencing-subscriptions.yaml, version v0.3.0

  Background: Common Geofencing Subscriptions setup
    Given the resource "{apiroot}/geofencing-subscriptions/v0.3/" as geofencing base-url                                                           
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

############################ Happy Path Scenarios ########################
  @geofencing_subscriptions_01_Create_geofencing_subscription_for_a_device_sync
   Scenario:  Create geofencing subscription (sync creation)
    Given that subscriptions are created synchronously
    And a valid subscription request body 
    When the request "createSubscription" is sent 
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_02_Create_geofencing_subscription_for_a_device_async
   Scenario:  Create geofencing subscription (async creation)
    Given that subscriptions are created asynchronously
    And a valid subscription request body 
    When the request "createSubscription" is sent 
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @geofencing_subscriptions_03_Operation_to_retrieve_list_of_subscriptions
   Scenario: Get a list of subscriptions.
    Given the request body is not available
    When the request "retrieveGeofencingSubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item in the response body, if any, complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_04_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
   Scenario: Get a subscription based on existing subscription-id.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_05_Operation_to_delete_subscription_based_on_an_existing_subscription-id
   Scenario: Delete a subscription based on existing subscription-id.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 202 or 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And if the response property $.status is 204 then response body is not available
    And if the response property $.status is 202 then response body complies with the OAS schema at "/components/schemas/SubscriptionAsync"	

 @geofencing_subscriptions_06_Receive_notification_when_device_enters_geofence
   Scenario: Receive notification for area-entered event
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-entered"	
    When the request "createSubscription" is sent
    Then the response code is 201
    Then the device entered location "Place1"
    Then event notification "area-entered" is received on callback-url
    And sink credentials are received as expected
    And notification body complies with the OAS schema at "##/components/schemas/EventAreaEntered"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-entered"
	
  @geofencing_subscriptions_07_receive_notification_when_device_leaves_geofence
   Scenario: Receive notification for area-left event
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-left" 
    When the request "createSubscription" is sent
    Then the response code is 201
    Then the device left from location "Place1" 
    Then event notification "area-left" is received on callback-url
    And sink credentials are received as expected
    And notification body complies with the OAS schema at "##/components/schemas/EventAreaLeft"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-left"
	
 @geofencing_subscriptions_08_subscriptionExpireTime
   Scenario: Receive notification for subscription-ends event on expiry  
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-left"
    And the request body property "$.subscriptionExpireTime" is set to a value in the near future
    When the request "createSubscription" is sent
    Then the response code is 201 
    Then the subscription is expired
    Then event notification "subscription-ends" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends"
    And the response property "$.terminationReason" is "SUBSCRIPTION_EXPIRED"
    
  @geofencing_subscriptions_09_subscriptionMaxEvents
   Scenario: Receive notification for subscription-ends event on max events reached 
    Given a valid subscription request body 
    And the request body property "$.area" is set to circle which covers location "Place1" 
    And the request body property "$.type" is "area-left"
    And the request body property "$.subscriptionMaxEvents" is set to 1 
    When the request "createSubscription" is sent
    Then the response code is 201 
    Then the device left from location "Place1" 
    Then event notification "area-left" is received on callback-url
    Then event notification "subscription-ends" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends"And the response property "$.terminationReason" is "MAX_EVENTS_REACHED"
		
  @geofencing_subscriptions_10_subscription_delete_event_validation
   Scenario: Receive notification for subscription-ends event on deletion 
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    Then the response code is 201 
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 202 or 204	
    Then event notification "subscription-ends" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends"
    And the response property "$.terminationReason" is "SUBSCRIPTION_DELETED"
	
########################### Error response scenarios############################################
@geofencing_subscriptions_11_create_geofencing_subscription_for_a_device_with_invalid_parameter
  Scenario:  Create geofencing subscription with invalid parameter
    Given the request body is not compliant with the schema "/components/schemas/SubscriptionRequest"
    When the  request "createSubscription" is sent 
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

 @geofencing_subscriptions_12_creation_of_subscription_with_expiry_time_in_past
  Scenario: Expiry time in past
    Given a valid subscription request body with expiry time in past
    When the  request "createSubscription" is sent 
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
	  	
 @geofencing_subscription_13_creation_with_invalid_eventType
   Scenario: Subscription creation with invalid event type
    Given a valid subscription request body 
    And the request body property "$.types" is set to invalid value  
    When the request "createSubscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
    
  @geofencing_subscription_14_invalid_protocol
   Scenario: Subscription creation with invalid protocol
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    And "$.types"="org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And "$.protocol"<>"HTTP"
    And "$.config.subscriptionDetail.phoneNumber" is set with with provided phoneNumber
    And "$.sink" is set to provided callbackUrl
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscription_15_invalid_credential
  Scenario: Subscription creation with invalid credential
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    And "$.types"="org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And "$.protocol"="HTTP"
    And "$.config.subscriptionDetail.phoneNumber" is set with with provided phoneNumber
    And "$.sink" is set to provided callbackUrl
    And "$.sinkCredential.credentialType" <> "ACCESSTOKEN"
    And "$.sinkCredential.accessTokenType" = "bearer"
    And "$.sinkCredential.accessToken" is valued with a valid value
    And "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscription_16_invalid_token
  Scenario: Subscription creation with invalid token
    Given a valid subscription request body
    When the request "createSubscription" is sent
    And "$.types"="org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And "$.protocol"="HTTP"
    And "$.sink" is set to provided callbackUrl
    And "$.sinkCredential.credentialType" = "ACCESSTOKEN"
    And "$.sinkCredential.accessTokenType" <> "bearer"
    And "$.sinkCredential.accessToken" is valued with a valid value
    And "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_17_no_authorization_header
  Scenario: No Authorization header for create subscription
    Given a valid subscription request body and header "Authorization" is not available
    When the  request "createSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_18_expired_access_token
  Scenario: Expired access token for create subscription
    Given a valid subscription request body and header "Authorization" is expired
    When the  request "createSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_19_invalid_access_token
  Scenario: Invalid access token for create subscription
    Given a valid subscription request body and header "Authorization" set to an invalid access token
    When the  request "createSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
		
@geofencing_subscriptions_20_no_authorization_header
  Scenario: No Authorization header for get subscription
    Given the request body & header "Authorization" is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the  request "retrieveGeofencingSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

@geofencing_subscriptions_21_expired_access_token
  Scenario: Expired access token for get subscription
    Given the request body is not available and header "Authorization" is expired
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
    
@geofencing_subscriptions_22_invalid_access_token
  Scenario: Invalid access token for get subscription
    Given the request body is not available and header "Authorization" set to an invalid access token
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
    
@geofencing_subscriptions_23_no_authorization_header
  Scenario: No Authorization header for delete subscription
    Given a the request body and header "Authorization" is not available
    When the request "deleteGeofencingSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

@geofencing_subscriptions_24_expired_access_token
  Scenario: Expired access token for delete subscription
    Given a valid subscription request body and header "Authorization" is expired
    When the request "deleteGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

@geofencing_subscriptions_25_invalid_access_token
  Scenario: Invalid access token for delete subscription
    Given a valid subscription request body and header "Authorization" set to an invalid access token
    When the request "deleteGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

@geofencing_subscriptions_26_get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get method for geofencing subscription with subscription-id unknown to the system  
    Given the request body is not available and path parameter "subscriptionId" is set to the value which is unknown to system
    When the request "retrieveGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

 @geofencing_subscriptions_27_delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with unknown subscription-id to the system
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier for an non-existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
