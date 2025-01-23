# Changelog DeviceLocation

## Table of Contents

- **[r2.1](#r21)**
- [r1.2](#r12)
- [r1.1](#r11)
- [v0.2.0](#v020)
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for each first alpha or release-candidate API version, all changes since the release of the previous public API version
* for subsequent alpha or release-candidate API versions, the delta with respect to the previous pre-release
* for a public API version, the consolidated changes since the release of the previous public API version

# r2.1

## Release Notes

This **public release** contains the definition and documentation of
* location-verification v2.0.0-rc.1
* location-retrieval v0.4.0-rc.1
* geofencing-subscriptions v0.4.0-rc.1

The API definition(s) are based on
* Commonalities v0.5.0
* Identity and Consent Management v0.2.1

**Changelog since r1.2**


* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/DeviceLocation/compare/r1.2...r2.1

## location-verification v2.0.0-rc.1

### Added

* Add MultiSIM section to info.description by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/291

### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @jlurien in #281
* Some error status and codes have been updated by @jlurien in #281
* Section with guidelines about how to identify the device from access token and request body has been updated by @jlurien in #281

### Fixed
* Update errormessage for unsupported device identifiers by @maxl2287 in #261
* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287

## location-retrieval v0.4.0-rc.1

### Added

* Add management of `maxSurface` in request by @bigludo7 in #262
* Add MultiSIM section to info.description by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/291

### Changed

* Error schemas updated with enums by @bigludo7 in #283
* Some error status and codes have been updated by @bigludo7 in #283
* Section with guidelines about how to identify the device from access token and request body has been updated by @bigludo7 in #283
* Test definitions aligned with API specification update by @bigludo7 in #283

### Fixed

* Update errormessage for unsupported device identifiers by @maxl2287 in #261
* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287 

## geofencing-subscriptions v0.4.0-rc.1

### Added

* Add test-definitions for HTTP-422 error-cases for geofencing-API by @maxl2287 in #289
* Add MultiSIM section to info.description by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/291


### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @maxl2287 in #284
* Some error status and codes have been updated by @maxl2287 in #284
* Add a note that initial events will be counted when `subscriptionMaxEvents` is combined with initialEvent=true by @maxl2287 in #284

### Fixed
* remove `allOf` in `sinkCredential` by @maxl2287 in #265
* Correct the example for subscriptions regarding `initialEvent` and error `MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED` by @dfischer-tech in #267
* Add quote-marks for `subscriptionExpireTime` - examples by @maxl2287 in #287

# r1.2

## Release Notes

This **public release** contains the definition and documentation of
* location-verification v1.0.0
* location-retrieval v0.3.0
* geofencing-subscriptions v0.3.0

The API definition(s) are based on
* Commonalities v0.4.0
* Identity and Consent Management v0.2.0

**Changelog since v0.2.0**

* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/DeviceLocation/compare/v0.2.0...r1.2

## location-verification v1.0.0

### Added

* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Make `device` optional in requests, with related documentation
* Make '+' mandatory for phoneNumber
* Adjust `maxAge` behaviour and minimum, and adjust documentation
* Alignment of errors with Commonalities

### Fixed

* Update the PARTIAL case description: `match_rate` is set in the response

## location-retrieval v0.3.0

### Added

* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Make `device` optional in requests, with related documentation
* Make '+' mandatory for phoneNumber
* Adjust `maxAge` behaviour and minimum, and adjust documentation
* Alignment of errors with Commonalities

### Fixed

* Clarify that `lastLocationTime` is mandatory in responses

## geofencing-subscriptions v0.3.0

### Added

* Adopt Commonalities guidelines for subscriptions (based on CloudEvents)
* Add `subscriptionMaxEvents` for maximum number of notifications
* Add `SUBSCRIPTION_DELETED` and `SUBSCRIPTION_UNPROCESSABLE` as termination reasons
* Add `terminationsDescription` as optional event property
* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Change base path to `geofencing-subscriptions` and adapt security scopes 
* Make '+' mandatory for phoneNumber
* Alignment of errors with Commonalities

# r1.1

## Release Notes

This **pre-release** contains the definition and documentation of
* location-verification v1.0.0-rc.1
* location-retrieval v0.3.0-rc.1
* geofencing-subscriptions v0.3.0-rc.1

The API definition(s) are based on
* Commonalities v0.4.0-rc.1
* Identity and Consent Management v0.2.0-rc.1

**Changelog since v0.2.0**

* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/DeviceLocation/compare/v0.2.0...r1.1

## location-verification v1.0.0-rc.1

### Added

* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Make `device` optional in requests, with related documentation
* Make '+' mandatory for phoneNumber
* Adjust `maxAge` behaviour and minimum, and adjust documentation
* Alignment of errors with Commonalities

### Fixed

* Update the PARTIAL case description: `match_rate` is set in the response

## location-retrieval v0.3.0-rc.1

### Added

* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Make `device` optional in requests, with related documentation
* Make '+' mandatory for phoneNumber
* Adjust `maxAge` behaviour and minimum, and adjust documentation
* Alignment of errors with Commonalities

### Fixed

* Clarify that `lastLocationTime` is mandatory in responses

## geofencing-subscriptions v0.3.0-rc.1

### Added

* Adopt Commonalities guidelines for subscriptions (based on CloudEvents)
* Add `subscriptionMaxEvents` for maximum number of notifications
* Add `SUBSCRIPTION_DELETED` as termination-reason
* Added x-correlator to requests and headers
* Enhancements in documentation
* Testing plan

### Changed

* Change base path to `geofencing-subscriptions` and adapt security scopes 
* Make '+' mandatory for phoneNumber
* Alignment of errors with Commonalities

# v0.2.0

**This is the second alpha version of the DeviceLocation API family.**

- API [definition](https://github.com/camaraproject/DeviceLocation/tree/release-v0.2.0/code/API_definitions) **with inline documentation**.

## Please note:

- **This release contains significant breaking changes compared to v0.1.0, and it is not backward compatible**
  - Especially a lot of the parameter names changed in line with the agreed glossary within CAMARA Commonalities
- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.


## What's changed

* Second alpha version of `location-verification` API, v0.2.0, renamed from `location`, with main changes:

    - Input property `ueId` evolved to `device`, following CAMARA guidelines.
    - New input parameter `area`, considering initially circular areas, and deprecating previous `latitude`, `longitude` and `accuracy` properties.
    - New input parameter `maxAge`.
    - Response adds new values `UNKNOWN` and `PARTIAL` for `verificationResult`. It also adds properties `matchRate` and `lastLocationTime`.
    - Security schemas and scopes aligned with commonalities guidelines.
    - Error responses adapted to new commonalities guidelines.
    - Inline documentation within OpenAPI spec. 

* First alpha version of the new API `location-retrieval`, v0.1.0:

    - Initial version already aligned with latest guidelines.
    - Returns 2 possible location areas: `CIRCLE` and `POLYGON`.

* First alpha version of the new API `geofencing`, v0.1.0:

    - Initial version already aligned with latest guidelines.
    - Follows CloudEvents format.

# v0.1.0

**This is the first alpha version of the DeviceLocation API.** 

- API [definition](https://github.com/camaraproject/DeviceLocation/tree/release-v0.1.0/code/API_definitions)
- API [documentation](https://github.com/camaraproject/DeviceLocation/tree/release-v0.1.0/documentation/API_documentation)

## Please note:

- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.

## What's changed

* New API `location`, v0.1.0, with a single operation for location verification:
    - Given a device identified by the `ueId` object, a set of coordinates (`latitude` and `longitude`), and the requested `accuracy`, returns a boolean `verificationResult`, verifying if the device is within the circular area delimited by the coordinates and the accuracy radius.  
