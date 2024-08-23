

@Geofencing 
Feature: Camara Geofencing Subscriptions API ,0.3.0 Operations on subscriptions 

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in geofencing-subscriptions.yaml, version v0.3.0

  Background: Common Geofencing Subscriptions setup
    Given the resource "/geofencing-subscriptions/v0.3/subscriptions"  as geofencing Url                                                            |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  @geofencing_subscriptions_01_Create_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription
    Given the appropriate values are used for geofencing 
    When the creation of subscription method is triggered  is performed
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_02_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions.
    Given the appropriate values are used for geofencing
    When the get all subscriptions method is triggered 
    Then the response  code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_03_Operation_to_retrieve_subscription_based_on_the_existing-subcription_ID
  Scenario: Get a subscription based on existing-subcription id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the  get subscription method is triggered  for  existing subscription-id
    Then the response  code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_04_Operation_to_delete_subscription_based_on_the_provided_ID
  Scenario: Delete a subscription based on provided id.
    Given the appropriate values are used for geofencing
    When the  delete subscription method is triggered  for subscription-id
    Then the response  code is 204
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given  the appropriate values are used for geofencing
    When the  create subscription method is triggered  with invalid parameter
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_06_Get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id which is not available
    Given  the appropriate values are used for geofencing
    When the get subscription method is triggered  with invalid subscription-id which is not available
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given  the appropriate values are used for geofencing
    When the  delete subscription method is triggered  with invalid subscription-id
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_08_Invalid_method_geofencing_subscription_for_a_device
  Scenario:  Update geofencing subscription
    Given  the appropriate values are used for geofencing
    When the  update subscription method is triggered 
    Then the response  code is 405
    And the response property "$.status" is 405
    And the response property "$.code" is "METHOD_NOT_ALLOWED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_09_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given  the appropriate values are used for geofencing
    When the create subscription method is triggered with expire time in past
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_10_creation_of_subscription_when_service_unavailable
  Scenario: Subscription creation when service unavailable
    Given  the appropriate values are used for geofencing
    When the create subscription method is triggered when service is unavailable
    Then the response  code is not  503
	And the response property "$.status" is 503
    And the response property "$.code" is "UNAVAILABLE"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_11_Get_Event-Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given  the appropriate values are used for geofencing
    When the create subscription with event have area-entered at "Place1"
    When the create subscription with event have area-entered at "Place2" and device enters "Place2"
    Then the get event details from notifications-url
    Then the response  code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_12_Get_Event-Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given  the appropriate values are used for geofencing
    When the create subscription with event have area-left with at "Place1"
    When the create subscription with event have area-left with at "Place2" and device left "Place1"
    Then they get event details from notifications-url
    Then the response  code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_13_Getting_of_subscription_when_service_unavailable
  Scenario: Getting Subscription when service is unavailable
    Given  the appropriate values are used for geofencing
    When the  get subscription method is triggered  when service is unavailable
    Then the response  code is 503
	And the response property "$.status" is 503
    And the response property "$.code" is "UNAVAILABLE"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_14_Deletion_of_subscription_when_service_unavailable
  Scenario: Deletion of Subscription when service unavailable
    Given  the appropriate values are used for geofencing
    When the delete subscription method is triggered when service is unavailable
    Then the response  code is 503
	And the response property "$.status" is 503
    And the response property "$.code" is "UNAVAILABLE"
    And the response property "$.message" contains a user friendly text

    
  @geofencing_subscriptions_15_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the appropriate values are used for geofencing
    When the  get subscription method is triggered with invalid subscription-id which is in invalid format
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_16_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the appropriate values are used for geofencing
    When the  delete subscription method is triggered  with invalid subscription-id which is in invalid format
    Then the response  code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_17_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_18_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_19_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

     @geofencing_subscriptions_20_sink_credentials
  Scenario:   Validate that the subscribed events are received in the sink, with the right sinkCredential, for those situations specified in the API.
    Given the appropriate values are used for geofencing
    When the  create subscription method is triggered  for subscription-id
    Then the response  code is 201
	  Then the get event details observed on notifications-url
	  Then the subscribed event  received on notifications-url & sink credentials are as expected
	  Then the response  code is 201
	  And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"



   @geofencing_subscriptions_21_subscriptionExpireTime
  Scenario:   For subscriptions that provide subscriptionExpireTime, validate that the subscribed events are not longer received after the expiration time.
    Given the appropriate values are used for geofencing
    When the  create subscription method is triggered  for subscription-id with subscriptionExpireTime after 5 seconds
	  Then the subscriptionExpireTime value is reached
	  Then the get event details observed on notifications-url
	  Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
    

  @geofencing_subscriptions_22_subscriptionMaxEvents
  Scenario: For subscriptions that provide subscriptionMaxEvents, validate that the subscribed events are not longer received after the maximum events limit is reached.
    Given the appropriate values are used for geofencing
    When the  create subscription method is triggered  for subscription-id
    Then the response  code is 201
	  Then the  create subscription method is triggered  for subscription-id
	  Then the subscriptionMaxEvents value is exceeded
	  Then the get event details observed on notifications-url
	  Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
    
  @geofencing_subscriptions_23_subscription_deleted_event_validation
  Scenario: Validate that after a subscription is deleted, the subscribed events are not longer received.
	  Given the appropriate values are used for geofencing
    When the  delete subscription method is triggered  for subscription-id
    Then the response  code is 204
	  Then the get event details observed on notifications-url
	  Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
