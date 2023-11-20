Feature: Get a device location (POST /retrieve)

  @Test_Retrieve_location_not_by_ipv4Address
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


  @Test_Retrieve_location_by_ipv4Address
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


  @Test_Retrieve_location_Invalid_MaxAge
  Scenario: Input an invalid maxAge value (less than 60)
    Given a valid device identified with phoneNumber +34666111333
    When a retrieve request is made with a valid maxAge parameter of 59
    Then the response status code should be 400
    And the response body should contain an error message indicating an invalid argument


  @Test_Retrieve_location_Missing_MaxAge
  Scenario: Input did not feature a maxAge
    Given a valid device identified with phoneNumber +34666111333 
    When a retrieve request is made without a maxAge parameter
    Then the response status code should be 400
    And the response body should contain an error message indicating an invalid argument


  @Test_Missing_Device_Identifier
  Scenario: Perform a request without a device identifier
    When a Check SimSwap request is made without a deviceIdentifier 
    Then the response status code should be 400
    And the response should contain an error message indicating a missing field


  @Test_Unknown_Device_Identifier
  Scenario: Input an unknown device identifier
    Given a device identified by +33999999999
    When a retrieve request is made
    Then the response status code should be 404
    And the response should contain an error message indicating that the specified resource is not found


  @Test_Unauthorized_Request
  Scenario: Perform an unauthorized request
    Given that the requester is unauthorized 
    When a retrieve request is made 
    Then the response status code should be 401
    And the response should contain an error message indicating unauthorized access


  @Test_Inconsistency_Access_Token_Payload   
  Scenario: Perform an request
    Given the phoneNumber +33666111333 is retrieved from the authentification step
    And the phoneNumber <bodyPhoneNumber> is provided in the body
    And a provided maxAge of 80 seconds
    When a retrieve request is made 
    Then the response status code should be <code>>

    Examples
    | bodyPhoneNumber| code   |
    | null           | 200    |
    | +33666111333   | 200    |
    | +33666111339   | 401    |