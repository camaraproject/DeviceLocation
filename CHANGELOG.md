# Changelog DeviceLocation

## Table of Contents

- **[r1.2](#r12)**
- [r1.1](#r11)
- [v0.2.0](#v020)
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for each first alpha or release-candidate API version, all changes since the release of the previous public API version
* for subsequent alpha or release-candidate API versions, the delta with respect to the previous pre-release
* for a public API version, the consolidated changes since the release of the previous public API version

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
