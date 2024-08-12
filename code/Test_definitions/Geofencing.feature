

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
    When the creation of subscription is performed
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_02_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions.
    Given the appropriate values are used for geofencing
    When they get all subscriptions
    Then Response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_03_Operation_to_retrieve_subscription_based_on_the_existing-subcription_ID
  Scenario: Get a subscription based on existing-subcription id.
    Given the appropriate values are used for geofencing
    When they get subscription for  existing subscription-id
    Then Response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_04_Operation_to_delete_subscription_based_on_the_provided_ID
  Scenario: Delete a subscription based on provided id.
    Given the appropriate values are used for geofencing
    When they delete subscription for subscription-id
    Then Response code is 204
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"


  @geofencing_subscriptions_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given  the appropriate values are used for geofencing
    When they create subscription with invalid parameter
    Then Response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_06_Get_unknown_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id which is not available
    Given  the appropriate values are used for geofencing
    When the get subscription with invalid subscription-id which is not available
    Then Response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given  the appropriate values are used for geofencing
    When they delete subscription with invalid subscription-id
    Then Response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_08_Invalid_method_geofencing_subscription_for_a_device
  Scenario:  Update geofencing subscription
    Given  the appropriate values are used for geofencing
    When they update subscription
    Then Response code is 405
    And the response property "$.status" is 405
    And the response property "$.code" is "METHOD_NOT_ALLOWED"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_09_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given  the appropriate values are used for geofencing
    When they create subscription with expire time in past
    Then Response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @geofencing_subscriptions_10_creation_of_subscription_when_service_unavailable
  Scenario: Subscription creation when service unavailable
    Given  the appropriate values are used for geofencing
    When they create subscription when service is unavailable
    Then Response code is not  503

  @geofencing_subscriptions_11_Get_Event-Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given  the appropriate values are used for geofencing
    When they create subscription with event have area-entered at "Place1"
    When they create subscription with event have area-entered at "Place2" and device enters "Place2"
    Then they get event details from notifications-url
    Then Response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_12_Get_Event-Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given  the appropriate values are used for geofencing
    When they create subscription with event have area-left with at "Place1"
    When they create subscription with event have area-left with at "Place2" and device left "Place1"
    Then they get event details from notifications-url
    Then Response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @geofencing_subscriptions_13_Getting_of_subscription_when_service_unavailable
  Scenario: Getting Subscription when service is unavailable
    Given  the appropriate values are used for geofencing
    When they get subscription when service is unavailable
    Then Response code is 503


  @geofencing_subscriptions_14_Deletion_of_subscription_when_service_unavailable
  Scenario: Deletion of Subscription when service unavailable
    Given  the appropriate values are used for geofencing
    When they delete subscription when service is unavailable
    Then Response code is 503

    
  @geofencing_subscriptions_15_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the appropriate values are used for geofencing
    When they get subscription with invalid subscription-id which is in invalid format
    Then Response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

 @geofencing_subscriptions_16_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given the appropriate values are used for geofencing
    When they delete subscription with invalid subscription-id which is in invalid format
    Then Response code is 400
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

    

    Validate that the subscribed events are received in the sink, with the right sinkCredential, for those situations specified in the API.
For subscriptions that provide subscriptionExpireTime, validate that the subscribed events are not longer received after the expiration time.
For subscriptions that provide subscriptionMaxEvents, validate that the subscribed events are not longer received after the maximum events limit is reached.
Validate that after a subscription is deleted, the subscribed events are not longer received.
