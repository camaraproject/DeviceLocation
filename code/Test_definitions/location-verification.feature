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
  # References to OAS spec schemas refer to schemas specifies in location-verification.yaml

  Background: Common verifyLocation setup
    Given the resource "/location-verification/vwip/verify"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  # This first scenario serves as a minimum, not testing any specific verificationResult
  @location_verification_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.area" is set to a valid area covered by the service
    When the request "verifyLocation" is sent
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
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.area" is set to a valid area covered by the service where the device is located
    And the request body property "$.maxAge" is not included
    When the request "verifyLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is one of: ["TRUE", "PARTIAL"]
    And the response property "$.lastLocationTime" exists
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"

  @location_verification_03_known_location_for_device_with_maxAge
  Scenario: Known location of a device specifying maxAge
    Given a valid testing device supported by the service identified, by the token or provided in the request body
    And the request body property "$.area" is set to a valid area covered by the service where the device is located
    And the request body property "$.maxAge" is included
    When the request "verifyLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is one of: ["TRUE", "PARTIAL"]
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"
    And the response property "$.lastLocationTime" value is not older than the value of "$.maxAge" in the request

  @location_verification_04_false_location_for_device
  Scenario: False location of a device
    Given a valid testing device supported by the service identified, by the token or provided in the request body
    And the request body property "$.area" is set to a valid area covered by the service where the device is not located
    When the request "verifyLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "FALSE"
    And the response property "$.lastLocationTime" exists
    And the response property "$.matchRate" does not exist

  @location_verification_05_unknown_location_for_device
  Scenario: Unknown location of a device without specifying maxAge
    Given a valid testing device supported by the service, identified by the token or provided in the request body, for which there is no historical location information
    And the request body property "$.maxAge" is not included
    And the request body property "$.area" is set to a valid area covered by the service
    When the request "verifyLocation" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "UNKNOWN"
    And the response property "$.lastLocationTime" does not exist
    And the response property "$.matchRate" does not exist

  # Error scenarios for management of input parameter device

  @location_verification_C01.01_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is set to: {}
    When the request "verifyLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @location_verification_C01.02_device_identifiers_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the request "verifyLocation" is sent
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


  # This scenario may happen e.g. with 2-legged access tokens, which do not identify a single device.
  @location_verification_C01.03_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is compliant with the schema but does not identify a valid device
    When the request "verifyLocation" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @location_verification_C02.04_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text


  @location_verification_C01.05_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text


  @location_verification_C01.06_unsupported_device
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text


  # When the service is only offered to certain types of devices or subscriptions, e.g. IoT, B2C, etc.
  @location_verification_C01.07_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the operator
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text


  # Several identifiers provided but they do not identify the same device
  # This scenario may happen with 2-legged access tokens, which do not identify a device
  @location_verification_C01.08_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And at least 2 types of device identifiers are supported by the implementation
    And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "IDENTIFIER_MISMATCH"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @location_verification_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "verifyLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_verification_400.2_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the request "verifyLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Other specific 400 errors

  @location_verification_400.3_other_input_properties_schema_not_compliant
  # Test other input properties in addition to device
  Scenario Outline: Input property values doe not comply with the schema
    Given the request body property "<input_property>" does not comply with the OAS schema at <oas_spec_schema>
    When the request "verifyLocation" is sent
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
    When the request "verifyLocation" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | input_property          |
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
    When the request "verifyLocation" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the request "verifyLocation" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the request "verifyLocation" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 error

  @location_verification_403_missing_scope
  Scenario: Missing scope in the access token
    Given the header "Authorization" is set to an access token without the required scope
    And the request body is set to a valid request body
    When the request "verifyLocation" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # 422 error codes

  @location_verification_422.1_area_not_covered
  Scenario: Area not covered
    Given a valid testing device supported by the service identified, by the token or provided in the request body
    And the request body property "$.area" is set to an area not covered by the implementation
    And the request body property "$.maxAge" is not included
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_VERIFICATION.AREA_NOT_COVERED"
    And the response property "$.message" contains a user-friendly text


  @location_verification_422.2_area_too_small
  Scenario: Area too small
    Given that there is a minimum radius allowed by the implementation 
    And a valid testing device supported by the service identified, by the token or provided in the request body
    And the request body property "$.area.areaType" is set to "CIRCLE" 
    And the request body property "$.area.center" is set to a location covered by the implementation
    And the request body property "$.area.radius" is set to a value smaller than the minimum allowed
    And the request body property "$.maxAge" is not included
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_VERIFICATION.INVALID_AREA"
    And the response property "$.message" contains a user-friendly text


  @location_verification_422.3_unable_to_fulfill_max_age
  Scenario: Unable to fulfill max age
    Given a valid testing device supported by the service, identified by the token or provided in the request body, which is not connected to the network for some time
    And the request body property "$.maxAge" is set to a value shorter than that time
    And the request body property "$.area" is set to a valid area covered by the service
    When the request "verifyLocation" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_VERIFICATION.UNABLE_TO_FULFILL_MAX_AGE"
    And the response property "$.message" contains a user-friendly text
