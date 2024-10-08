# API Readiness Checklist

Checklist for location-verification v1.0.0 in r1.2

| Nr | API release assets  | alpha | release-candidate |  initial<br>public | stable<br> public | Status | Comments |
|----|----------------------------------------------|:-----:|:-----------------:|:-------:|:------:|:----:|:----:|
|  1 | API definition                               |   M   |         M         |    M    |    M   |Y| [/code/API_definitions/location-verification.yaml](/code/API_definitions/location-verification.yaml) |
|  2 | Design guidelines from Commonalities applied |   O   |         M         |    M    |    M   |Y| |
|  3 | Guidelines from ICM applied                  |   O   |         M         |    M    |    M   |Y| |
|  4 | API versioning convention applied            |   M   |         M         |    M    |    M   |Y| |
|  5 | API documentation                            |   M   |         M         |    M    |    M   |Y| inline in yaml |
|  6 | User stories                                 |   O   |         O         |    O    |    M   | Y | [/documentation/API_documentation/location-verification-User-Story.md](/documentation/API_documentation/location-verification-User-Story.md)  |
|  7 | Basic API test cases & documentation         |   O   |         M         |    M    |    M   |Y| [/code/Test_definitions/location-verification.feature](/code/Test_definitions/location-verification.feature) |
|  8 | Enhanced API test cases & documentation      |   O   |         O         |    O    |    M   |Y| [/code/Test_definitions/location-verification.feature](/code/Test_definitions/location-verification.feature) |
|  9 | Test result statement                        |   O   |         O         |    O    |    M   |N| Fall24 EXCEPTION: Test results not available (*) |
| 10 | API release numbering convention applied     |   M   |         M         |    M    |    M   |Y|      |
| 11 | Change log updated                           |   M   |         M         |    M    |    M   |Y| [/CHANGELOG.md](/CHANGELOG.md) |
| 12 | Previous public release was certified        |   O   |         O         |    O    |    M   |Y|      |

(*) If you encounter issues with the provided test files (.feature), please create an issue in the API Sub-Project to signal these issues so they can be fixed in a patch release.

Note: the checklists of a public API version and of its preceding release-candidate API version can be the same.

The documentation for the content of the checklist is here: [API Readiness Checklist](https://wiki.camaraproject.org/display/CAM/API+Release+Process#APIReleaseProcess-APIreadinesschecklist).
