Feature: CAMARA Device location retrieval API, v0.5.0-rc.1 - Operation retrieveLocation
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
    Given the resource "/location-retrieval/v0.5rc1/retrieve"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema

  # Happy path scenarios

  # This first scenario serves as a minimum
  @location_retrieval_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    # Not that in case the device is identifed by the token the body could be {}
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Location"

  # Scenarios testing specific situations for the device location

  @location_retrieval_02_location_retrieval_for_device_no_maxAge
  Scenario: Retrieve location of a device without specifying maxAge
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.maxAge" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Location"

  @location_retrieval_03_location_retrieval_for_device_with_maxAge
  Scenario: Retrieve location of a device specifying maxAge
    # maxAge could be tested with several values with scenario variable
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request body property "$.device" is set to a valid testing device supported by the service
    And the request body property "$.maxAge" is included
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Location"
    And the response property "$.lastLocationTime" value is not older than the value of "$.maxAge" the request time

  @location_retrieval_04_location_retrieval_unable_to_locate_device
  # Input set to a device that could not be located
  Scenario: Unable to provide device location
    Given a valid testing device which cannot be located by the network, identified by the token or provided in the request body
    And the request body property "$.maxAge" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_LOCATE"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_05_location_retrieval_unable_to_locate_device_with_required_freshness
  Scenario: Unable to provide device location with required maxAge
    Given the testing device, identified by the token or provided in the request, is not connected to the network for some time
    And request body property "$.device" is set to a valid testing device which is not connected to the network for some time
    And the request body property "$.maxAge" is set to a value shorter than that time
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_AGE"
    And the response property "$.message" contains a user friendly text

  # Error scenarios for object device

  @location_retrieval_10_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is set to: {}
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_11_device_identifiers_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
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

  @location_retrieval_11.1_device_phoneNumber_schema_compliant
  # Example of the scenario above with a higher level of specification
  # TBD if test plan has to provide specific testing values to provoke an error
  Scenario Outline: Device identifier phoneNumber value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device.phoneNumber" is set to: <phone_number_value>
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | phone_number_value |
      | string_value       |
      | 1234567890         |
      | +12334foo22222     |
      | +00012230304913849 |
      | 123                |
      | ++49565456787      |

  @location_retrieval_12_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIERS"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_13_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the request body property "$.device" is set to a value compliant to the OAS schema at "/components/schemas/Device" but does not identify a valid device
    And the header "Authorization" is set to a valid access token which does not identify a single device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_14_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    # To test this, at least 2 types of identifiers have to be provided, e.g. a phoneNumber and the IP address of a device associated to a different phoneNumber
    Given that config_var "identifier_types_unsupported" contains at least 2 items
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "IDENTIFIER_MISMATCH"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_15_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_16_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the operator
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_17_device_identifier_missing
  Scenario: Required device identifier is  missing
    Given the request body property "$.device" is not included
    And the header "Authorization" is set to a valid access token which does not identify a single device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  # Scenario specific to maxSurface

  @location_retireval_18_unable_to_fulfill_max_surface
  Scenario: Unable to provide device location with required maxSurface
    Given the testing device, identified by the token or provided in the request, is located within a surface of certain area
    And the request body property "$.maxSurface" is set to a value smaller than that area
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_SURFACE"
    And the response property "$.message" contains a user friendly text
  
  # Generic 400 errors

  @location_retrieval_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Other specific 400 errors

  @location_retrieval_400.3_max_age_schema_compliant
  Scenario: Input property values doe not comply with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the "maxAge" is set to 6a0
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @location_retrieval_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_403_missing_scope
  Scenario: Missing scope in the access token
    Given the header "Authorization" is set to an access token without the required scope
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
