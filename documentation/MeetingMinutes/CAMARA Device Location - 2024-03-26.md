# CAMARA DeviceLocation meeting - 2024-03-26

*March 26th, 2024*

## Attendees

Joachim Dahlgren (Ericsson)
Cetin Alpaycetin (Vodafone)
Akos Hunyadi (DT)
Fernando Prado Cabrillo (Telefonica)
Ludovic Robert (Orange)
Rafal Artych (DT)
  

Device Location minutes: [https://github.com/camaraproject/DeviceLocation/tree/main/documentation/MeetingMinutes](https://github.com/camaraproject/DeviceLocation/tree/main/documentation/MeetingMinutes)

**Important notice** : Accordingly to our Linux Foundation Governance, this is the last meeting minutes in markdown in the CAMARA GitHub. Next meeting minutes will be prepared/captured directly here: https://wiki.camaraproject.org/display/CAM/Device+Location 




## Agenda

* Open issues and PRs
* Any other business
  
## Open issues and PRs 

### New

#### Corrections


* [Are we happy with security scope for geofencing](https://github.com/camaraproject/DeviceLocation/issues/173)
  - Scope name should reflect the date provided by the notification (not `geofencing:subscriptions:write` but more precise like `geofencing:subscriptions:read-location` )
  - Discussion on this topic in progress in Commonalities (https://github.com/camaraproject/Commonalities/issues/163)


### Ongoing

* [Add x-correlator as specified in the guideline](https://github.com/camaraproject/DeviceLocation/issues/160)
  - Following PR Created:
    - https://github.com/camaraproject/DeviceLocation/pull/171 
        - Could be merged
    - https://github.com/camaraproject/DeviceLocation/pull/172
        - Could be merged
    - https://github.com/camaraproject/DeviceLocation/pull/174 
      - Discussion about x-correlator open in commonalities 
        - https://github.com/camaraproject/Commonalities/issues/164
        - Suggestion to keep this PR open till commonalities outcome.


* [Remove API from info.title](https://github.com/camaraproject/DeviceLocation/issues/169)
  - Remove API from the title
  - [Action] José will create the PR


* [Implement use of linting rule set for Device Location API](https://github.com/camaraproject/DeviceLocation/issues/125)
  - New PRs: [Introducing corrections for yamllint](https://github.com/camaraproject/DeviceLocation/pull/166) and [Adding configuration for Github Actions with linting ruleset](https://github.com/camaraproject/DeviceLocation/pull/167)
  - PR#166 Rafal will regenerate the linter & once done the PR will be merge
  - PR#167: to be merged after #166
  - Rafal will check if PR can be merged and will prepare what is needed.

* [Add Test Definition for location Retrieval #119](https://github.com/camaraproject/DeviceLocation/pull/119/files)
  - Issue in Commonalities to discuss [Enhancement of the Testing Guidelines](https://github.com/camaraproject/Commonalities/issues/158) by TEF 
  - [Action] José propose to make an example to illustrate his proposal
  - [Action] Toyeeb to check with GSMA conformance
  - Orange is working on the testing too and will provide feedback soon. Jose from TEF will upload an example of Location Verification ATP once the commonalities guidelines are approved

* [Geofencing - Adding a value in Termination Reason value enum](https://github.com/camaraproject/DeviceLocation/issues/141)
  - Discussion in progress in Commnonalities: https://github.com/camaraproject/Commonalities/issues/153 
  - Related issues in [DeviceStatus](https://github.com/camaraproject/DeviceStatus/issues/117) and QoD
  - Waiting for Commonalities outcomes


* [Geofencing API - Add Subscription type 'area-left-or-entered' to subscribe to both event in one time](https://github.com/camaraproject/DeviceLocation/issues/138)
  - New issue in Commonalities [Subscription-Issue2: Allow event consumers to subscribe to more than one event types with a single subscription](https://github.com/camaraproject/Commonalities/issues/154)
  - Waiting for Commonalities outcomes
  - As we have several issues aroung Subscriptions and the progress on commonalities are slow we need to speed up the resolution. One proposal should be to have a cross meeting with Device Status WG as these 2 projects rely on subscriptions.


* [Geofencing API - Defining a standard behavior for first event](https://github.com/camaraproject/DeviceLocation/issues/124)
  - Moved to Commonalities [Issue 140](https://github.com/camaraproject/Commonalities/issues/140)
  - No comments in the issue in the last 2 weeks
  - Low participation in commonalities is blocking the issue for device location
  - Ludovic proposes to have a cross meeting with Device Location and Device Status to tackle the issue


* [Define guidelines for geofencing implementation](https://github.com/camaraproject/DeviceLocation/issues/133)
  - No new comments. 
  - [Action] We need more comments from the team
  - Connected with [Issue #85](https://github.com/camaraproject/DeviceLocation/issues/85). A document with implementation guideline should cover this also.

* [Geofencing API - Add "format: uri" to notificationUrl](https://github.com/camaraproject/DeviceLocation/issues/118)
  - Moved to [commonalities](https://github.com/camaraproject/Commonalities/issues/93)
  - No comments in the last 2 weeks
  - Wait for outcome

### Long term discussions

#### Administrative Code Area

* New [Issue #83](https://github.com/camaraproject/DeviceLocation/issues/83), with formal requirements from GSMA Product track
  - [Document uploaded by TEF](https://github.com/camaraproject/DeviceLocation/files/12856149/AdminCode.Proposal.-.Draft_20230926.docx) with a proposal. 

  This item should be reopen after MWC.

  - We should discussed approach on this for next release. Should we incorporate this to current operations, should we split this functionality to new endpoints or even separate APIs?
    - Need to be discussed
      - Ludovic preference is for a separate API as for example in France this is not a request.
      - For Javier this is not a top priority for Telefonica as of now.
    - More generally probably we need to have feedback loop with GSMA team about API work (and review the priority as focus could change)
      - Done during last TSC - see here: https://wiki.camaraproject.org/display/CAM/2024-03-21+TSC+Minutes

#### Behaviour when requesting too high precision

* [Issue #85](https://github.com/camaraproject/DeviceLocation/issues/85)
  - As requested by Joachim, issue will remain open until TEF uploads the document with more detail or the information is added to an API_documentation file to keep in the repo for future references.
    - Joachim: Should be also aligned/synchronysed with Geofencing

## AOB

<p>

- Next call would be on **April 9th, 2024**
- **Not present in calendar** : Ludovic will check with José about resending a serie - we have probaly to move to LF zoom.


<p>
