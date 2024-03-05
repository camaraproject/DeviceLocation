<a href="https://github.com/camaraproject/DeviceLocation/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>

# DeviceLocation
Repository to describe, develop, document and test the DeviceLocation API family

## Scope
* Service APIs for “Device Location” (see APIBacklog.md)  
* It provides the customer with the ability to:  
  * verify the location of a device.
  * retrieve the location of a device.
  * subscribe and receive notifications about a device entering or leaving certain location (geofencing). 
  * NOTE: The scope of this API family should be limited (at least at a first stage) to 4G and 5G.  
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: July 2022
* Location: virtually  

## Meetings
* Meetings are held virtually
* Schedule: bi-weekly (odd weeks), Tuesday, 9 AM CET/CEST
* Meeting link: [Microsoft Teams Meeting](https://teams.microsoft.com/l/meetup-join/19%3ameeting_OGZlNTY3NGYtOGY1MS00NmE1LTk1ZjQtMjU5Nzc5MmRmYzkz%40thread.v2/0?context=%7b%22Tid%22%3a%229744600e-3e04-492e-baa1-25ec245c6f10%22%2c%22Oid%22%3a%22d068e45e-a3af-46a4-8b86-a333bc7ffe81%22%7d)
* Slack channel: [camara-project.slack.com](https://join.slack.com/t/camara-project/shared_invite/zt-26gy3e64n-o7Riy3MoXmzdaDEL3wlngg) #sp-device-location

## Status and released versions
* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.
* **The latest available release for the DeviceLocation API family is 0.2.0.** There are bug fixes to be expected and incompatible changes in upcoming releases. It is suitable for implementors, but it is not recommended to use the API with customers in productive environments.

* Release 0.2.0 of the API family is available within the [release-v0.2.0 branch](https://github.com/camaraproject/DeviceLocation/tree/release-v0.2.0). The API family now includes 3 APIs, in different state of progress:
  - **location-verification v0.2.0**, which is the second alpha release of this API.
    - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/release-v0.2.0/code/API_definitions/location-verification.yaml)
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/location-verification.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/location-verification.yaml)
  - **location-retrieval v0.1.0**, which is the first alpha release.
    - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/release-v0.2.0/code/API_definitions/location-retrieval.yaml)
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/location-retrieval.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/location-retrieval.yaml)
  - **geofencing v0.1.0**, which is the first alpha release.
    - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/release-v0.2.0/code/API_definitions/geofencing.yaml)
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/geofencing.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/release-v0.2.0/code/API_definitions/geofencing.yaml)

* The previous release version v0.1.0 of DeviceLocation API is available within the [release-0.1.0 branch](https://github.com/camaraproject/DeviceLocation/tree/release-v0.1.0)
  - This past release only included the first alpha version of the API now renamed to location-verification, but it was then named as "location v0.1.0"

## Contributorship and mailing list
* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-dlo>.
* A message to all Contributors of this Sub Project can be sent using <sp-dlo@lists.camaraproject.org>.
