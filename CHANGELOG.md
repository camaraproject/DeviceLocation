# Changelog DeviceLocation

## Table of Contents

- **[r2.2](#r21) (Spring25 public release)**
- [r2.1](#r21)
- **[r1.2](#r12) (Fall24 public release)**
- [r1.1](#r11)
- [v0.2.0](#v020)
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r2.2

## Release Notes

This **public release** contains the definition and documentation of
* location-verification v2.0.0
* location-retrieval v0.4.0
* geofencing-subscriptions v0.4.0

The API definition(s) are based on
* Commonalities r2.3
* Identity and Consent Management r2.3

**Changelog since r1.2**
* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/DeviceLocation/compare/r1.2...r2.2

## location-verification v2.0.0

**There are breaking changes compared to v1.0.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API. 
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token. 
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/location-verification.yaml)

### Added

* Add MultiSIM section to info.description by @jlurien in #291
* Enhance description UNKNOWN vs UNABLE_TO_FULFILL_MAX_AGE by @jlurien in #314
* Section with guidelines about how to identify the device from access token and request body has been updated by @jlurien in #281

### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @jlurien in #281
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290
* Location verification align error tests by @jlurien in #306
* Some error status and codes have been updated by @jlurien in #281

### Fixed

* Update error message for unsupported device identifiers by @maxl2287 in #261

* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287

## location-retrieval v0.4.0

**There are breaking changes compared to v0.3.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API.
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token.
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/location-retrieval.yaml)

### Added

* Add management of `maxSurface` in request by @bigludo7 in #262
* Add MultiSIM section to info.description by @jlurien in #291
* Add LOCATION_RETRIEVAL.UNABLE_TO_FULFILL_MAX_SURFACE error by @bigludo7 in #303
* Section with guidelines about how to identify the device from access token and request body has been updated by @bigludo7 in #283

### Changed

* Error schemas updated with enums by @bigludo7 in #283
* Test definitions aligned with API specification update by @bigludo7 in #283
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290
* Location Retrieval - Align Error Test by @bigludo7 in #310
* Location Retrieval - Remove unnecessary error 400 by @bigludo7 in #316
* Some error status and codes have been updated by @bigludo7 in #283

### Fixed

* Update error message for unsupported device identifiers by @maxl2287 in #261

* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287

## geofencing-subscriptions v0.4.0

**There are breaking changes compared to v0.3.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API.
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token.
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/geofencing-subscriptions.yaml)

### Added

* Add test-definitions for HTTP-422 error-cases for geofencing-API by @maxl2287 in #289
* Add MultiSIM section to info.description by @jlurien in #291
* Add "MISSING_IDENTIFIER" to the 422-error codes by @maxl2287 in #309
* Set Device Object To Optional - According to API Design Guidelines by @dfischer-tech in #298

### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @maxl2287 in #284
* Add a note that initial events will be counted when `subscriptionMaxEvents` is combined with initialEvent=true by @maxl2287 in #284
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290
* Alignment on commonalities r2.3 by @maxl2287 in #311
* Some error status and codes have been updated by @maxl2287 in #284

### Fixed
* remove `allOf` in `sinkCredential` by @maxl2287 in #265
* Correct the example for subscriptions regarding `initialEvent` and error `MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED` by @dfischer-tech in #267
* Add quote-marks for `subscriptionExpireTime` - examples by @maxl2287 in #287

# r2.1

## Release Notes

This **pre-release** contains the definition and documentation of
* location-verification v2.0.0-rc.1
* location-retrieval v0.4.0-rc.1
* geofencing-subscriptions v0.4.0-rc.1

The API definition(s) are based on
* Commonalities r2.2
* Identity and Consent Management r2.2

**Changelog since r1.2**


* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/DeviceLocation/compare/r1.2...r2.1

## location-verification v2.0.0-rc.1

**There are breaking changes compared to v1.0.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API.
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token.
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.1/code/API_definitions/location-verification.yaml)

### Breaking Changes
* Some error status and codes have been updated by @jlurien in #281
* Section with guidelines about how to identify the device from access token and request body has been updated by @jlurien in #281

### Added

* Add MultiSIM section to info.description by @jlurien in #291

### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @jlurien in #281
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290

### Fixed
* Update errormessage for unsupported device identifiers by @maxl2287 in #261
* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287

## location-retrieval v0.4.0-rc.1
**There are breaking changes compared to v0.3.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API.
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token.
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.1/code/API_definitions/location-retrieval.yaml)

### Breaking Changes

* Some error status and codes have been updated by @bigludo7 in #283
* Section with guidelines about how to identify the device from access token and request body has been updated by @bigludo7 in #283

### Added

* Add management of `maxSurface` in request by @bigludo7 in #262
* Add MultiSIM section to info.description by @jlurien in #291

### Changed

* Error schemas updated with enums by @bigludo7 in #283
* Test definitions aligned with API specification update by @bigludo7 in #283
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290

### Fixed

* Update errormessage for unsupported device identifiers by @maxl2287 in #261
* Add quote-marks for `lastLocationTime` - examples by @maxl2287 in #287 

## geofencing-subscriptions v0.4.0-rc.1

**There are breaking changes compared to v0.3.0**: the API use has been simplified for API consumers using a three-legged access token to invoke the API.
In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token.
In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.1/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r2.1/code/API_definitions/geofencing-subscriptions.yaml)

### Breaking Changes

* Some error status and codes have been updated by @maxl2287 in #284

### Added

* Add test-definitions for HTTP-422 error-cases for geofencing-API by @maxl2287 in #289
* Add MultiSIM section to info.description by @jlurien in #291

### Changed

* Decrease radius minimum to "1" for circle-area by @maxl2287 in #285
* Error schemas updated with enums by @maxl2287 in #284
* Add a note that initial events will be counted when `subscriptionMaxEvents` is combined with initialEvent=true by @maxl2287 in #284
* Add pattern for x-correlator by @bigludo7 in #290
* Update 429 error message by @bigludo7 in #290

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.2/code/API_definitions/location-verification.yaml)

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.2/code/API_definitions/location-retrieval.yaml)

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.2/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.2/code/API_definitions/geofencing-subscriptions.yaml)

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/location-verification.yaml)

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/location-retrieval.yaml)

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

* API definition with **inline documentation**:

  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/geofencing-subscriptions.yaml)

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
