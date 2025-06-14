<a href="https://github.com/camaraproject/DeviceLocation/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/DeviceLocation?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/DeviceLocation/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/DeviceLocation?style=plastic">
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Incubating API Repository"><img src="https://img.shields.io/badge/Incubating%20API%20Repository-green?style=plastic"></a>

# DeviceLocation

Incubating API Repository to evolve and maintain the definitions and documentation of the DeviceLocation APIs

* API wiki page: [Device Location](https://lf-camaraproject.atlassian.net/l/cp/o9sdMHiK)

## Scope
* Service APIs for “Device Location” (see APIBacklog.md)  
* The APIs provide the API consumer with the ability to: 
  * verify the location of a device (location-verification).
  * retrieve the location of a device (location-retrieval).
  * subscribe and receive notifications about a device entering or leaving certain location (geofencing-subscriptions). 
  * NOTE: The scope of these APIs is limited (at least at a first stage) to 4G and 5G.  
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: July 2022
* Incubating stage since: February 2025

## Release Information

* The latest public release is available here: https://github.com/camaraproject/DeviceLocation/releases/latest
* For changes see [CHANGELOG.md](https://github.com/camaraproject/DeviceLocation/blob/main/CHANGELOG.md) 

* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* **The latest public release is [r2.2](https://github.com/camaraproject/DeviceLocation/tree/r2.2), with the following API definitions (with inline documentation):**
  
  - **location-verification v2.0.0** 
  [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/location-verification.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-verification.yaml&nocors)
  [[View it on Swagger Editor]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-verification.yaml)

  - **location-retrieval v0.4.0** 
  [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/location-retrieval.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-retrieval.yaml&nocors)
  [[View it on Swagger Editor]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/location-retrieval.yaml)

  - **geofencing-subscriptions v0.4.0**
  [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r2.2/code/API_definitions/geofencing-subscriptions.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/geofencing-subscriptions.yaml&nocors)
  [[View it on Swagger Editor]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r2.2/code/API_definitions/geofencing-subscriptions.yaml)

## Contributing

* Meetings are held virtually
  - Schedule: bi-weekly (odd weeks), Tuesday, 8:00 AM UTC (9:00 CET/10:00 CEST)
  - Meeting link: [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/91878854906?password=7e620a89-fcb5-4d2d-927a-17e3a0d1d28e)
* Mailing list:
  - To subscribe / unsubscribe to the mailing list of this Sub Project, please visit <https://lists.camaraproject.org/g/sp-dlo>.
  - A message to the community of this Sub Project can be sent using <sp-dlo@lists.camaraproject.org>.
* Slack channel: [camara-project.slack.com](https://join.slack.com/t/camara-project/shared_invite/zt-26gy3e64n-o7Riy3MoXmzdaDEL3wlngg) #sp-device-location
