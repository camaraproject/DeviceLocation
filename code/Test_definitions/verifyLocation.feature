Feature: Device location verification API - verifyLocation

    Background: An environment where Kernel API GW exposes verifyLocation
        Given an environment with Kernel API GW
        And the endpoint "location/v0/verify"
        And the method "post"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "123456789",
                "ipv4Addr": "123.456.789.000"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        And the header "x-correlator" is set to "[UUIDv4]"

    @verifyLocation_30.01_VerifyRightLocationGenericMsisdn
    Scenario: Verify known location from MSISDN
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true

    @verifyLocation_E10.01
    @kernel-apigw
    Scenario: Error response for expired access token
        Given I want to test "verifyLocation"
        And an expired Kernel access_token
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "401"
        And the response value for "$.status" is "401"
        And the response value for "$.code" is "UNAUTHENTICATED"
        And the response value for "$.message" is a human-friendly text


    @verifyLocation_E10.02
    @kernel-apigw
    Scenario: Error response for invalid access token
        Given I want to test "verifyLocation"
        And an invalid Kernel access_token
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "401"
        And the API returns the error code "UNAUTHENTICATED"
        And the API returns a human readable error message


    @verifyLocation_E10.03
    @kernel-apigw
    Scenario: Error response for no header "Authorization"
        Given I want to test "verifyLocation"
        And the header "Authorization" is not sent
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "401"
        And the API returns the error code "UNAUTHENTICATED"
        And the API returns a human readable error message


    # API Specific Errors

    # Provided location is correct but network information is not available
    @verifyLocation_E19.01_VerifyUnknownLocationGenericMsisdn
    @specific-user
    Scenario: Verify location from MSISDN without location information
        Given I want to test "verifyLocation" for a user of the OB which have an MSISDN not connected to the network
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to a valid MSISDN for a mobile device without recent location information
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "404"
        And the API returns the error code "NOT_FOUND"
        And the API returns a human readable error message


    @verifyLocation_E19.02_MissingUeId
    @expand-by-user-type
    Scenario: Error response for missing required property "ueId" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the request body is set to:
            """
            {
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message


    @verifyLocation_E19.03_MissingLatitude
    @expand-by-user-type
    Scenario: Error response for missing required property "latitude" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message


    @verifyLocation_E19.04_MissingLongitude
    @expand-by-user-type
    Scenario: Error response for missing required property "longitude" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message


    @verifyLocation_E19.05_MissingAccuracy
    @expand-by-user-type
    Scenario: Error response for missing required property "accuracy" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": 0,
              "longitude": 0
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message


    @verifyLocation_E19.06_EmptyUeId
    @expand-by-user-type
    Scenario: Error response for empty required property "ueId" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the request body is set to:
            """
            {
              "ueId": {},
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message


    @verifyLocation_E19.07_WrongUeIdMsisdn
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.ueId.msisdn" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to "<wrong_msisdn>"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_msisdn       |
            | foo                |
            | +00012230304913849 |
            | 123                |
            | ++49565456787      |


    @verifyLocation_E19.08_WrongLatitude
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.latitude" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to <wrong_latitude>
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_latitude |
            | foo            |
            | -100           |
            | 100            |
            | 10.12.34       |


    @verifyLocation_E19.09_WrongLongitude
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.longitude" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: longitude]" is set to <wrong_longitude>
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": 0,
              "longitude": [CONTEXT: longitude],
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_longitude |
            | foo             |
            | -200            |
            | 200             |
            | 10.12.34        |


    @verifyLocation_E19.10_WrongAccuracy
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.accuracy" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: accuracy]" is set to <wrong_accuracy>
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": [CONTEXT: accuracy]
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_accuracy |
            | foo            |
            | 0              |
            | -5             |
            | 250            |
            | 2,5            |


    @verifyLocation_E19.11_WrongUePort
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.uePort" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipv4Addr]" is set to the public IPv4 address observed for the mobile device suitable for location verification
        And the variable "[CONTEXT: uePort]" is set to <wrong_ue_port>
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "ipv4Addr": [CONTEXT: ipv4Addr]"
              },
              "uePort": [CONTEXT: uePort]
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_ue_port |
            | foo           |
            | -5            |
            | 70000         |
            | 10.5          |


    @verifyLocation_E19.12_WrongUeIdIPv4
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.ueId.ipv4Addr" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipv4Addr]" is set to "<wrong_ip>"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "ipv4Addr": "[CONTEXT: ipv4Addr]"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_ip        |
            | foo             |
            | 435.567.999.000 |
            | 123.456.789.0.1 |
            | 12345667890     |


    @verifyLocation_E19.13_WrongUeIdIPv6
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.ueId.ipv6addr" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipv6Addr]" is set to "<wrong_ip>"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "ipv6Addr": "[CONTEXT: ipv6Addr]"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_ip                                 |
            | foo                                      |
            | 2001:0db8:3333:4444:55556666:7777:8888   |
            | 2001:0db8:3333:4444:5555:6666:77:77:8888 |
            | 2001:gdb8:3333:4444:5555:6666:7777:8888  |


    @verifyLocation_E19.14_WrongUeIdExternalId
    @expand-by-user-type
    Scenario Outline: Error response for wrong property "$.ueId.externalId" in request body
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: externalId]" is set to "<wrong_externalId>"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "externalId": "[CONTEXT: externalId]"
              },
              "latitude": 0,
              "longitude": 0,
              "accuracy": 10
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | wrong_externalId |
            | foo              |


    @verifyLocation_E19.15_IPNotBelongingToTheSameDeviceAsMSISDN
    @expand-by-user-type
    Scenario Outline: Error response when using an IP address with format IPv4 or IPv6 that does not belong to the device associated with the provided phone number
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipFormat]" is set to "<ip_format>"
        And the variable "[CONTEXT: ipAddr]" is set to valid ip of format "[CONTEXT: ipFormat]" but not associated with the same mobile device that is associated with the msisdn of the variable "[CONTEXT: msisdn]"
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "[CONTEXT: ipFormat]": "[CONTEXT: ipAddr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "400"
        And the API returns the error code "INVALID_INPUT"
        And the API returns a human readable error message

        Examples:
            | ip_format |
            | ipv4Addr  |
            | ipv6Addr  |


    # API Specific validations

    # Expected accuracy set to the maximun to relax the constraint
    @verifyLocation_30.01_VerifyRightLocationGenericMsisdn
    Scenario: Verify known location from MSISDN
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    # A public identifier addressing a subscription in a mobile network. In 3GPP terminology, it corresponds to the GPSI formatted with the External Identifier ({Local Identifier}@{Domain Identifier}). Unlike the telephone number, the network access identifier is not subjected to portability ruling in force, and is individually managed by each operator.
    @verifyLocation_30.02_VerifyRightLocationGenericExternalId
    @expand-by-user-type
    Scenario: Verify known location from external id
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: externalId]" is set to the external identifier associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "externalId": "[CONTEXT: externalId]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.03_VerifyRightLocationGenericIPV4AddressNoNAT
    @expand-by-user-type
    Scenario: Verify known location from public IPV4 Address, for deployments without NAT
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: ipv4Addr]" is set to the public IPv4 address observed for the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "ipv4Addr": "[CONTEXT: ipv4Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.04_VerifyRightLocationGenericIPV6Address
    @expand-by-user-type
    Scenario: Verify known location from IPV6 Address
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: ipv6Addr]" is set to the IPv6 address associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "ipv6Addr": "[CONTEXT: ipv6Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.05_VerifyRightLocationGenericIPV4AddressNAT
    @expand-by-user-type
    Scenario: Verify known location from public IPV4 Address and Port, for deployments with NAT
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: ipv4Addr]" is set to the public IPv4 address observed for the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the variable "[CONTEXT: uePort]" is set to the Device port observed for the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "ipv4Addr": "[CONTEXT: ipv4Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200,
              "uePort": [CONTEXT: uePort]
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    # If ipv6 is specified as ueId, the uePort can be specified although it is not necessary.
    @verifyLocation_30.06_VerifyRightLocationGenericIPV6AddressAndPort
    @expand-by-user-type
    Scenario: Verify known location from public IPV6 Address and Port
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: ipv6Addr]" is set to the IPv6 address associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the variable "[CONTEXT: uePort]" is set to the Device port observed for the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "ipv6Addr": "[CONTEXT: ipv6Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200,
              "uePort": [CONTEXT: uePort]
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.07_VerifyRightLocationMsisdnIPV4NAT
    @expand-by-user-type
    Scenario: Verify known location of a device using msisdn and IPV4 address and port
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipv4Addr]" is set to the IPv4 address associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the variable "[CONTEXT: uePort]" is set to the Device port observed for the mobile device suitable for location verification
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "ipv4Addr": "[CONTEXT: ipv4Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200,
              "uePort": [CONTEXT: uePort]
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.08_VerifyRightLocationMsisdnIPV6
    @expand-by-user-type
    Scenario: Verify known location of a device using msisdn and IPV6 address
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: ipv6Addr]" is set to the IPv6 address associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]",
                "ipv6Addr": "[CONTEXT: ipv6Addr]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.09_VerifyWrongLocationGenericMsisdn
    @expand-by-user-type
    Scenario: Verify wrong location from MSISDN
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to a value that does not match with the device location latitude
        And the variable "[CONTEXT: longitude]" is set to a value that does not match with the device location longitude
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 2
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is false


    @verifyLocation_30.10_SuccessfulNonExistingQueryParam
    @expand-by-user-type
    Scenario: Success with a non-existing query param
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the query params are set to
            | param_name          | param_value |
            | invalid_query_param | whatever    |
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true


    @verifyLocation_30.11_CheckXCorrelator
    @expand-by-user-type
    Scenario Outline: Check consistency of x-correlator
        Given I want to test "verifyLocation"
        And a valid Kernel access_token
        And the variable "[CONTEXT: msisdn]" is set to the MSISDN associated with the mobile device suitable for location verification
        And the variable "[CONTEXT: latitude]" is set to the well known latitude where the device under test is located
        And the variable "[CONTEXT: longitude]" is set to the well known longitude where the device under test is located
        And the header "x-correlator" is set to "<value>"
        And the request body is set to:
            """
            {
              "ueId": {
                "msisdn": "[CONTEXT: msisdn]"
              },
              "latitude": [CONTEXT: latitude],
              "longitude": [CONTEXT: longitude],
              "accuracy": 200
            }
            """
        When a "POST" request to "/location-verification/v0" is sent
        Then the response status code is "200"
        And the value of header "x-correlator" in response is the one set in request
        And the response has header "Content-Type" set to "application/json"
        And the response body complies with the JSON-Schema at "./schemas/_spec/verifyLocation_200.json"
        And the value of response property "$.verificationResult" is true

        Examples:
            | value              |
            | [UUIDv4]           |
            | [RANDOM: STR(64)]  |
            | string with spaces |
            | "quoted string"    |