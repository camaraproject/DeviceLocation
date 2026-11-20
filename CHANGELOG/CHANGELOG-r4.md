# Changelog DeviceLocation

<!-- TOC:START -->
## Table of Contents
- **[r4.3](#r43)**
- [r4.2](#r42)
- [r4.1](#r41)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r4.3

## Release Notes

This public release contains the definition and documentation of
* geofencing-subscriptions 0.6.0
* location-retrieval 1.0.0
* location-verification 3.1.0

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

## geofencing-subscriptions 0.6.0

**geofencing-subscriptions 0.6.0 is an initial public version of this API.**

Changes documented below are compared to version 0.5.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.3/code/API_definitions/geofencing-subscriptions.yaml)

### Breaking changes

* `createGeofencingSubscription` declares two additional error codes: 400 `OUT_OF_RANGE` and 422 `MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED` by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437
* All operations declare the additional 403 error code `SUBSCRIPTION_MISMATCH` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/420

### Added

* Added support for credential type `PRIVATE_KEY_JWT` for notification delivery, with the 422 `PRIVATE_KEY_JWT_NOT_CONFIGURED` error on `createGeofencingSubscription` when no JWK Set was pre-shared with the API provider, by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/393

### Changed

* Aligned with CAMARA Commonalities r4.4 (0.9.0) by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/408, https://github.com/camaraproject/DeviceLocation/pull/420 and https://github.com/camaraproject/DeviceLocation/pull/437
  * `createGeofencingSubscription` declares two additional error codes, 400 `OUT_OF_RANGE` and 422 `MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED`; all operations declare the 403 error code `SUBSCRIPTION_MISMATCH` (see Breaking changes)
  * Notifications follow the common CloudEvents model; `data` is no longer listed as required in the event envelope
  * Request inputs carry explicit length and range limits, e.g. `x-correlator` (256 characters), `sink` and `networkAccessIdentifier` (2048); `subscriptionMaxEvents` is at most 1000000; `device.ipv4Address.publicPort` must be at least 1 (`0` was allowed before but is not a usable port)
  * `retrieveGeofencingSubscriptionList` returns at most 20 subscriptions
  * Added the info.description sections on authorization and authentication, additional error responses and request body strictness
* Added `description` field to Area schema by @bigludo7 in https://github.com/camaraproject/DeviceLocation/pull/382
* Aligned the test definitions with the API definition, added a test scenario for 400 `OUT_OF_RANGE` and split the test definitions into one feature file per operation by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/414 and https://github.com/camaraproject/DeviceLocation/pull/439

### Fixed

* N/A

### Removed

* The notification callback 429 no longer declares `QUOTA_EXCEEDED` by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437
* The `PLAIN` and `REFRESHTOKEN` sink credential types and the `AMQP`, `KAFKA`, `MQTT3`, `MQTT5` and `NATS` protocol values by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/393 and https://github.com/camaraproject/DeviceLocation/pull/408
  * Not breaking: 0.5.0 already required `credentialType` `ACCESSTOKEN` and allowed only `HTTP`
* Test scenario for deprecated error code IDENTIFIER_MISMATCH by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/446

## location-retrieval 1.0.0

**location-retrieval 1.0.0 is the first stable version of this API.**

Changes documented below are compared to version 0.5.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.3/code/API_definitions/location-retrieval.yaml)

### Breaking changes

* `retrieveLocation` declares the additional 400 error code `OUT_OF_RANGE` by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/408 and https://github.com/camaraproject/DeviceLocation/pull/436

### Added

* Added `minimum: 0` for `maxAge` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/386
* Added test case for 422 `LOCATION_RETRIEVAL.UNABLE_TO_LOCATE`; updated 404 test case for non-existent devices by @bigludo7 in https://github.com/camaraproject/DeviceLocation/pull/390

### Changed

* Aligned with CAMARA Commonalities r4.4 (0.9.0) by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/408 and https://github.com/camaraproject/DeviceLocation/pull/436
  * The `400` response of `retrieveLocation` also declares `OUT_OF_RANGE` (see Breaking changes)
  * Request inputs carry explicit length and range limits, e.g. `x-correlator` (256 characters) and the device identifiers; `maxAge` and `maxSurface` are bounded by the 32-bit integer range; `device.ipv4Address.publicPort` must be at least 1 (`0` was allowed before but is not a usable port). No request that conforms to the documented semantics is rejected
  * Added the info.description sections on authorization and authentication, additional error responses and request body strictness
* Aligned the test definitions with the API definition and Commonalities r4.4 by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/414 and https://github.com/camaraproject/DeviceLocation/pull/436

### Fixed

* N/A

### Removed

* Test scenario for deprecated error code IDENTIFIER_MISMATCH by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/446

## location-verification 3.1.0

**location-verification 3.1.0 is a minor update of this API.**

Changes documented below are compared to version 3.0.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.3/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.3/code/API_definitions/location-verification.yaml)

### Breaking changes

* N/A

### Added

* Added `minimum: 0` for `maxAge` by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/386

### Changed

* Aligned with CAMARA Commonalities r4.4 (0.9.0) by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/408 and https://github.com/camaraproject/DeviceLocation/pull/436
  * Request inputs carry explicit length and range limits, e.g. `x-correlator` (256 characters) and the device identifiers; `maxAge` is bounded by the 32-bit integer range; `device.ipv4Address.publicPort` must be at least 1 (`0` was allowed before but is not a usable port). No request that conforms to the documented semantics is rejected
  * Added the info.description sections on authorization and authentication, additional error responses and request body strictness
* Aligned the test definitions with the API definition and Commonalities r4.4 by @jlurien and @hdamker in https://github.com/camaraproject/DeviceLocation/pull/414 and https://github.com/camaraproject/DeviceLocation/pull/436

### Fixed

* Fixed typo in test scenario 400.3 by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/414

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/DeviceLocation/compare/r3.2...r4.3

# r4.2

## Release Notes

This release candidate contains the definition and documentation of
* geofencing-subscriptions 0.6.0-rc.2
* location-retrieval 1.0.0-rc.2
* location-verification 3.1.0-rc.3

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

## geofencing-subscriptions 0.6.0-rc.2

**geofencing-subscriptions 0.6.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 0.6.0-rc.1.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/geofencing-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.2/code/API_definitions/geofencing-subscriptions.yaml)

### Breaking changes

* `createGeofencingSubscription` declares two additional error codes: 400 `OUT_OF_RANGE` and 422 `MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED` by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437

### Added

* N/A

### Changed

* Aligned with Commonalities r4.4: error responses reference the r4.4 common responses; `createGeofencingSubscription` declares two additional error codes, 400 `OUT_OF_RANGE` and 422 `MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED` by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437
* Added a test scenario for 400 `OUT_OF_RANGE` and split the test definitions into one feature file per operation by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/439

### Fixed

* N/A

### Removed

* `retrieveGeofencingSubscriptionList` 400 and the notification callback 400 no longer declare `OUT_OF_RANGE`, reverting its addition in 0.6.0-rc.1 by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437
* The notification callback 429 no longer declares `QUOTA_EXCEEDED` by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/437
* Test scenario for deprecated error code IDENTIFIER_MISMATCH by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/446

## location-retrieval 1.0.0-rc.2

**location-retrieval 1.0.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 1.0.0-rc.1.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/location-retrieval.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/location-retrieval.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.2/code/API_definitions/location-retrieval.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* Aligned with Commonalities r4.4 by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/436

### Fixed

* N/A

### Removed

* Test scenario for deprecated error code IDENTIFIER_MISMATCH by @jlurien in https://github.com/camaraproject/DeviceLocation/pull/446

## location-verification 3.1.0-rc.3

**location-verification 3.1.0-rc.3 is a release-candidate version of this API.**

Changes documented below are compared to version 3.1.0-rc.2.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/location-verification.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r4.2/code/API_definitions/location-verification.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r4.2/code/API_definitions/location-verification.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* Aligned with Commonalities r4.4 by @hdamker in https://github.com/camaraproject/DeviceLocation/pull/436

### Fixed

* N/A

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/DeviceLocation/compare/r4.1...r4.2

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
