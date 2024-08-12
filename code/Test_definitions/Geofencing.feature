

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
    Given they use the geofencing url
    When they create subscription
    Then Response code is 201

  @geofencing_subscriptions_02_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions.
    Given they use the geofencing url
    When they get all subscriptions
    Then Response code is 200


  @geofencing_subscriptions_03_Operation_to_retrieve_subscription_based_on_the_existing-subcription_ID
  Scenario: Get a subscription based on existing-subcription id.
    Given they use the geofencing url
    When they get subscription for  existing subscription-id
    Then Response code is 200

  @geofencing_subscriptions_04_Operation_to_delete_subscription_based_on_the_provided_ID
  Scenario: Delete a subscription based on provided id.
    Given they use the geofencing url
    When they delete subscription for subscription-id
    Then Response code is 204

  @geofencing_subscriptions_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given they use the geofencing url
    When they create subscription with invalid parameter
    Then Response code is 400

  @geofencing_subscriptions_06_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id which is not available
    Given they use the geofencing url
    When they get subscription with invalid subscription-id which is not available
    Then Response code is 404


  @geofencing_subscriptions_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given they use the geofencing url
    When they delete subscription with invalid subscription-id
    Then Response code is 404

  @geofencing_subscriptions_08_Invalid_method_geofencing_subscription_for_a_device
  Scenario:  Update geofencing subscription
    Given they use the geofencing url
    When they update subscription
    Then Response code is 405


  @geofencing_subscriptions_09_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given they use the geofencing url
    When they create subscription with expire time in past
    Then Response code is 400


  @geofencing_subscriptions_10_creation_of_subscription_when_service_unavailable
  Scenario: Subscription creation when service unavailable
    Given they use the geofencing url
    When they create subscription when service is unavailable
    Then Response code is not  503

  @geofencing_subscriptions_11_Get_Event-Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given they use the geofencing url
    When they create subscription with event have area-entered at "Place1"
    When they create subscription with event have area-entered at "Place2" and device enters "Place2"
    Then they get event details from notifications-url
    Then Response code is 200

  @geofencing_subscriptions_12_Get_Event-Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given they use the geofencing url
    When they create subscription with event have area-left with at "Place1"
    When they create subscription with event have area-left with at "Place2" and device left "Place1"
    Then they get event details from notifications-url
    Then Response code is 200

  @geofencing_subscriptions_13_Getting_of_subscription_when_service_unavailable
  Scenario: Getting Subscription when service is unavailable
    Given they use the geofencing url
    When they get subscription when service is unavailable
    Then Response code is 503


  @geofencing_subscriptions_14_Deletion_of_subscription_when_service_unavailable
  Scenario: Deletion of Subscription when service unavailable
    Given they use the geofencing url
    When they delete subscription when service is unavailable
    Then Response code is 503

    
  @geofencing_subscriptions_15_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid subscription-id format
    Given they use the geofencing url
    When they get subscription with invalid subscription-id which is in invalid format
    Then Response code is 400
