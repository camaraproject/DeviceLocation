Feature: Get a device location (POST /retrieve)

  @location_retrieval_01_by_phoneNumber_or_ipv4Address_or_networkAccessIdentifier
  Scenario: Get the location of a device
    Given a valid device <device> identified by a <deviceIdentierName> <deviceIdentierValue>
    And a provided maxAge of 80 seconds
    When a retrieve device location request is made 
    Then the response status code should be 200
    And the response body should provide a valid area 

    Examples:
        | deviceIdentifierName     |  deviceIdentifierValue                 |   
        | phoneNumber              |  +34666111333                          |   
        | networkAccessIdentifier  |  123456789@domain.com                  |   
        | ipv6Address              |  2001:db8:85a3:8d3:1319:8a2e:370:7344  |   


  @location_retrieval_02_by_ipv4Address
  Scenario: Get the location of a device
    Given a valid device <device> identified by a <publicAddress> <privateAddress> <port>
    And a provided maxAge of 80 seconds
    When a retrieve device location request is made 
    Then the response status code should be 200
    And the response body should provide a valid area 

    Examples:
      | publicAddress  | privateAddress  | publicPort  | 
      | 84.125.93.10   | null            | 59765       | 
      | 84.125.93.10   | 84.125.93.10    | null        |    


  @location_retrieval_03_Missing_MaxAge
  Scenario: Input did not feature a maxAge
    Given a valid device identified with phoneNumber +34666111333 
    When a retrieve request is made without a maxAge parameter
    Then the response status code should be 200
    And the response body should provide a valid area


  @location_retrieval_04_unretrieval_Device
  Scenario: Device location cannot be returned
    Given a device switch off for more than 100 seconds identified with phoneNumber +34666111333 
    When a provided maxAge of 80 seconds
    Then the response status code should be 400
    And the response should contain error code 'LOCATION_RETRIEVAL.MAXAGE_INVALID_ARGUMENT'


  @location_retrieval_05_Invalid_MaxAge
  Scenario: Input an invalid maxAge value (less than 60)
    Given a valid device identified with phoneNumber +34666111333
    When a retrieve request is made with a valid maxAge parameter of 59
    Then the response status code should be 400
    And the response should contain error code 'INVALID_ARGUMENT'


  @location_retrieval_06_Missing_Device_Identifier
  Scenario: Perform a request without a device identifier
    When a Check SimSwap request is made without a deviceIdentifier 
    Then the response status code should be 400
    And the response should contain error code 'INVALID_ARGUMENT'


  @location_retrieval_07_Unknown_Device_Identifier
  Scenario: Input an unknown device identifier
    Given a device identified by +33999999999
    When a retrieve request is made
    Then the response status code should be 404
    And the response should contain error code 'NOT_FOUND'


  @location_retrieval_08_Unauthenticated_Request
  Scenario: Perform an unauthenticated request
    Given that the requester is not authenticated
    When a retrieve request is made 
    Then the response status code should be 401
    And the response should contain error code 'UNAUTHENTICATED'


  @location_retrieval_09_Unauthorized_Request
  Scenario: Perform an unauthorized request
    Given that the requester is authenticated but not authorized for this API
    When a retrieve request is made 
    Then the response status code should be 403
    And the response should contain error code 'PERMISSION_DENIED'



  @location_retrieval_010_Inconsistency_Access_Token_Payload   
  Scenario: Perform an request
    Given the phoneNumber +33666111333 is retrieved from the authentification step
    And the phoneNumber <bodyPhoneNumber> is provided in the body
    And a provided maxAge of 80 seconds
    When a retrieve request is made 
    Then the response status code should be <<status>> and <code>>

    Examples
    | bodyPhoneNumber| status | code                |
    | null           | 200    | OK                  |
    | +33666111333   | 200    | OK                  |
    | +33666111339   | 403    | 'PERMISSION_DENIED' |
