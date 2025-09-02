Feature: CAMARA Device location retrieval API, v0.5.0 - Operation retrieveLocation
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  # * A device object which location is known by the network when connected. 2 distinct device are required for some scenario.
  # * A device object identifying a device commercialized by the implementation for which the service is not applicable
  # * A device object which location cannot be provided during test by the network.
  #
  # References to OAS spec schemas refer to schemas specifies in location-retrieval.yaml

  Background: Common retrieveLocation setup
    Given the resource "/location-retrieval/v0.5/retrieve"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema

  # Success scenarios

  # This first scenario serves as a minimum
  @location_retrieval_200_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    # Not that in case the device is identified by the token the body could be {}
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body is set to a valid request body
    When the request "retrieveLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "#/components/schemas/Location"

  # Scenarios testing specific situations for the device location

  @location_retrieval_200.1_location_retrieval_for_device_no_maxAge
  Scenario: Retrieve location of a device without specifying maxAge
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.maxAge" is not included
    When the request "retrieveLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Location"

  @location_retrieval_200.2_location_retrieval_for_device_with_maxAge
  Scenario: Retrieve location of a device specifying maxAge
    # maxAge could be tested with several values with scenario variable
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.device" is set to a valid testing device supported by the service
    And the request body property "$.maxAge" is included
    When the request "retrieveLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Location"
    And the response property "$.lastLocationTime" value is not older than the value of "$.maxAge" the request time

  # Error scenarios for management of input parameter device

  @location_retrieval_C01.01_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is set to: {}
    When the request "retrieveLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_C01.02_device_identifiers_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the request "retrieveLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier          | oas_spec_schema                             |
      | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
      | $.device.ipv4Address       | /components/schemas/DeviceIpv4Addr          |
      | $.device.ipv6Address       | /components/schemas/DeviceIpv6Address       |
      | $.device.networkIdentifier | /components/schemas/NetworkAccessIdentifier |

  @location_retrieval_C01.03_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is compliant with the schema, but does not identify a device whose connectivity is managed by the API provider
    When the request "retrieveLocation" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_C01.04_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device, which may or may not be the same device that is identified by the access token
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @location_retrieval_C01.05_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @location_retrieval_C01.06_unsupported_device
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  # When the service is only offered to certain types of devices or subscriptions, e.g. IoT, B2C, etc.
  @location_retrieval_C01.07_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the API provider
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    And a valid device, provided in the request body, for which the service is not applicable
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text

  # Several identifiers provided but they do not identify the same device
  # This scenario may happen with 2-legged access tokens, which do not identify a device
  @location_retrieval_C01.08_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And at least 2 types of device identifiers are supported by the implementation
    And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "IDENTIFIER_MISMATCH"
    And the response property "$.message" contains a user friendly text

  # Error code 400

  @location_retrieval_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "retrieveLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_400.2_max_age_schema_compliant
  Scenario: Input property values doe not comply with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the "maxAge" is set to 6a0
    When the request "retrieveLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Error code 401

  @location_retrieval_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the request "retrieveLocation" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the request "retrieveLocation" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the request "retrieveLocation" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Error code 403

  @location_retrieval_403_missing_scope
  Scenario: Missing scope in the access token
    Given the header "Authorization" is set to an access token without the required scope
    And the request body is set to a valid request body
    When the request "retrieveLocation" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Error code 404

  @location_retrieval_404_unable_to_locate_device
  # Input set to a device that could not be located
  Scenario: Unable to provide device location
    Given a valid testing device which cannot be located by the network operator, identified by the token or provided in the request body

    And the request body property "$.maxAge" is not included
    When the request "retrieveLocation" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "LOCATION_RETRIEVAL.DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # HTTP - 422

  @location_retrieval_422.1_unable_to_fulfill_max_surface
  Scenario: Unable to provide device location with required maxSurface
    Given the testing device, identified by the token or provided in the request, is located by the network operator within a surface of certain area

    And the request body property "$.maxSurface" is set to a value smaller than that area
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_SURFACE"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_422.2_unable_to_locate_device_with_required_freshness
  Scenario: Unable to provide device location with required maxAge
    Given the testing device, identified by the token or provided in the request, is not connected to the network for some time
    And the request body property "$.maxAge" is set to a value shorter than that time
    When the request "retrieveLocation" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_AGE"
    And the response property "$.message" contains a user friendly text