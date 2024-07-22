<a href="https://github.com/camaraproject/DeviceLocation/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>

# Location Retrieval API
Repository to describe, develop, document and test the Location retrieval API
**Location retrieval API is part of the Device Location API family**

## Scope
* Service APIs for “location-retrieval” (see APIBacklog.md)  
* It provides the customer with the ability to retrieve the location of a device.
* NOTE: The scope of this API  should be limited (at least at a first stage) to 4G and 5G.  
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: July 2022
* Location: virtually  

## Meetings
* Meetings are held virtually for the Device location API family
* Schedule: bi-weekly (odd weeks), Tuesday, 9 AM CET/CEST
* Meeting link: [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/91878854906?password=7e620a89-fcb5-4d2d-927a-17e3a0d1d28e)
* Slack channel: [camara-project.slack.com](https://join.slack.com/t/camara-project/shared_invite/zt-26gy3e64n-o7Riy3MoXmzdaDEL3wlngg) #sp-device-location

## Status and released versions
* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.
* **It is important to note that previous release was done at API family level**
* **The latest available release for the DeviceLocation API family is 0.2.0-rc1** There are bug fixes to be expected and incompatible changes in upcoming releases. It is suitable for implementors, but it is not recommended to use the API with customers in productive environments.
* The release Tag is [r1.1](https://github.com/camaraproject/DeviceLocation/releases/tag/r1.1)
  * API definition **with inline documentation:**
  - **location-retrieval v0.1.0**, which is the first alpha release.
    - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/location-retrieval.yaml)
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml)

* **Please note that** the previous release version was at the **device location family level** - it included all three APIs: location-verification, location-retrieval and geofencing. The release 0.2.0 of the API family is available within the [release-v0.2.0 branch](https://github.com/camaraproject/DeviceLocation/tree/release-v0.2.0). 


## Contributorship and mailing list
* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-dlo>.
* A message to all Contributors of this Sub Project can be sent using <sp-dlo@lists.camaraproject.org>.
