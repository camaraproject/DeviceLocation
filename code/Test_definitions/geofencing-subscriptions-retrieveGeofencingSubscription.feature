Feature: Camara Geofencing Subscriptions API, vwip - Operation retrieveGeofencingSubscription

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

  @geofencing_subscriptions_06_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
  Scenario: Get a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing Geofencing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  # Error code 401

  @geofencing_subscriptions_401.4_no_authorization_header_for_get_subscription
  Scenario: No Authorization header for get subscription
    Given header "Authorization" is not set to valid token
    And path parameter "subscriptionId" is set to the identifier of an existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_401_expired_access_token_for_retrieve_subscription
  Scenario: Expired access token for retrieve subscription
    Given the header "Authorization" is set to an expired access token
    And the path parameter "subscriptionId" is set to an existing subscription identifier
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_401_invalid_access_token_for_retrieve_subscription
  Scenario: Invalid access token for retrieve subscription
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "subscriptionId" is set to an existing subscription identifier
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Error code 403

  @geofencing_subscriptions_403.1_retrieve_subscription_mismatch
  Scenario: Access to subscription belonging to a different API client
    Given the path parameter "subscriptionId" is set to an identifier of a valid subscription belonging to a different API client
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "SUBSCRIPTION_MISMATCH"
    And the response property "$.message" contains a user friendly text

  # Error code 404

  @geofencing_subscriptions_404.1_retrieve_unknown_subscriptions_id
  Scenario: Get subscription when subscriptionId is unknown to the system
    Given the path parameter "subscriptionId" is set to a value not corresponding to any existing subscription
    When the request "retrieveGeofencingSubscription" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
