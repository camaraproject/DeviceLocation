#-
# ---license-start
# CAMARA Project
# ---
# Copyright (C) 2023 - 2024 Contributors | Deutsche Telekom AG to CAMARA a Series
#
# The contributor of this file confirms his sign-off for the
# Developer Certificate of Origin
#             (http://developercertificate.org).
# ---
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---license-end

 @Geofencing 
Feature: Operations to manage event subscription on geofencing events for leaving and entering in an area

  @geofencing_01_Create_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription
    Given they use the geofencing url
    When they create subscription
    Then Response code is 201

  @geofencing_02_Operation_to_retrieve_list_of_subscriptions.--Not yet implemented
  Scenario: Get a list of subscriptions.
    Given they use the geofencing url
    When they get all subscriptions
    Then Response code is 200


  @geofencing_03_Operation_to_retrieve_subscription_based_on_the_provided_ID
  Scenario: Get a subscription based on provided id.
    Given they use the geofencing url
    When they get subscription for subscription-id
    Then Response code is 200

  @geofencing_04_Operation_to_delete_subscription_based_on_the_provided_ID
  Scenario: Delete a subscription based on provided id.
    Given they use the geofencing url
    When they delete subscription for subscription-id
    Then Response code is 204

  @geofencing_05_Create_invalid_geofencing_subscription_for_a_device
  Scenario:  Create geofencing subscription with invalid parameter
    Given they use the geofencing url
    When they create subscription with invalid parameter
    Then Response code is 400

  @geofencing_06_Get_invalid_geofencing_subscription_for_a_device
  Scenario:  Get geofencing subscription with invalid parameter
    Given they use the geofencing url
    When they get subscription with invalid subscription-id
    Then Response code is 404


  @geofencing_07_Delete_invalid_geofencing_subscription_for_a_device
  Scenario:  Delete geofencing subscription with invalid parameter
    Given they use the geofencing url
    When they delete subscription with invalid subscription-id
    Then Response code is 404

  @geofencing_08_Invalid_method_geofencing_subscription_for_a_device
  Scenario:  Update geofencing subscription
    Given they use the geofencing url
    When they update subscription
    Then Response code is 405


  @geofencing_09_creation_of_subscription_for_subscribed_expired_time_in_past
  Scenario:  Subscribed expire time in past for geofencing subscription
    Given they use the geofencing url
    When they create subscription with expire time in past
    Then Response code is 400


  @geofencing_10_creation_of_subscription_when_service_unavailable
  Scenario: Subscription creation when service unavailable
    Given they use the geofencing url
    When they create subscription when service is unavailable
    Then Response code is not  503

  @geofencing_11_Get_Event-Details_of_subscription_entered
  Scenario: Subscription creation when service have area-entered event
    Given they use the geofencing url
    When they create subscription with event have area-entered at "Boon"
    When they create subscription with event have area-entered at "Berlin" and device enters "Berlin"
    Then they get event details from notifications-url
    Then Response code is 200

  @geofencing_12_Get_Event-Details_of_subscription_left
  Scenario: Subscription creation when service have area-left event
    Given they use the geofencing url
    When they create subscription with event have area-left with at "Boon"
	When they create subscription with event have area-left with at "Berlin" and device left "Boon"
    Then they get event details from notifications-url
    Then Response code is 200

  @geofencing_13_Getting_of_subscription_when_service_unavailable
  Scenario: Getting Subscription when service unavailable
    Given they use the geofencing url
    When they get subscription when service is unavailable
    Then Response code is not  503


  @geofencing_14_Deletion_of_subscription_when_service_unavailable
  Scenario: Deletion Subscription when service unavailable
    Given they use the geofencing url
    When they delete subscription when service is unavailable
    Then Response code is not  503
