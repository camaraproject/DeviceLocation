@Geofencing 
Feature: Camara Geofencing Subscriptions API ,v0.3.0 - Operations on subscriptions 

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in geofencing-subscriptions.yaml, version v0.3.0

  Background: Common Geofencing Subscriptions setup
    Given the resource "{apiroot}/geofencing-subscriptions/v0.3/"  as geofencing base-url                                                            |
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
    When the "retrieveGeofencingSubscriptionList" is sent 
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
	

  @geofencing_subscriptions_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given a valid subscription request body 
    When the  request "createSubscription" is sent with invalid parameter
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_06_Get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id which is not available
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of a non-existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing non-subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_08_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given a valid subscription request body 
    When the  request "createSubscription" is sent with expire time in past
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_09_Get_Event-Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given a valid subscription request body 
    When the create subscription with event have area-entered at "Place1"
    When the create subscription with event have area-entered at "Place2" and device enters "Place2"
    Then the get event details on  notifications-callback-url
  
 @geofencing_subscriptions_10_Get_Event-Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given  a valid subscription request body 
    When the create subscription with event have area-left with at "Place1"
    When the create subscription with event have area-left with at "Place2" and device left "Place1"
    Then they get event details from notifications-url
    Then the response  code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

    
  @geofencing_subscriptions_11_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier with invalid subscription-id which is in invalid format
    When the request "retrieveGeofencingSubscription" is sent 
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_12_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of a non-existing subscription
    When the request "deleteGeofencingSubscription" is sent with invalid subscription-id which is in invalid format
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_13_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_14_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_15_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

   @geofencing_subscriptions_16_sink_credentials
  Scenario:   Validate that the subscribed events are received in the sink, with the right sinkCredential, for those situations specified in the API.
    Given a valid subscription request body 
    When the  request "createSubscription" is sent  with "sink" and "sinkcredentials" 
    Then the response  code is 201 and subscription is created
    Then the  event details are observed on notifications-url
    And the subscribed event  received on notifications-callback-url & sink credentials are as expected

 @geofencing_subscriptions_17_subscriptionExpireTime
  Scenario:   For subscriptions that provide subscriptionExpireTime, validate that the subscribed events are not longer received after the expiration time.
    Given a valid subscription request body 
    When the  request "createSubscription" is sent for less $.duration
    Then the subscriptionExpireTime ]breached and subscription is expired
    Then the get method called for checking event details on notifications-callback-url when device enters geofence
    Then no event received on notifications-callback-url
    Then the get method called for checking event details on notifications-callback-url when device leaves geofence
    Then no event received on notifications-callback-url
    

  @geofencing_subscriptions_18_subscriptionMaxEvents
  Scenario: For subscriptions that provide subscriptionMaxEvents, validate that the subscribed events are not longer received after the maximum events limit is reached.
    Given a valid subscription request body 
    When the  request "createSubscription" is sent
    Then the response  code is 201
    Then the  maxevents are already triggered for available subscription
    Then the get method called for checking event details on notifications-callback-url when device enters geofence
    Then no event received on notifications-callback-url
    Then the get method called for checking event details on notifications-url when device leaves geofence
    Then no event received on notifications-callback-url
	
	
  @geofencing_subscriptions_19_subscription_delete_event_validation
  Scenario: Validate that after a subscription is deleted, the subscribed events are not longer received.
    Given the request body is not available and path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "deleteGeofencingSubscription" is sent
    Then the response  code is 204
    Then the get method called for checking event details on notifications-callback-url when device enters geofence
    Then no event received on notifications-callback-url
    Then the get method called for checking event details on notifications-url when device leaves geofence
    Then no event received on notifications-callback-url
