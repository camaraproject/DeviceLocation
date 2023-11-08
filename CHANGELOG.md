# Changelog DeviceLocation

## Table of Contents

- [v0.2.0](#v020)
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

# v0.2.0

**This is the second alpha version of the DeviceLocation API family.**

- API [definition](https://github.com/camaraproject/DeviceLocation/tree/release-0.2.0/code/API_definitions) **with inline documentation**.

## Please note:

- **This release contains significant breaking changes compared to v0.1.0, and it is not backward compatible**
  - Especially a lot of the parameter names changed in line with the agreed glossary within CAMARA Commonalities
- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.


## What's changed

*  Second alpha version of `location-verification` API, v0.2.0, renamed from `location`, with main changes:
    - Input property `ueId` evolved to `device`, following CAMARA guidelines.
    - New input parameter `area`, considering initially circular areas, and deprecating previous `latitude`, `longitude` and `accuracy` properties.
    - New input parameter `maxAge`.
    - Response adds new values `UNKNOWN` and `PARTIAL` for `verificationResult`. It also adds properties `matchRate` and `lastLocationTime`.
    - Security schemas and scopes aligned with commonalities guidelines.
    - Error responses adapted to new commonalities guidelines.
    - Inline documentation within OpenAPI spec. 

* First alpha version of the new API `location-retrieval`, v0.1.0-wip

    - Initial version already aligned with latest guidelines.
    - Returns 2 possible location areas: `Circle` and `Polygon`.

* First alpha version of the new API `geofencing`, v0.1.0-wip

    - Initial version already aligned with latest guidelines.
    - Follows CloudEvents format.

# v0.1.0

**This is the first alpha version of the DeviceLocation API.** 

- API [definition](https://github.com/camaraproject/DeviceLocation/tree/release-0.1.0/code/API_definitions)
- API [documentation](https://github.com/camaraproject/DeviceLocation/tree/release-0.1.0/documentation/API_documentation)

## Please note:

- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.

## What's changed

* New API `location`, v0.1.0, with a single operation for location verification:
    - Given a device identified by the `ueId` object, a set of coordinates (`latitude` and `longitude`), and the requested `accuracy`, returns a boolean `verificationResult`, verifying if the device is within the circular area delimited by the coordinates and the accuracy radius.  