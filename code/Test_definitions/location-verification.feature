Feature: CAMARA Device location verification API, vwip - Operation verifyLocation
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  # * A device object which location is known by the network when connected. To test all scenarios, at least 2 valid devices are needed
  # * The known location of the testing devices
  # * A device object identifying a device commercialized by the implementation for which the service is not applicable, if any
  #
  # References to OAS spec schemas refer to schemas specifies in location-verification.yaml, version 0.2.0

  Background: Common verifyLocation setup
    Given the resource "/location-verification/v0/verify"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  # This first scenario serves as a minimum, not testing any specific verificationResult
  @location_verification_01_generic_success_scenario
  Scenario: Common validations for any sucess scenario
    # Valid testing device and default request body compliant with the schema
    Given the request body property "$.device" is set to a valid testing device supported by the service
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    # Additionally any success response has to comply with some constraints not documented in the schema
    And if the response property "$.lastLocationTime" does not exists then "$.verificationResult" is "UNKNOWN"
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"

  # Scenarios testing specific situations for the device location 

  @location_verification_02_known_location_for_device_no_maxAge
  Scenario: Known location of a device without specifying maxAge
    Given the request body property "$.device" is set to a valid testing device located by the network
    And the request body property "$.area" is set to the known location of the device
    And the request body property "$.maxAge" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is one of: ["TRUE", "PARTIAL"]
    And the response property "$.lastLocationTime" exists
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"


  @location_verification_03_known_location_for_device_with_maxAge
  Scenario Outline: Known location of a device specifying maxAge
    Given the request body property "$.device" is set to a valid testing device located by the network
    And the request body property "$.area" is set to the known location of the device
    And the request body property "$.maxAge" is included
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is one of: ["TRUE", "PARTIAL"]
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"
    And the response property "$.lastLocationTime" value is not older than the value of "$.maxAge" in the request


  @location_verification_04_false_location_for_device
  Scenario: False location of a device
    Given the request body property "$.device" is set to a valid testing device located by the network
    And the request body property "$.area" is set to a wrong location of the device
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "FALSE"
    And the response property "$.lastLocationTime" exists
    And the response property "$.matchRate" does not exist


  @location_verification_05_unknown_location_for_device
  Scenario: Unknown location of a device specifying maxAge
    Given the request body property "$.device" is set to a valid testing device which is not connected to the network for some time
    And the request body property "$.maxAge" is set to a value shorter than that time
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "UNKNOWN"
    And the response property "$.lastLocationTime" if exists has a value older the value of "$.maxAge" in the request
    And the response property "$.matchRate" does not exist

  # Error scenarios for object device

  @location_verification_10_device_empty
  Scenario Outline: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_verification_11_device_identifiers_not_schema_compliant
  # Test every type of identifier even if not supported by the implementation
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier          | oas_spec_schema                             |
      | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
      | $.device.ipv4Address       | /components/schemas/NetworkAccessIdentifier |
      | $.device.ipv6Address       | /components/schemas/DeviceIpv4Addr          |
      | $.device.networkIdentifier | /components/schemas/DeviceIpv6Address       |

  @location_verification_12_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_DEVICE_IDENTIFIERS"
    And the response property "$.message" contains a user friendly text

  @location_verification_13_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @location_verification_14_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    Given that al least 2 types of device identifiers are supported by the implementation
    And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "DEVICE_IDENTIFIERS_MISMATCH"
    And the response property "$.message" contains a user friendly text

  @location_verification_15_device_token_mismatch
  Scenario: Inconsistent access token context for the device
    # To test this, a token have to be obtained for a different device
    Given the request body property "$.device" is set to a valid testing device
    And the header "Authorization" is set to a valid access token emitted for a different device
    When the HTTP "POST" request is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "INVALID_TOKEN_CONTEXT"
    And the response property "$.message" contains a user friendly text

  @location_verification_16_device_not_supported
  Scenario: Service not available for the device
    Given that service is not supported for all devices commercialized by the operator 
    And the request body property "$.device" is set to a valid device for which the service is not applicable
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "DEVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @location_verification_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_verification_400.2_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Other specific 400 errors

  @location_verification_400.3_other_input_properties_schema_not_compliant
  # Test other input properties in addition to device
  Scenario Outline: Input property values doe not comply with the schema
    Given the request body property "<input_property>" does not comply with the OAS schema at <oas_spec_schema>
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | input_property          | oas_spec_schema                                      |
      | $.area.areaType         | /components/schemas/AreaType                         |
      | $.area.center.latitude  | /components/schemas/Latitude                         |
      | $.area.center.longitude | /components/schemas/Longitude                        |
      | $.area.radius           | /components/schemas/Circle/allOf/1/properties/radius |
      | $.maxAge                | /components/schemas/MaxAge                           |

  @location_verification_400.4_required_input_properties_missing
  Scenario Outline: Required input properties are missing
    Given the request body property "<input_property>" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | input_property          |
      | $.device                |
      | $.area                  |
      | $.area.areaType         |
      | $.area.center           |
      | $.area.center.latitude  |
      | $.area.center.longitude |
      | $.area.radius           |

  # Generic 401 errors

  @location_verification_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
