Feature: CAMARA Device location verification API, v0.2.0 - Operation verifyLocation
  # Input to be provided by the imnplementation to the tester
  #
  # Implementation indications:
  # * identifier_types_unsupported: List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  # * device_not_applicable: A device object identifying a device commercialized by the implemenation for which the service is not applicable
  #
  # Environment variables:
  # * api_root: API root of the server URL
  # * locatable_device: A device object which location is known by the network when connected. To test all scenarios, at least 2 valid devices are needed
  # * known_latitude: The latitude where locatable_device is known to be located
  # * known_longitude | The longitude where locatable_device is known to be located
  #
  # References to OAS spec schemas refer to schemas specifies in location-verification.yaml, version 0.2.0

  Background: Common verifyLocation setup
    Given the resource "/location-verification/v0/verify"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  # Happy path scenarios

  # This first scenario serves as a minimum, not testing any specific verificationResult
  @location_verification_01_generic_success_scenario
  Scenario: Common validations for any sucess scenario
    # Valid testing device and default request body compliant with the schema
    Given the request body property "$.device" is set to config_var: "locatable_device"
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    # Additionally any success response has to comply with implementation guidelines
    And if response property "$.lastLocationTime" does not exists then "$.verificationResult" is "UNKNOWN"
    And the response property "$.matchRate" exists only if "$.verificationResult" is "PARTIAL"

  # The following succeess scenarios test that service is working as expected in terms of quality
  # TBD the level of testing for successs scenarios

  @location_verification_02_known_location_for_device_no_maxAge
  Scenario: Known location of a device without specifying maxAge
    Given the testing device is connected to the network
    And the request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.area.areaType" is set to: "CIRCLE"
    And the request body property "$.area.center.latitude" is set to config_var: "known_latitude"
    And the request body property "$.area.center.longitude" is set to config_var: "known_longitude"
    And the request body property "$.area.radius" is set to: 10000
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
    # Alternative, setting request body with a JSON object
    # maxAge is set to fixed value, it could be tested with several values in an Scenario Outline
    Given the testing device is connected to the network
    And the request body is set to:
      """
      {
        "device": <config_var:locatable_device>,
        "area": {
          "areaType": "CIRCLE",
          "center": {
            "latitude": <config_var:known_latitude>,
            "longitude": <config_var:known_longitude>
          },
          "radius": 10000
        },
        "maxAge": 600
      }
      """
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    # Alternative, specifying additional response validations with a JSON schema, which has to be complied additionally
    And the response body complies with JSON schema:
      """
      {
        "type": "object",
        "properties": {
          "verificationResult": {
            "enum": [
              "TRUE",
              "PARTIAL"
            ]
          }
        },
        "required": [
          "lastLocationTime"
        ],
        "dependentSchemas": {
          "matchRate": {
            "properties": {
              "verificationResult": {
                "enum": [
                  "PARTIAL"
                ]
              }
            }
          }
        }
      }
      """
    And the response property "$.lastLocationTime" value is not older than 600 seconds from the request time

  @location_verification_04_false_location_for_device_with_maxAge
  # Input area  set to a value where the device is not located for sure
  Scenario: False location of a device specifying maxAge
    Given the testing device is connected to the network
    And the request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.area.areaType" is set to: "CIRCLE"
    And the request body property "$.area.center.latitude" is set to: 0
    And the request body property "$.area.center.longitude" is set to: 0
    And the request body property "$.area.radius" is set to: 10000
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "FALSE"
    And the response property "$.lastLocationTime" exists
    And the response property "$.matchRate" does not exist

  @location_verification_05_unknown_location_for_device_with_maxAge
  # Input area can be kept to the default value as recent device location is not known by the network
  Scenario: Unknown location of a device specifying maxAge
    Given the testing device is not connected to the network for more than 60 seconds
    And request body property "$.device" is set to config_var: "locatable_device"
    And the request body property "$.maxAge" is set to: 60
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyLocationResponse"
    And the response property "$.verificationResult" is "UNKNOWN"
    And the response property "$.lastLocationTime" if exists has a value older than 60 seconds from the request time
    And the response property "$.matchRate" does not exist

  # Generic device errors. Scenarios common to several APIs could be maintained in Commonalities
  # And get specific test numbers

  @location_verification_10_device_empty
  Scenario Outline: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @location_verification_11_device_schema_compliant
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

  @location_verification_11.1_device_phoneNumber_schema_compliant
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

  @location_verification_12_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that config_var "identifier_types_unsupported" is not empty
    And the request body property "$.device" only includes properties in config_var "identifier_types_unsupported"
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_DEVICE_IDENTIFIERS"
    And the response property "$.message" contains a user friendly text

  @location_verification_13_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the request body property "$.device" is set to a value compliant to the OAS schema at "/components/schemas/Device" which does not identify a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @location_verification_14_device_identifiers_mismatch
  Scenario: Device identifiers mismatch
    # To test this, at least 2 types of identifiers have to be provided, e.g. a phoneNumber and the IP address of a device associated to a different phoneNumber
    Given that config_var "identifier_types_unsupported" contains at most 2 items
    And the request body property "$.device" is set to several identifiers, each of them identifying a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "DEVICE_IDENTIFIERS_MISMATCH"
    And the response property "$.message" contains a user friendly text

  @location_verification_15_device_token_mismatch
  Scenario: Inconsistent access token context for the device
    # To test this, a token have to be obtained for a different device
    Given the request body property "$.device" is set to config_var: "locatable_device"
    And the header "Authorization" is set to a valid access token identifying a different device
    When the HTTP "POST" request is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "DEVICE_INVALID_TOKEN_CONTEXT"
    And the response property "$.message" contains a user friendly text

  @location_verification_16_device_not_supported
  Scenario: Service not available for the device
    Given that config_var "device_not_applicable" is not empty
    And the request body property "$.device" is set to config_var: "device_not_applicable"
    And the header "Authorization" is set to a valid access token identifying a different device
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

  @location_verification_400.3_other_input_properties_schema_compliant
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
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @location_verification_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
