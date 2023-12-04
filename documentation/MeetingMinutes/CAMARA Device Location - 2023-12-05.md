# CAMARA DeviceLocation meeting - 2023-12-5

*December 5tht, 2023*

## Attendees


- Ludovic Robert (Orange)
- Fernando Prado Cabrillo (TEF)


Device Location minutes: [https://github.com/camaraproject/DeviceLocation/tree/main/documentation/MeetingMinutes](https://github.com/camaraproject/DeviceLocation/tree/main/documentation/MeetingMinutes)

## Agenda

* Open issues and PRs
  * No new issue for last 2 weeks
  * Cleaning for old issues
* Any other business
  
## Open issues and PRs

### Review Release Candidate v0.2

* Review latest comments in ongoing PRs for APIs, and decide if ready to be merged:
  - [location-verification.yaml v0.2 Release Candidate](https://github.com/camaraproject/DeviceLocation/pull/104)
       - Point about Ipv6 solved
       - Description comments from Cetin considered
       - Precision on date time accordingly to the commonalities guidelines
  - [location-retrieval.yaml v0.1 Release Candidate](https://github.com/camaraproject/DeviceLocation/pull/114)
      - Point about Ipv6 solved (complete alignement with verification device structure)
  - [geofencing.yaml v0.1 Release Candidate](https://github.com/camaraproject/DeviceLocation/pull/116)
      - Rafal aligned Notification source example list accordingly to the guidelines
      - Alignement with IP v6 to be done.


* Review latest comments in PR for README and CHANGELOG, and decide if ready to be merged:
  - [Release Notes](https://github.com/camaraproject/DeviceLocation/pull/106)
  - *Links will work after branch for Release-0.2.0 is created* 
  - No new comment since last meeting

### Review other Issues and PRs

* [Add Test Definition for location Retrieval #119](https://github.com/camaraproject/DeviceLocation/pull/119/files)
  - Link with Commonalities here: https://github.com/camaraproject/Commonalities/issues/94
  - No progress

* [Adjust IP Adresses device in device to use single IP adresses](https://github.com/camaraproject/DeviceLocation/issues/117)
  - Aligned with ongoing discussion and [PR in QoD](https://github.com/camaraproject/QualityOnDemand/pull/237)
    - Done for Location retrieval & location verification
    - To be done for geofencing

* [Geofencing API - Add "format: uri" to notificationUrl](https://github.com/camaraproject/DeviceLocation/issues/118)
  - Moved to [commonalities](https://github.com/camaraproject/Commonalities/issues/93)
  - still open

* [Geofencing API - Adding capability to manage max number of notification](https://github.com/camaraproject/DeviceLocation/issues/111)
  - Moved to [commonalities](https://github.com/camaraproject/Commonalities/issues/90)
  - still open - no progress

* [security and scopes for the Device Location API](https://github.com/camaraproject/DeviceLocation/issues/105)
  - Ludovic answered.

* [Documentation Updated](https://github.com/camaraproject/DeviceLocation/issues/102)
  - part of https://github.com/camaraproject/DeviceLocation/pull/104

### Open discussions

#### Behaviour when requesting too high precision

* [Issue #85](https://github.com/camaraproject/DeviceLocation/issues/85)
  - TEF provided a doc with a proposal and use cases for the implementation of 'Partial' and matchRate
  - During previous meeting we agreed to use the formula defined in the Word document.


### Cleaning - issues closed
* [Does DeviceLocation itself really need to define all ways to identify a User equipment identifier](https://github.com/camaraproject/DeviceLocation/issues/51) - Tackled with https://github.com/camaraproject/DeviceLocation/issues/117

* [Include locationType as a request parameter](https://github.com/camaraproject/DeviceLocation/issues/43) - Request for  Office/work location (most latched site/location in the day time) & Home location (most latched site/location in the night time). Managed in separate API request.

  [Accuracy Levels for Device Location APIs](https://github.com/camaraproject/DeviceLocation/issues/78) - nu update since July 31st José request for clarification to the issuer.

#### Administrative Code Area

* New [Issue #83](https://github.com/camaraproject/DeviceLocation/issues/83), with formal requirements from GSMA Product track
  - New [document uploaded by TEF](https://github.com/camaraproject/DeviceLocation/files/12856149/AdminCode.Proposal.-.Draft_20230926.docx) with a proposal
* [action] Review this document. 
    - Not progress but during last call we agreed that this feature is not top priority right now but will be discused next year.



## AOB


<p>

**Next call is on December 5th**
    José will be off - Fernando & Ludovic will host the call.