@Geofencing 
Feature: Camara Geofencing Subscriptions API ,v0.3.0 - Operations on subscriptions 

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in geofencing-subscriptions.yaml, version v0.3.0

  Background: Common Geofencing Subscriptions setup
    Given the resource "{apiroot}/geofencing-subscriptions/v0.3/"  as geofencing base-url                                                           
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

  @geofencing_subscriptions_01_Create_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription
    Given a valid subscription request body 
    When the  request "createSubscription" is sent 
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_02_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions.
    Given the request body is not available
    When the request "retrieveGeofencingSubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item in the response body, if any, complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_03_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
  Scenario: Get a subscription based on existing subscription-id.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_04_Operation_to_delete_subscription_based_on_an_existing_subscription-id
  Scenario: Delete a subscription based on existing subscription-id.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response code is 202 or 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And if response property $.status is 204 then response body is not available
    And if the response property $.status is 202 then response body complies with the OAS schema at "/components/schemas/SubscriptionAsync"	
	

  @geofencing_subscriptions_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given a valid subscription request body with invalid parameter
    When the  request "createSubscription" is sent 
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_06_Get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with subscription-id unknown to the system  
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of a unknown to subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an non-existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_08_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given a valid subscription request body with expire time in past
    When the  request "createSubscription" is sent 
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_09_Get_Event_Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given a valid subscription request body 
    ##Geofence should be created
    When the request "createSubscription" is sent
    Then the device entered to  "Place2" from "Place1"
    Then event notification "area-entered" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/CloudEvent"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-entered"
	
  
 @geofencing_subscriptions_10_Get_Event_Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    Then the device left from  "Place1" to "Place2"
    Then event notification "area-left" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/CloudEvent"
    And type="org.camaraproject.geofencing-subscriptions.v0.area-left"

    
  @geofencing_subscriptions_11_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier with invalid subscription-id which is in invalid format
    When the request "retrieveGeofencingSubscription" is sent 
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_12_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with subscription-id in invalid format
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of a non-existing subscription which is in invalid format
    When the request "deleteGeofencingSubscription" is sent
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_13_no_authorization_header
  Scenario: No Authorization header
    Given a valid subscription request body and header "Authorization" is not available
    When the  request "createSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_14_expired_access_token
  Scenario: Expired access token
    Given a valid subscription request body and header "Authorization" is expired
    When the  request "createSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_15_invalid_access_token
  Scenario: Invalid access token
    Given a valid subscription request body and header "Authorization" set to an invalid access token
    When the  request "createSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

   @geofencing_subscriptions_16_sink_credentials
  Scenario:   Validate that the subscribed events are received in the sink, with the right sinkCredential, for those situations specified in the API.
    Given a valid subscription request body with "sink" and "sinkcredentials"  
    When the  request "createSubscription" is sent  
    Then the response  code is 201 and subscription is created
    Then the  event details are observed on notifications-url
    And the subscribed event  received on notifications-callback-url & sink credentials are as expected

 @geofencing_subscriptions_17_subscriptionExpireTime
  Scenario:   For subscriptions that provide subscriptionExpireTime, validate that the subscribed events are not longer received after the expiration time.
    Given a valid subscription request body and for less $.duration
    When the request "createSubscription" is sent
    Then the subscription is expired
    And The callback notification application receives subscription-ends event at provided callbackUrl
    And notification body complies with the OAS schema at "##/components/schemas/CloudEvent"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends"
    
  @geofencing_subscriptions_18_subscriptionMaxEvents
   Scenario: For subscriptions that provide subscriptionMaxEvents, validate that the subscribed events are not longer received after the maximum events limit is reached.
    Given a valid subscription request body 
    When the  request "createSubscription" is sent
    Then the  maxevents are already triggered for available subscription
    And The callback notification application receives subscription-ends event at provided callbackUrl
    And notification body complies with the OAS schema at "##/components/schemas/CloudEvent"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends
	
	
  @geofencing_subscriptions_19_subscription_delete_event_validation
  Scenario: Validate that after a subscription is deleted, the subscribed events are not longer received.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then no event notifications received on callback-url for the device
    And The callback notification application receives subscription-ends event at provided callbackUrl
    And notification body complies with the OAS schema at "##/components/schemas/CloudEvent"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ends"
   
