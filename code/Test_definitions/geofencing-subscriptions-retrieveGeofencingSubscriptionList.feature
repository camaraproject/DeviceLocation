Feature: Camara Geofencing Subscriptions API, vwip - Operation retrieveGeofencingSubscriptionList

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  # * A device object which location is known by the network when connected. 2 distinct device are required for some scenario.
  # * A moveable device to trigger area-left / area-entered events.
  # * apiRoot: API root of the server URL
  #
  # References to OAS spec schemas refer to schemas specifies in geofencing-subscriptions.yaml

  Background: Common Geofencing Subscriptions setup
    Given an environment at "apiRoot"
    And the resource  "/geofencing-subscriptions/vwip/" as geofencing base-url
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  # Success scenarios

  # Note: Depending on the API managed personal data specific scenario update may be require to specify use of 2-legs or 3-legs access token.

  @geofencing_subscriptions_04_Operation_to_retrieve_list_of_subscriptions_when_no_records
  Scenario: Get a list of Geofencing subscriptions when no subscriptions available
    Given a client without Geofencing subscriptions created
    When the request "retrieveGeofencingSubscriptionList" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is an empty array

  @geofencing_subscriptions_05_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions
    Given a client with Geofencing subscriptions created
    When the request "retrieveGeofencingSubscriptionList" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body has an array of items and each item complies with the OAS schema at "#/components/schemas/Subscription"

  # Error code 401

  @geofencing_subscriptions_401_no_authorization_header_for_list_subscriptions
  Scenario: No Authorization header for list subscriptions
    Given the header "Authorization" is removed
    When the request "retrieveGeofencingSubscriptionList" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_401_expired_access_token_for_list_subscriptions
  Scenario: Expired access token for list subscriptions
    Given the header "Authorization" is set to an expired access token
    When the request "retrieveGeofencingSubscriptionList" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_401_invalid_access_token_for_list_subscriptions
  Scenario: Invalid access token for list subscriptions
    Given the header "Authorization" is set to an invalid access token
    When the request "retrieveGeofencingSubscriptionList" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
