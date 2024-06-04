Feature: CAMARA Device location retrieval  API, v0.2.0 - Operation retrieveLocation
  # Input to be provided by the imnplementation to the tester
  #
  # Implementation indications:
  # * identifier_types_unsupported: List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  # * device_not_applicable: A device object identifying a device commercialized by the implemenation for which the service is not applicable
  # * locatable_device: A device object which location is known by the network when connected. 2 distinct device are required for some scenario.
  # * unlocatable_device: A device object which location cannot be provided during test by the network.
  # Environment variables:
  # * api_root: API root of the server URL
  #
  # References to OAS spec schemas refer to schemas specifies in location-retrieval.yaml, version 0.2.0

  Background: Common retrieveLocation setup
    Given the resource "/location-retrieval/v0/retrieve"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  # Happy path scenarios

  # This first scenario serves as a minimum
  @location_retrieval_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given the request body property "$.device" is set to config_var: "locatable_device"
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/Location"

  # The following succeess scenarios test that service is working as expected in terms of quality
  # TBD the level of testing for successs scenarios

  @location_retrieval_02_location_retrieval_for_device_no_maxAge
  Scenario: Retrieve location of a device without specifying maxAge
    Given the testing device is connected to the network
    And the request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.maxAge" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Location"


  @location_retrieval_03_location_retrieval_for_device_with_maxAge
  Scenario Outline: Retrieve location of a device specifying maxAge
    # maxAge could be tested with several values with scenario variable
    Given the testing device is connected to the network
    And the request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.maxAge" is set to: <max_age_value>
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Location"
    And the response property "$.lastLocationTime" value is not older than 600 seconds from the request time

    Examples:
      | max_age_value |
      | 60            |
      | 0             |
      | 6000          |


  @location_retrieval_04_location_retrieval_unable_to_locate_device
  # Input area  set to a value where the device could not be located
  Scenario: Unable to provide device location without requesting maxAge
    Given the request body property "$.device" is set to config_var: "unlocatable_device"
    And the request body property "$.maxAge" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "LOCATION_RETRIEVAL.DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @location_retrieval_05_location_retrieval_unable_to_locate_device_with_required_freshness
  Scenario: Unable to provide device location with required maxAge
    Given the testing device is not connected to the network for more than 60 seconds
    And request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.maxAge" is set to: 60
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_AGE"
    And the response property "$.message" contains a user friendly text

  # Generic device errors. Scenarios common to several APIs could be maintained in Commonalities
  # And get specific test numbers

  @location_retrieval_10_device_empty
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to empty object
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_11_device_schema_compliant
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

  @location_retrieval_11.1_device_phoneNumber_schema_compliant
  # Example of the scenario above with a higher level of specification
  # TBD if test plan has to provide specific testing values to provoke an error
  Scenario Outline: Device identifier phoneNumber value does not comply with the schema
    Given the request body property "$.device.phoneNumber" is set to: <phone_number_value>
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
    Given that config_var "identifier_types_unsupported" is not empty
    And the request body property "$.device" only includes properties in config_var "identifier_types_unsupported"
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_DEVICE_IDENTIFIERS"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_13_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the request body property "$.device" is set to a value compliant to the OAS schema at "/components/schemas/Device" which does not identify a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_14_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    # To test this, at least 2 types of identifiers have to be provided, e.g. a phoneNumber and the IP address of a device associated to a different phoneNumber
    Given that config_var "identifier_types_unsupported" contains at least 2 items
    And the request body property "$.device" is set to several identifiers, each of them identifying a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "DEVICE_IDENTIFIERS_MISMATCH"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_15_device_token_mismatch
  Scenario: Inconsistent access token context for the device
    # To test this, a token have to be obtained for a different device
    Given the request body property "$.device" is set to config_var: "locatable_device"
    And the header "Authorization" is set to a valid access token identifying a different device
    When the HTTP "POST" request is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "DEVICE_INVALID_TOKEN_CONTEXT"
    And the response property "$.message" contains a user friendly text

  @location_retrieval_16_device_not_supported
  Scenario: Service not available for the device
    Given that config_var: "device_not_applicable" is not empty
    And the request body property "$.device" is set to config_var: "device_not_applicable"
    And the header "Authorization" is set to a valid access token identifying a different device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "DEVICE_NOT_APPLICABLE"
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

  @location_retrieval_400.2_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Other specific 400 errors

  @location_retrieval_400.3_max_age_schema_compliant
  Scenario: Input property values doe not comply with the schema
    Given the request body property "$.device" is set to config_var: "locatable_device"
    And the "maxAge" is set to 6a0
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text


  @location_retrieval_400.4_required_device_identifier_missing
  Scenario: Required device identifier is  missing
    Given the request body property "$.device" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @location_retrieval_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @location_retrieval_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @location_retrieval_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
