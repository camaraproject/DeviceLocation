# Location Verification API User Story


| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an enterprise application developer, I want to verify the location of a user's device, so that I can ensure the device is within a specified area for security and contextual-based services. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User, Customer:BusinessManager, Customer:Administrator<br> **Actors:** Application service providers, hyperscalers, application developers, end users. <br> **Scope:**  <br> - Verifies if the specified device is located within a predefined geographical area (circle with given coordinates and radius). |
| ***Pre-conditions*** |The preconditions are listed below:<br><ol><li>The Customer:BusinessManager and Customer:Administrator have been onboarded to the CSP's API platform.</li><li>The Customer:BusinessManager has successfully subscribed to the Location Verification API product from the product catalog.</li><li>The Customer:Administrator has onboarded the Customer:User to the platform.</li><li>The Customer:User performs an authorization request to CSP.</li><li>The Customer:User has the access token allowing a secure access of the API.|
| ***Activities/Steps*** | **Starts when:** The customer application makes a POST request to the Location Verification API providing the device identifier (e.g., phone number) and the area information (center coordinates and radius).<br>**Ends when:** The API server responds with the verification result indicating if the device is within the specified area, partially matches the area, or is unknown. |
| ***Post-conditions*** | The customer application could continue offering its service to the user with the confirmation of the device´s location. |
| ***Exceptions*** | Several exceptions might occur during the Location Verification API operations<br>- Unauthorized: Invalid credentials (e.g., expired access token).<br>- Incorrect input data (e.g., malformed phone number).<br>- Not able to provide: Network unable to locate the device due to various reasons (e.g., device not connected, outdated location data). |
