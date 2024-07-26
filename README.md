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
  * verify the location of a device (location-verification).
  * retrieve the location of a device (location-retrieval).
  * subscribe and receive notifications about a device entering or leaving certain location (geofencing-subscriptions). 
  * NOTE: The scope of this API family should be limited (at least at a first stage) to 4G and 5G.  
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: July 2022
* Location: virtually  

## Release Information

* The latest public release is available here: https://github.com/camaraproject/DeviceLocation/releases/latest
* For changes see [CHANGELOG.md](https://github.com/camaraproject/DeviceLocation/blob/main/CHANGELOG.md) 

* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* The latest pre-release is [r1.1](https://github.com/camaraproject/DeviceLocation/tree/r1.1)  
The release r1.1 contains the following API definitions (with inline documentation):
  - **location-verification** [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/location-verification.yaml) [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-verification.yaml&nocors) [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-verification.yaml)
  - **location-retrieval** [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/location-retrieval.yaml) [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml&nocors) [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/location-retrieval.yaml)
  - **geofencing-subscriptions** [[YAML OAS]](https://github.com/camaraproject/DeviceLocation/blob/r1.1/code/API_definitions/geofencing.yaml) [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/geofencing.yaml&nocors) [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceLocation/r1.1/code/API_definitions/geofencing.yaml)

## Contributing

* Meetings are held virtually
  - Schedule: bi-weekly (odd weeks), Tuesday, 9 AM CET/CEST
  - Meeting link: [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/91878854906?password=7e620a89-fcb5-4d2d-927a-17e3a0d1d28e)
* Mailing list:
  - To subscribe / unsubscribe to the mailing list of this Sub Project, please visit <https://lists.camaraproject.org/g/sp-dlo>.
  - A message to the community of this Sub Project can be sent using <sp-dlo@lists.camaraproject.org>.
* Slack channel: [camara-project.slack.com](https://join.slack.com/t/camara-project/shared_invite/zt-26gy3e64n-o7Riy3MoXmzdaDEL3wlngg) #sp-device-location