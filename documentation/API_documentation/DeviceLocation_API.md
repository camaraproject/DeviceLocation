# Overview
The Location API provides programmable interface for developers and other users to verify 
if given user equipment is within the range(radial distance) from some place defined by coordinates(longitude, latitude) on the Earth.
## 1\. Introduction
Logistics, gaming and many more industry sectors define a need of getting user real location. Moreover, some of them 
need this functionality to prevent frauds - to compare GPS location with real user equipment location.
<img src="./resources/Location_overview.png" alt="LOC_VER" title="Location verification">

## 2\. Quick Start
Location API v0.1.0 exposes only one endpoint, which can be used to determine if user equipment is within the given radial distance from
given location. To do so we need to pass following parameters in request body: 
1. **ueId** - an object with four fields, each of them make possible to pass ueId in different format: externalId [1], msisdn, ipv4Addr and ipv6Addr 
2. **latitude** - a floating point number representing latitude of location, value from -90 to 90
3. **longitude** - a floating point number representing longitude of location, value from -180 to 180
4. **accuracy** - an integer representing accuracy (radius) expected for location verification in km

Sample API invocation is presented in Section 4.5.



## 3\. Authentication and Authorization

The Location API makes use of the client credentials grant which is applicable for server to server use cases involving trusted partners
or clients without any protected user data involved.
In this method the API invoker client is registered as a confidential client with an authorization grant type of client_credentials [3].


## 4\. API Documentation

### 4.1 Details
The API user wants to execute a location verification for a user equipment. It means, that the API checks whether the current position of the UE is within a given distance from a given geographic location.

<br />

### 4.2 Endpoint Definitions

<span class="colour" style="color:rgb(23, 43, 77)"><span class="colour" style="color:rgb(36, 41, 47)">Following table
defines API endpoints of exposed REST based for QoD throughput management operations. </span></span>

| **Endpoint**                             | **Operation**             | **Description**               |
|------------------------------------------|---------------------------|-------------------------------|
| POST<br>  \<base-url>/location/v0/verify | **Location verification** | Execute location verification |

#### **Location verification**

| **Execute location verification**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **HTTP Request**<br> POST \<base-url>/location/v0/verify<br>**QueryParameters**<br> No query parameters are defined.<br>**Path Parameters**<br> No path parameters are defined.<br>**Request Body Parameters**<br> **ueId**: UE identifier object, contains 4 different identifiers, at least 1 has to be set<br> **port (optional):** User equipment port. Device port may be required along with IP address to identify the target device <br> **latitude:** Latitude component of the location.<br> **longitude:** Longitude component of the location<br> **accuracy:** Accuracy (radius) of the location check in km <br><br>**Response**<br> **200: Location verified**<br>  Response body:<br>   **verificationResult:** bolean result value <br><br> **400:** **Invalid input.**<br> **401:** **Un-authorized, missing or incorrect authentication.**<br> **403:** **Forbidden access.**<br> **404:** **Resource not found.**<br>  **500:** **Server error.**<br> **503:** **Service temporarily unavailable.** |
<br>

### 4.3 Errors

Since CAMARA Location API is based on REST design principles and blueprints, well defined HTTP status
codes and families specified by community are followed [2].

Details of HTTP based error/exception codes for the Location API are described in Section 4.2 of each API REST based method.
Following table provides an overview of common error names, codes and messages applicable to Location API.

| No  | Error Name            | Error Code | Error Message                                                 |
|-----|-----------------------|------------|---------------------------------------------------------------|
| 1   | Invalid port(s)       | 400        | "Ports specification not valid                                |
| 2   | Invalid ueId          | 400        | "Validation failed for parameter: ueId"                       |
| 3   | Invalid port          | 400        | "Validation failed for parameter: port"                       |
| 4   | Invalid latitude      | 400        | "Validation failed for parameter: latitude"                   |
| 5   | Invalid longitude     | 400        | "Validation failed for parameter: longitude"                  |
| 6   | Invalid accuracy      | 400        | "Validation failed for parameter: accuracy"                   |
| 7   | Unauthorized          | 401        | "Un-authorized to invoke operation"                           |
| 8   | Forbidden             | 403        | "Forbidden to invoke operation"                               |
| 9   | Not found             | 404        | "The specified resource is not found"                         |
| 10  | Internal server error | 500        | "Internal server error"                                       |
| 9   | Service unavailable   | 503        | “Internal error due to required telco service unavailability" |

### 4.4 Policies

N/A

### 4.5 Code Snippets

| Snippet 1. Execute location verification                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| curl -X 'POST' `https://sample-base-url/location/v0/verify`   <br>    -H 'accept: application/json' <br>    -H 'Content-Type: application/json'<br>    -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbG...."<br>    -d '{<br>     "ueId": {<br>"externalId": "exampleExternalId@domain.com",<br>"msisdn": "41793834315",<br>"ipv4Addr": "192.0. 2.146",<br>"ipv6Addr": "2001:db8:3333:4444:5555:6666:7777:8888"<br>},<br> "port": 5060, <br> "latitude": -90,<br>     "longitude": -180,<br>     "accuracy": 120<br>   } |

<br>

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
