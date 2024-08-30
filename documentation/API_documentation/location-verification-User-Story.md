# Location Verification API User Story


| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an enterprise application developer, I want to verify the location of a user's device, so that I can ensure the device is within a specified area for security and contextual-based services. |
| ***Actors and Scope*** | **Actors:** Application service provider (ASP), ASP:User, ASP: BusinessManager, ASP:Administrator, Channel Partner, End-User, Communication Service Provider (CSP). <br> **Scope:**  <br> - Verifies if the specified device is located within a predefined geographical area (e.g.circle with given coordinates and radius, polygon...). |
| ***Pre-conditions*** |The preconditions are listed below:<br><ol><li>The ASP:BusinessManager and ASP:Administrator have been onboarded to the CSP's API platform.</li><li>The ASP:BusinessManager has successfully subscribed to the Location Verification API product from the product catalog via (or not) a Channel Partner.</li><li>The ASP:Administrator has onboarded the ASP:User to the platform.</li><li>The ASP:User performs an authorization request to CSP</li><li> The CSP checks access & End-User approval then provide access token to the ASP:User </li><li>The ASP:User get the access token, via (or not) the Channel Partner, allowing a secure access of the API.
| ***Activities/Steps*** | **Starts when:** The ASP:User makes a POST request via the Location Verification API providing the End-User's device identifier (e.g., phone number), the area information (center coordinates and radius, polygon...) and the maximum age of the location information. <br>**Ends when:** The CSP's Location Verification server responds with the verification result indicating if the End-User's device is within the specified area, partially matches the area, or is unknown. |
| ***Post-conditions*** | The ASP:User could continue offering its service to the End-User with the confirmation of the End-User's device location. |
| ***Exceptions*** | Several exceptions might occur during the Location Verification API operations<br>- Unauthorized: Invalid credentials (e.g., expired access token).<br>- Incorrect input data (e.g., malformed phone number).<br>- Not able to provide: Network unable to locate the device due to various reasons (e.g., device not connected, outdated location data). |