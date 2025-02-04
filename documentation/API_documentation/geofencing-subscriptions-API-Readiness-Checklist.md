# API Readiness Checklist

Checklist for geofencing-subscriptions 0.4.0-rc.1 in r2.1

| Nr | API release assets                           | alpha | release-candidate | public-release<br>initial | public-release<br> stable | Status |                                               Reference information                                                |
|----|----------------------------------------------|:-----:|:-----------------:|:-------------------------:|:-------------------------:|:------:|:------------------------------------------------------------------------------------------------------------------:|
| 1  | API definition                               |   M   |         M         |             M             |             M             |   Y    |     [/code/API_definitions/geofencing-subscriptions.yaml](/code/API_definitions/geofencing-subscriptions.yaml)     |
| 2  | Design guidelines from Commonalities applied |   O   |         M         |             M             |             M             |   Y    |                                                        r2.2                                                        |
| 3  | Guidelines from ICM applied                  |   O   |         M         |             M             |             M             |   Y    |                                                        r2.2                                                        |
| 4  | API versioning convention applied            |   M   |         M         |             M             |             M             |   Y    |                                                                                                                    |
| 5  | API documentation                            |   M   |         M         |             M             |             M             |   Y    |                                                   inline in yaml                                                   |
| 6  | User stories                                 |   O   |         O         |             O             |             M             |   N    |                                                                                                                    |
| 7  | Basic API test cases & documentation         |   O   |         M         |             M             |             M             |   Y    | [/code/Test_definitions/geofencing-subscriptions.feature](/code/Test_definitions/geofencing-subscriptions.feature) |
| 8  | Enhanced API test cases & documentation      |   O   |         O         |             O             |             M             |   Y    | [/code/Test_definitions/geofencing-subscriptions.feature](/code/Test_definitions/geofencing-subscriptions.feature) |
| 9  | Test result statement                        |   O   |         O         |             O             |             M             |   N    |                                           Test results not available (*)                                           |
| 10 | API release numbering convention applied     |   M   |         M         |             M             |             M             |   Y    |                                                                                                                    |
| 11 | Change log updated                           |   M   |         M         |             M             |             M             |   Y    |                                           [/CHANGELOG.md](/CHANGELOG.md)                                           |
| 12 | Previous public-release was certified        |   O   |         O         |             O             |             M             |   N    |                                                                                                                    |

(*) If you encounter issues with the provided test files (.feature), please create an issue in the API Sub-Project to signal these issues so they can be fixed in a patch release.

Note: the checklists of a public API version and of its preceding release-candidate API version can be the same.

The documentation for the content of the checklist is here: see API Readiness Checklist section in the [API Release Process](https://lf-camaraproject.atlassian.net/wiki/x/jine).