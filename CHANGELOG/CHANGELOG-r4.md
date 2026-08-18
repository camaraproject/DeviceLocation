# Changelog DeviceLocation

<!-- TOC:START -->
## Table of Contents
- [r4.1](#r41)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r4.1

## Release Notes

This release candidate contains the definition and documentation of
* geofencing-subscriptions 0.6.0-rc.1
* location-retrieval 1.0.0-rc.1
* location-verification 3.1.0-rc.2

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## geofencing-subscriptions 0.6.0-rc.1

**geofencing-subscriptions 0.6.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.5.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.1/code/API_definitions/geofencing-subscriptions.yaml)

### Breaking changes

* N/A

### Added

* Added support for credential type `PRIVATE_KEY_JWT` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/393

### Changed

* Synced with CAMARA Commonalities r4.3 / 0.8.0: aligned schemas, responses, parameters and `info.description` mandatory markers by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/408
* Added `description` field to Area schema by @bigludo7 in https://github.com/camaraproject/DeviceLocation/pull/382
* Aligned test plan with updated OpenAPI spec and CAMARA r4.3 testing artifacts by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/414

### Fixed

* Fixed `CloudEvent` schema: added missing `type: object` declaration by @bigludo7 in https://github.com/camaraproject/DeviceLocation/pull/406

### Removed

* N/A

## location-retrieval 1.0.0-rc.1

**location-retrieval 1.0.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.5.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.1/code/API_definitions/location-retrieval.yaml)

### Breaking changes

* N/A

### Added

* Added `minimum: 0` for `maxAge` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/386
* Added test case for 422 `LOCATION_RETRIEVAL.UNABLE_TO_LOCATE`; updated 404 test case for non-existent devices by @bigludo7 in https://github.com/camaraproject/DeviceLocation/pull/390

### Changed

* Synced with CAMARA Commonalities r4.3 / 0.8.0: aligned schemas, responses, parameters and `info.description` mandatory markers by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/408
* Aligned test plan with updated OpenAPI spec and CAMARA r4.3 testing artifacts by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/414

### Fixed

* N/A

### Removed

* N/A

## location-verification 3.1.0-rc.2

**location-verification 3.1.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 3.0.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.1/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.1/code/API_definitions/location-verification.yaml)

### Breaking changes

* N/A

### Added

* Added `minimum: 0` for `maxAge` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/386

### Changed

* Synced with CAMARA Commonalities r4.3 / 0.8.0: aligned schemas, responses, parameters and `info.description` mandatory markers by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/408
* Aligned test plan with updated OpenAPI spec and CAMARA r4.3 testing artifacts by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/414

### Fixed

* Fixed typo in test scenario 400.3 by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/414

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/DeviceLocation/compare/r3.2...r4.1
