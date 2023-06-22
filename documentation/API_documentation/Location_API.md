**To be deprecated in v0.2. Current version is not aligned with API spec. This documentation will be integrated and consolidated into the API spec as agreed in Commonalities**

---

# Overview
This API provides the customer with the ability to verify the location of a device. 

## 1\. Introduction
Customers are able to verify whether the location of certain user device is within the area specified by the provided coordinates (latitude and longitude) and some expected accuracy.

## 2\. Quick Start
Device location API v0.1.0 exposes only one endpoint, which can be used to verify device location for user equipment. To do so the user has to pass the following parameters in request body:
1. **ueId** - an object with four fields, each of them make possible to pass ueId in different format: externalId [[1]](#1), msisdn, ipv4Addr and ipv6Addr
2. **uePort** - if a public ipv4Addr is provided for the ueId object, the port allocated to the UE must also be specified
3. **latitude** - double number value for the latitude to be verified in decimal degrees.
4. **longitude** - double number value for the longitude to be verified in decimal degrees.
5. **accuracy** - number value for the expected accuracy in km. The allowed range is between 2 km and 200 km. 

Client asks whether the device location is within a circle with center specified by the latitude and longitude, and radius specified by the accuracy.

Sample API invocation is presented in Section 4.5.

## 3\. Authentication and Authorization
The Device location API makes use of the client credentials grant which is applicable for server to server use cases involving trusted partners or clients without any protected user data involved. In this method the API invoker client is registered as a confidential client with an authorization grant type of client_credentials [[2]](#2).

The Device location API could also be protected through a 3-legged process, in order to be combined with end user consent gathering, before any personal information is provided.

Depending on local legal regulation, network provider may require the 3-legged process to provide location verification.

## 4\. API Documentation

### 4.1 API Version

0.1.0

### 4.2 Details

#### 4.2.1 Endpoint Definition

Following table defines API endpoints of exposed REST based for Device location API operations.

| **Endpoint** | **Operation** | **Description** |
| --- | --- | --- |
| POST /location/v0/verify | **Verify location** | Execute location verification for a user equipment |

#### 4.2.2 Device location API Resource Operations


| **Verify location** |
| --- |
| **HTTP Request** <ul> POST /location/v0/verify</ul> **Query Parameters** <ul> No query parameters are defined.</ul> **Path Parameters** <ul> No path parameter are defined. </ul> **Request Body Parameters** <ul> <li> **ueId**: User equipment identifier object, contains 4 different identifiers, at least 1 has to be set: <ul> <li>**msisdn**: Subscriber number in E.164 format (starting with country code). Optionally prefixed with '+'. </li><li>**ipv4addr**: IPv4 address (supports mask) e.g. 192.168.0.1/24 </li><li>**ipv6addr**: IPv6 address (supports mask) e.g. 2001:db8:85a3:8d3:1319:8a2e:370:7344 </li><li>**externalId**: assigned by the mobile network operator (MNO) for the user equipment. e.g. 123456789@domain.com </li></ul> <li> **uePort (optional):** User equipment port. Device port may be required along with IP address to identify the target device. </li><li> **latitude:**: double number value for the latitude to be verified in decimal degrees. </li><li> **longitude**: double number value for the longitude to be verified in decimal degrees. </li><li> **accuracy**: number value for the expected accuracy in km. </ul> 
**Responses** <br><br> **200**: Returns the result of the location verification. <ul> Response body: <ul><li> **verificationResult**: Result of a verification request, TRUE on match, FALSE on no match, PARTIAL if device is not for sure in the defined zone and UNKNOWN on location not known. </li> </ul> <ul><li> **matchRate**: Match rate estimation for the location verification in percent (Optional - may be provided for PARTIAL result). </li> </ul></ul> **400**: Invalid input.<ul></ul> **401**: Unauthorized. <ul></ul> **403**: Forbidden.<ul></ul> **404**: Not found.<ul></ul> **500**: Internal server error.<ul></ul> **503**: Service  unavailable.

 
### 4.3 Errors

Since Device location API is based on REST design principles and blueprints, well defined HTTP status codes and families specified by community are followed [[3]](#3).

Details of HTTP based error/exception codes for Device location API are described in Section 4.2 of each API REST based method.
Following table provides an overview of common error names, codes, and messages applicable to Device location API.

| No | Error Name | Error Code | Error Message |
| --- | --- | --- | --- |
|1	|400 |	INVALID_INPUT |	"Expected property is missing: {property}" |
|2	|401 |	UNAUTHORIZED |	"No authorization to invoke operation" |
|3	|403 |	FORBIDDEN |	"Operation not allowed" |
|4	|404 |	NOT_FOUND |	"Not found" |
|5	|500 |	INTERNAL_SERVER_ERROR |	"Internal server error" |
|6	|503 |	SERVICE_UNAVAILABLE |	"Service unavailable" |
 
### 4.4 Policies

N/A


### 4.5 Code Snippets

Snippets elaborates REST based API call with "*curl"* to request


Please note, the credentials for API authentication purposes need to be adjusted based on target security system configuration.

| Snippet 1. Verify location request  |
| --- |
| curl -X 'POST' `https://sample-base-url/location/v0/verify`   <br>    -H 'accept: application/json' <br>    -H 'Content-Type: application/json'<br>    -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbG...."<br>    -d '{ "ueId": { "ipv4addr": "123.234.123.234" }, "uePort": 1234, "latitude": 40.416775, "longitude": -3.703790, "accuracy": 5 }  |
| If location is successfully verified, response will be: <br> 200 <br>   { "verificationResult": "TRUE" } |


### 4.6 FAQ's

(FAQs will be added in a later version of the documentation)

### 4.7 Terms

N/A

### 4.8 Release Notes

N/A

## References

[1] External Identifier format of the GPSI https://github.com/camaraproject/WorkingGroups/blob/main/Commonalities/documentation/UE-Identification.md#external-identifier-format-of-the-gpsi <br>
[2] Camara Commonalities : Authentication and Authorization Concept for Service
APIs https://github.com/camaraproject/WorkingGroups/blob/main/Commonalities/documentation/Working/CAMARA-AuthN-AuthZ-Concept.md <br>
[3] HTTP Status codes spec https://restfulapi.net/http-status-codes
