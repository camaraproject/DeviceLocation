Feature: Camara Geofencing Subscriptions API, vwip - Operation createGeofencingSubscription

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

  @geofencing_subscriptions_01_create_subscription_sync
  Scenario: Create geofencing subscription (sync creation)
    Given that subscriptions are created synchronously
    And a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @geofencing_subscriptions_02_create_subscription_async
  Scenario: Create geofencing subscription (async creation)
    Given that subscriptions are created asynchronously
    And a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @geofencing_subscriptions_03_subscription_creation_event_validation
  Scenario: Receive notification for subscription-started event on creation
    Given a valid subscription request body
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And event notification "subscription-started" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionStarted"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-started"
    And the response property "$.data.initiationReason" is "SUBSCRIPTION_CREATED"

  @geofencing_subscriptions_08_subscription_ends_on_expiry
  Scenario: Receive notification for subscription-ended event on expiry
    Given an existing Geofencing subscription with some value for the property "expiresAt" in the near future
    When the subscription is expired
    Then the event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"
    And the response property "$.data.terminationReason" is "SUBSCRIPTION_EXPIRED"

  @geofencing_subscriptions_09_subscription_ends_on_max_events
  Scenario: Receive notification for subscription-ended event on max events reached
    Given an existing Geofencing subscription with the property "config.subscriptionMaxEvents" set to 1
    When the event subscribed occurs
    Then event notification "<event-type>" is received on callback-url
    And event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"
    And the response property "$.data.terminationReason" is "MAX_EVENTS_REACHED"

  @geofencing_subscriptions_subscription_ends_on_access_token_expired
  Scenario: Receive notification for subscription-ended event on access token expiry
    Given an existing Geofencing subscription created with a "$.sinkCredential.credentialType" set to "ACCESSTOKEN"
    And the sinkCredential access token has an expiration time in the near future
    When the sinkCredential access token expires
    Then the event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-ended"
    And the response property "$.data.terminationReason" is "ACCESS_TOKEN_EXPIRED"

  @geofencing_subscriptions_11_receive_notification_when_device_enters_geofence
  Scenario: Receive notification for area-entered event
    Given a valid subscription of type "org.camaraproject.geofencing-subscriptions.v0.area-entered" for certain device and area
    When the device enters the area in the subscription
    Then an event notification "area-entered" is sent to the specified callback URL
    And the sink credentials specified when the subscription was created are included
    And notification body complies with the OAS schema at "#/components/schemas/EventAreaEntered"
    And the notification property "$.type" is equal to "org.camaraproject.geofencing-subscriptions.v0.area-entered"
    And the notification property "$.data.subscriptionId" is equal to the existing subscriptionId

  @geofencing_subscriptions_12_receive_notification_when_device_leaves_geofence
  Scenario: Receive notification for area-left event
    Given a valid subscription of type "org.camaraproject.geofencing-subscriptions.v0.area-left" for certain device and area
    When the device leaves the area in the subscription
    Then an event notification "area-left" is sent to the specified callback URL
    And notification body complies with the OAS schema at "#/components/schemas/EventAreaLeft"
    And the notification property "$.type" is equal to "org.camaraproject.geofencing-subscriptions.v0.area-left"
    And the notification property "$.data.subscriptionId" is equal to the existing subscriptionId

######################### Scenario in case initialEvent is managed ##############################

  @geofencing_subscriptions_13_subscription_creation_initial_event
  Scenario: Receive initial event notification on creation
    Given the API supports initial events to be sent
    And a valid subscription request body with property "$.config.initialEvent" set to true
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And an event notification of the subscribed type is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/GeofencingNotificationEvent"

  @geofencing_subscriptions_receive_notification_when_subscription_is_updated
  Scenario: Receive notification for subscription-updated event
    Given an existing Geofencing subscription that the server updates (e.g. area adjustment due to system constraints)
    When the subscription is updated by the server
    Then the event notification "subscription-updated" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionUpdated"
    And type="org.camaraproject.geofencing-subscriptions.v0.subscription-updated"
    And the notification property "$.data.subscriptionId" is equal to the existing subscriptionId

  @geofencing_subscriptions_creation_with_accesstoken_sink_credential
  Scenario: Create subscription with ACCESSTOKEN sink credential
    Given a valid subscription request body
    And the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to a valid token value
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @geofencing_subscriptions_creation_with_private_key_jwt_out_of_band
  Scenario: Create subscription with PRIVATE_KEY_JWT sink credential (pre-provisioned out of band)
    Given the PRIVATE_KEY_JWT mechanism has been pre-configured out-of-band for this implementation
    And a valid subscription request body
    And the request body property "$.sinkCredential.credentialType" is set to "PRIVATE_KEY_JWT"
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @geofencing_subscriptions_creation_with_private_key_jwt_in_band
  Scenario: Create subscription with PRIVATE_KEY_JWT sink credential (in-band provisioning)
    Given the PRIVATE_KEY_JWT mechanism supports in-band key provisioning for this implementation
    And a valid subscription request body
    And the request body property "$.sinkCredential.credentialType" is set to "PRIVATE_KEY_JWT"
    And the request body includes the public key for notification verification
    When the request "createGeofencingSubscription" is sent
    Then the response code is 201 or 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  # Error scenarios for management of input parameter device

  @geofencing_subscriptions_C01.01_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.config.subscriptionDetail.device" is set to: {}
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_C01.02_device_identifiers_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                                          | oas_spec_schema                              |
      | $.config.subscriptionDetail.device.phoneNumber             | #/components/schemas/PhoneNumber             |
      | $.config.subscriptionDetail.device.ipv4Address             | #/components/schemas/DeviceIpv4Address       |
      | $.config.subscriptionDetail.device.ipv6Address             | #/components/schemas/DeviceIpv6Address       |
      | $.config.subscriptionDetail.device.networkAccessIdentifier | #/components/schemas/NetworkAccessIdentifier |

 # This scenario may happen e.g. with 2-legged access tokens, which do not identify a single device.
  @geofencing_subscriptions_C01.03_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.config.subscriptionDetail.device" is compliant with the schema but does not identify a device whose connectivity is managed by the API provider
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_C01.04_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.config.subscriptionDetail.device" is also set to a valid device, which may or may not be the same device
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @geofencing_subscriptions_C01.05_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.config.subscriptionDetail.device" is not included
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @geofencing_subscriptions_C01.06_unsupported_device
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.config.subscriptionDetail.device" only includes device identifiers not supported by the implementation
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

 # When the service is only offered to certain types of devices or subscriptions, e.g. IoT, B2C, etc.
  @geofencing_subscriptions_C01.07_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the operator
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text

 # Several identifiers provided but they do not identify the same device
 # This scenario may happen with 2-legged access tokens, which do not identify a device
  @geofencing_subscriptions_C01.08_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And at least 2 types of device identifiers are supported by the implementation
    And the request body property "$.config.subscriptionDetail.device" includes several identifiers, each of them identifying a valid but different device
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "IDENTIFIER_MISMATCH"
    And the response property "$.message" contains a user friendly text

  # Error code 400

  @geofencing_subscriptions_400.1_create_subscriptions_with_invalid_parameter
  Scenario: Create subscription with invalid parameter
    Given the request body is not compliant with the schema "#/components/schemas/SubscriptionRequest"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.2_creation_of_subscription_with_expiry_time_in_past
  Scenario: Expiry time in past
    Given a valid geofencing subscription request body
    And the request property "$.config.subscriptionExpireTime" in the past
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.3_invalid_eventType
  Scenario: Subscription creation with invalid event type
    Given a valid geofencing subscription request body
    And the request body property "$.types" is set to an invalid value
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.4_invalid_protocol
  Scenario: subscription creation with invalid protocol
    Given a valid geofencing subscription request body
    And the request property "$.protocol" is not equal to "HTTP"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.5_invalid_credential
  Scenario: subscription creation with invalid credential type
    Given a valid geofencing subscription request body
    And the request property "$.sinkCredential.accessTokenType" is equal to "bearer"
    And the request property "$.sinkCredential.credentialType" is not equal to "ACCESSTOKEN" and is not set to "PRIVATE_KEY_JWT"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.6_create_subscriptions_with_invalid_access_token_type
  Scenario: subscription creation with invalid token
    Given a valid geofencing subscription request body
    And the request property "$.sinkCredential.credentialType" is equal to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is not equal to "bearer"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.7_invalid_url
  Scenario: Subscription creation with invalid sink URL
    Given a valid subscription request body
    And the request property "$.sink" is not matching the defined pattern
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_SINK"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.8_invalid_x-correlator
  Scenario: Invalid x-correlator value
    Given a valid geofencing subscription request body
    And the header "x-correlator" does not comply with the OAS schema at "#/components/schemas/XCorrelator"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_400.9_out_of_range
  Scenario Outline: Create subscription with a property value out of its defined range
    Given a valid geofencing subscription request body
    And the request body property "<property>" is set to "<value>"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

    Examples:
      | property                                          | value   |
      | $.config.subscriptionMaxEvents                    | 0       |
      | $.config.subscriptionMaxEvents                    | 1000001 |
      | $.config.subscriptionDetail.area.radius           | 0       |
      | $.config.subscriptionDetail.area.center.latitude  | 91      |

  # Error code 401

  @geofencing_subscriptions_creation_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is compliant with the schema "#/components/schemas/SubscriptionRequest"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_creation_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to a previously valid but now expired access token
    And the request body is compliant with the schema "#/components/schemas/SubscriptionRequest"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_creation_401.5_malformed_access_token
  Scenario: Malformed access token
    Given the header "Authorization" is set to a malformed token
    And the request body is compliant with the schema "#/components/schemas/SubscriptionRequest"
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
    And the response property "$.message" contains a user friendly text

  # Error code 422

  @geofencing_subscriptions_422.1_create_with_an_unsupported_area
  Scenario: Create subscription with an unsupported area
    Given the request body property "$.config.subscriptionDetail.area" is set to an unsupported / uncovered area
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "GEOFENCING_SUBSCRIPTIONS.AREA_NOT_COVERED"
    And the response property "$.message" contains "Unable to cover the requested area"

  @geofencing_subscriptions_422.2_create_with_an_invalid_area
  Scenario: Create subscription with an invalid area
    Given the request body property "$.config.subscriptionDetail.area" is set with an too small area-size
    When the request "createGeofencingSubscription" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "GEOFENCING_SUBSCRIPTIONS.INVALID_AREA"
    And the response property "$.message" contains "The requested area is too small"

  # Not applicable while "$.types" is limited to 1 item (maxItems: 1): a request with 2 items fails schema validation with 400 INVALID_ARGUMENT.
  # Kept for a future version of the API that accepts more than one event type per subscription.
  @geofencing_subscriptions_422.3_create_with_unsupported_multiple_event_type
  Scenario: Multi event subscription not supported
    Given the API provider only allows one event to be subscribed per subscription request
    And a valid subscription request body
    And the request body property "$.types" is set to an array with 2 valid items
    When the request "createGeofencingSubscription" is sent
    Then the response code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text

  @geofencing_subscriptions_422.4_creation_with_private_jwt_key_not_configured
  Scenario: Private JWT Key not configured for subscription creation
    Given the API provider requires the use of a Private JWT key mechanism for subscription creation authentication
    And the Private JWT key mechanism is not pre-configured in the environment
    And a valid subscription request body with the property "$.sinkCredential.credentialType" set to "PRIVATE_KEY_JWT"
    When the request "createGeofencingSubscription" is sent
    Then the response code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "PRIVATE_KEY_JWT_NOT_CONFIGURED"
    And the response property "$.message" contains a user friendly text
