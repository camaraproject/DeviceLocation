# Changelog location-retrieval from DeviceLocation API family

## Table of Contents

- [v0.2.0](#v020rc1)
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

# v0.2.0.rc1


## Please note:

- **This release contains significant breaking changes compared to v0.1.0, and it is not backward compatible**
  - Especially a lot of the parameter names changed in line with the agreed glossary within CAMARA Commonalities
- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments

## Added


* Test Definition in Test_Definitions directory (PR229)
*  Add x-correlator as header parameter (commonalities alignement) (PR172)

## Changed

* Make the '+' mandatory for the phone number (PR178)
* Remove minimum 60 seconds to maxAge (PR188)
  -  Absence of maxAge means "any age"
  -  maxAge=0 means a fresh calculation.
* Cosmetic change following megalinter integration by @bigludo7 
* Update Authorization and authentication part accordingly to ICM (PR217)
* Align the documentation part of the API with the fact that lastLocationTime is mandatory in all response. (PR199)
* - Aligned error code list & description with Commonalities (PR221)

### Fixed

* n/a

### Removed

* n/a

# v0.1.0

**This is the fist alpha version of the location-retrieval API but it was part of second alpha version of the DeviceLocation API family.**

- API [definition](https://github.com/camaraproject/DeviceLocation/blob/release-0.2.0-rc3/code/API_definitions/location-retrieval.yaml) **with inline documentation**.


## Added


* First alpha version of the new API `location-retrieval`, v0.1.0:

    - Initial version already aligned with latest guidelines.
    - Returns 2 possible location areas: `CIRCLE` and `POLYGON`.





