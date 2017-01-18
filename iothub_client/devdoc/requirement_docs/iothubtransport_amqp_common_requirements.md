
# IoTHubTransport_AMQP_Common Requirements
================

## Overview

This module provides an implementation of the transport layer of the IoT Hub client based on the AMQP API, which implements the AMQP protocol.  
It is the base for the implentation of the actual respective AMQP transports, which will on their side provide the underlying I/O transport for this module.


## Dependencies

This module will depend on the following modules:

azure-c-shared-utility
azure-uamqp-c
iothubtransport_amqp_connection
iothubtransport_amqp_cbsauthentication
iothubtransport_amqp_messenger


## Exposed API

```c
typedef XIO_HANDLE(*AMQP_GET_IO_TRANSPORT)(const char* target_fqdn);

extern TRANSPORT_LL_HANDLE IoTHubTransport_AMQP_Common_Create(const IOTHUBTRANSPORT_CONFIG* config, AMQP_GET_IO_TRANSPORT get_io_transport);
extern void IoTHubTransport_AMQP_Common_Destroy(TRANSPORT_LL_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe(IOTHUB_DEVICE_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle);
extern int IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle);
extern void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle);
extern IOTHUB_PROCESS_ITEM_RESULT IoTHubTransport_AMQP_Common_ProcessItem(TRANSPORT_LL_HANDLE handle, IOTHUB_IDENTITY_TYPE item_type, IOTHUB_IDENTITY_INFO* iothub_item);
extern void IoTHubTransport_AMQP_Common_DoWork(TRANSPORT_LL_HANDLE handle, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle);
extern IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_GetSendStatus(IOTHUB_DEVICE_HANDLE handle, IOTHUB_CLIENT_STATUS* iotHubClientStatus);
extern IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_SetOption(TRANSPORT_LL_HANDLE handle, const char* option, const void* value);
extern IOTHUB_DEVICE_HANDLE IoTHubTransport_AMQP_Common_Register(TRANSPORT_LL_HANDLE handle, const IOTHUB_DEVICE_CONFIG* device, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle, PDLIST_ENTRY waitingToSend);
extern void IoTHubTransport_AMQP_Common_Unregister(IOTHUB_DEVICE_HANDLE deviceHandle);
extern STRING_HANDLE IoTHubTransport_AMQP_Common_GetHostname(TRANSPORT_LL_HANDLE handle);

```


Note: `instance` refers to the structure that holds the current state and control parameters of the transport. 
In each function (other than IoTHubTransport_AMQP_Common_Create) it shall derive from the TRANSPORT_LL_HANDLE handle passed as argument.  


### IoTHubTransport_AMQP_Common_GetHostname
```c
 STRING_HANDLE IoTHubTransport_AMQP_Common_GetHostname(TRANSPORT_LL_HANDLE handle)
```

IoTHubTransport_AMQP_Common_GetHostname provides a STRING_HANDLE containing the hostname with which the transport has been created.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_001: [**If `handle` is NULL, `IoTHubTransport_AMQP_Common_GetHostname` shall return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_002: [**IoTHubTransport_AMQP_Common_GetHostname shall return a copy of `instance->iothub_target_fqdn`.**]**


### IoTHubTransport_AMQP_Common_Create

```c
TRANSPORT_LL_HANDLE IoTHubTransport_AMQP_Common_Create(const IOTHUBTRANSPORT_CONFIG* config, AMQP_GET_IO_TRANSPORT get_io_transport)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_001: [**If `config` or `config->upperConfig` are NULL then IoTHubTransport_AMQP_Common_Create shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_002: [**IoTHubTransport_AMQP_Common_Create shall fail and return NULL if any fields of the `config->upperConfig` structure are NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_003: [**If `get_io_transport` is NULL then IoTHubTransport_AMQP_Common_Create shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_004: [**IoTHubTransport_AMQP_Common_Create shall allocate memory for the transport's internal state structure (`instance`) using malloc()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_005: [**If malloc() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_006: [**If `config->upperConfig->protocolGatewayHostName` is NULL, `instance->iothub_target_fqdn` shall be set using STRING_sprintf() with `config->iotHubName` + "." + `config->iotHubSuffix`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If STRING_sprintf() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If `config->upperConfig->protocolGatewayHostName` is not NULL, `instance->iothub_target_fqdn` shall be set with a copy of it using STRING_construct()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_20_001: [**If STRING_construct() fails, IoTHubTransport_AMQP_Common_Create shall fail and return NULL**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_007: [**IoTHubTransport_AMQP_Common_Create shall set `instance->registered_devices` using VECTOR_create()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_008: [**If VECTOR_create fails, IoTHubTransport_AMQP_Common_Create shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_009: [**`get_io_transport` shall be saved on `instance->underlying_io_transport_provider`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_010: [**If IoTHubTransport_AMQP_Common_Create fails it shall free any memory it allocated**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_011: [**If IoTHubTransport_AMQP_Common_Create succeeds it shall return a pointer to `instance`.**]**

 
### IoTHubTransport_AMQP_Common_Destroy

```c
void IoTHubTransport_AMQP_Common_Destroy(TRANSPORT_LL_HANDLE handle)
```

This function will close connection established through AMQP API, as well as destroy all the components allocated internally for its proper functionality.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_012: [**IoTHubTransport_AMQP_Common_Destroy shall invoke IoTHubTransport_AMQP_Common_Unregister on each of its registered devices.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_013: [**`instance->registered_devices` shall be destroyed using VECTOR_destroy().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_014: [**`instance->connection` shall be destroyed using amqp_connection_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_015: [**IoTHubTransport_AMQP_Common_Destroy shall destroy the STRING_HANDLE parameters in `instance` using STRING_delete()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_016: [**IoTHubTransport_AMQP_Common_Destroy shall destroy any TLS I/O options saved on the transport instance using OptionHandler_Destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_017: [**IoTHubTransport_AMQP_Common_Destroy shall free the memory used by `instance`**]**


### IoTHubTransport_AMQP_Common_DoWork

```c
void IoTHubTransport_AMQP_Common_DoWork(TRANSPORT_LL_HANDLE handle, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle)
```  

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_018: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_019: [**If there are no devices registered on the transport, IoTHubTransport_AMQP_Common_DoWork shall return**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_020: [**If the number of messaging failures is equal or greater than 10% of the number of registered devices, the connection shall be put into faulty state**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_021: [**If the number of authentication failures is equal or greater than 10% of the number of registered devices, the connection shall be put into faulty state**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_022: [**If the transport state has a faulty connection state, IoTHubTransport_AMQP_Common_DoWork shall trigger the connection-retry logic and return**]**


#### Connection Establishment

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_023: [**If `transport->connection` is NULL, it shall be created using amqp_connection_create()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_024: [**If `transport->preferred_authentication_method` is CBS, AMQP_CONNECTION_CONFIG shall be set with `create_sasl_io` = true and `create_cbs_connection` = true**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_025: [**If `transport->preferred_credential_method` is X509, AMQP_CONNECTION_CONFIG shall be set with `create_sasl_io` = false and `create_cbs_connection` = false**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_026: [**`instance->logtrace` shall be set into `AMQP_CONNECTION_CONFIG->logtrace`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_027: [**If amqp_connection_create() fails, IoTHubTransport_AMQP_Common_DoWork shall return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_028: [**IoTHubTransport_AMQP_Common_DoWork shall iterate through all its registered devices to process authentication, events to be sent, messages to be received**]**


#### Per-Device DoWork Requirements

##### Authentication

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_029: [**If `device_instance->authentication` is not NULL and `device_instance->authentication_state` is AUTHENTICATION_STATE_STOPPED, authentication_start() shall be invoked**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_030: [**amqp_connection_get_cbs_handle() shall be invoked on `instance->connection`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_031: [**If amqp_connection_get_cbs_handle() fails, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_032: [**authentication_start() shall be invoked passing the CBS_HANDLE obtained from the connection**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_033: [**If authentication_start() fails, IoTHubTransport_AMQP_Common_DoWork shall skip to the next registered device**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_034: [**If `device_instance->authentication` is not NULL, authentication_do_work() shall be invoked**]**

##### Device Methods
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_031: [** Once the device is authenticated, `iothubtransportamqp_methods_subscribe` shall be invoked (subsequent DoWork calls shall not call it if already subscribed). **]**

##### Messaging

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_035: [**If `device_instance->authentication` is not NULL and `device_instance->authentication_state` is not AUTHENTICATION_STATE_STARTED, IoTHubTransport_AMQP_Common_DoWork shall skip to the next registered device**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_036: [**If `device_instance->messenger_state` is MESSENGER_STATE_STOPPED, messenger_start() shall be invoked**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_037: [**amqp_connection_get_session_handle() shall be invoked on `instance->connection`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_038: [**If amqp_connection_get_session_handle() fails, IoTHubTransport_AMQP_Common_DoWork shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_039: [**messenger_start() shall be invoked passing the SESSION_HANDLE obtained from the connection**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_040: [**If `device_instance->messenger_state` is MESSENGER_STATE_STARTED, messenger_do_work() shall be invoked**]**

  
#### General

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_041: [**IoTHubTransport_AMQP_Common_DoWork shall invoke amqp_connection_dowork() on `instance->connection`**]**


#### Connection-Retry Logic

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_042: [**messenger_stop() shall be invoked on all `instance->registered_devices`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_043: [** Each `instance->registered_devices` shall unsubscribe from receiving C2D method requests by calling `iothubtransportamqp_methods_unsubscribe`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_044: [**If the transport preferred authentication mode is CBS, authentication_stop() shall be invoked on all `instance->registered_devices`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_045: [**`instance->connection` shall be destroyed using amqp_connection_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_046: [**`instance->tls_io` options shall be saved on `instance->saved_tls_options` using xio_retrieveoptions()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_047: [**`instance->tls_io` shall be destroyed using xio_destroy()**]**

Note: all the components above will be re-created and re-started on the next call to IoTHubTransport_AMQP_Common_DoWork.


#### on_connection_state_changed_callback

```c
void on_connection_state_changed_callback(const void* context, AMQP_CONNECTION_STATE old_state, AMQP_CONNECTION_STATE new_state);
```

This handler is provided when amqp_connection_create() is invoked.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_048: [**If `new_state` is AMQP_CONNECTION_STATE_ERROR, the connection shall be flagged as faulty (so the connection retry logic can be triggered)**]**


#### on_cbs_authentication_error_callback

```c
void on_cbs_authentication_error_callback(void* context, AUTHENTICATION_ERROR_CODE error_code);
```

This handler is provided to each registered device when authentication_create() is invoked.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_049: [**If `error_code` is AUTHENTICATION_ERROR_AUTH_TIMEOUT or AUTHENTICATION_ERROR_SAS_REFRESH_TIMEOUT, the regitered device shall be flagged as having an authentication error (so connection retry logic can be triggered)**]**

Note: not all errors should contribute to connection retry logic (since it could be a bad device key, or device clock out of sync, etc).


#### on_authentication_state_changed_callback

```c
void on_authentication_state_changed_callback(void* context, AUTHENTICATION_STATE previous_state, AUTHENTICATION_STATE new_state);
```

This handler is provided to each registered device when messenger_create() is invoked.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_050: [**If `new_state` is MESSENGER_STATE_STARTED and the regitered device was flagged as having an authentication error, the flag shall be cleared**]**


#### on_messenger_state_changed_callback

```c
void on_messenger_state_changed_callback(void* context, MESSENGER_STATE previous_state, MESSENGER_STATE new_state);
```

This handler is provided to each registered device when messenger_create() is invoked.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_051: [**If `new_state` is MESSENGER_STATE_STARTED and the regitered device was flagged as having a messaging error, the flag shall be cleared**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_052: [**If `new_state` is MESSENGER_STATE_ERROR the regitered device shall be flagged as having a messaging error (so connection retry logic can be triggered)**]**


### IoTHubTransport_AMQP_Common_Register

```c
IOTHUB_DEVICE_HANDLE IoTHubTransport_AMQP_Common_Register(TRANSPORT_LL_HANDLE handle, const IOTHUB_DEVICE_CONFIG* device, IOTHUB_CLIENT_LL_HANDLE iotHubClientHandle, PDLIST_ENTRY waitingToSend)
```

This function registers a device with the transport.  The AMQP transport only supports a single device established on create, so this function will prevent multiple devices from being registered.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_17_005: [**IoTHubTransport_AMQP_Common_Register shall return NULL if the `handle` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_17_001: [**IoTHubTransport_AMQP_Common_Register shall return NULL if `device` or `waitingToSend` are NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_053: [**IoTHubTransport_AMQP_Common_Register shall fail and return NULL if the `iotHubClientHandle` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_03_002: [**IoTHubTransport_AMQP_Common_Register shall return NULL if `device->deviceId` is NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_054: [**IoTHubTransport_AMQP_Common_Register shall fail and return NULL if the device is not using an authentication mode compatible with the currently used by the transport.**]**

Note: There should be no devices using different authentication modes registered on the transport at the same time (i.e., either all registered devices use CBS authentication, or all use x509 certificate authentication). 

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_055: [**If a device matching the deviceId provided is already registered, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_056: [**IoTHubTransport_AMQP_Common_Register shall allocate an instance of AMQP_TRANSPORT_DEVICE_STATE to store the state of the new registered device.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_057: [**If malloc fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**

Note: the instance of AMQP_TRANSPORT_DEVICE_STATE will be referred below as `device_instance`.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_058: [**IoTHubTransport_AMQP_Common_Register shall save the handle references to the IoTHubClient, transport, waitingToSend list on `device_instance`.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_059: [**A copy of `config->deviceId` shall be saved into `device_state->device_id`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_060: [**If STRING_construct() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_061: [**If the transport is using CBS authentication, an authentication state shall be created with authentication_create() and stored in `device_instance->authentication`.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_062: [**If authentication_create() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_063: [**`device_instance->messenger` shall be set using messenger_create().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_064: [**If messenger_create() fails, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_010: [** `IoTHubTransport_AMQP_Common_Register` shall create a new iothubtransportamqp_methods instance by calling `iothubtransportamqp_methods_create` while passing to it the the fully qualified domain name and the device Id. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_011: [** If `iothubtransportamqp_methods_create` fails, `IoTHubTransport_AMQP_Common_Register` shall fail and return NULL. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_065: [**IoTHubTransport_AMQP_Common_Register shall add the device to `instance->registered_devices` using VECTOR_push_back().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_066: [**If VECTOR_push_back() fails to add the new registered device, IoTHubTransport_AMQP_Common_Register shall fail and return NULL.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_067: [**If the device is the first being registered on the transport, IoTHubTransport_AMQP_Common_Register shall save its authentication mode as the transport preferred authentication mode.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_068: [**If IoTHubTransport_AMQP_Common_Register fails, it shall free all memory it alloacated.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_069: [**IoTHubTransport_AMQP_Common_Register shall return a handle to `device_instance` as a IOTHUB_DEVICE_HANDLE.**]**


### IoTHubTransport_AMQP_Common_Unregister

```c
void IoTHubTransport_AMQP_Common_Unregister(IOTHUB_DEVICE_HANDLE deviceHandle)
```

This function is intended to remove a device if it is registered with the transport.  

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_070: [**if `deviceHandle` provided is NULL, IoTHubTransport_AMQP_Common_Unregister shall fail and return.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_071: [**if `deviceHandle` has a NULL reference to its transport instance, IoTHubTransport_AMQP_Common_Unregister shall fail and return.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_072: [**If the device is not registered with this transport, IoTHubTransport_AMQP_Common_Unregister shall fail and return**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_073: [**`device_state->messenger` shall be destroyed using messenger_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_074: [**If `device_instance->authentication` is set, it shall be destroyed using authentication_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_012: [**IoTHubTransport_AMQP_Common_Unregister shall destroy the C2D methods handler by calling iothubtransportamqp_methods_destroy**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_075: [**`device_instance->authentication` is set, it shall be destroyed using authentication_destroy()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_076: [**`device_instance` shall be removed from `instance->registered_devices` using VECTOR_erase().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_077: [**`device_state->device_id` shall be destroyed using STRING_delete()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_078: [**IoTHubTransport_AMQP_Common_Unregister shall free the memory allocated for the `device_instance`**]**


### IoTHubTransport_AMQP_Common_Subscribe

```c
int IoTHubTransport_AMQP_Common_Subscribe(IOTHUB_DEVICE_HANDLE handle)
```

This function enables the transport to notify the upper client layer of new messages received from the cloud to the device.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_079: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_080: [**If `device_instance` is not registered, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_081: [**messenger_subscribe_for_messages() shall be invoked passing `device_instance->messenger` and `on_message_received_callback`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_082: [**If messenger_subscribe_for_messages() fails, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_083: [**If no failures occur, IoTHubTransport_AMQP_Common_Subscribe shall return 0**]**


#### on_message_received_callback

````c
MESSENGER_DISPOSITION_RESULT on_message_received_callback(IOTHUB_MESSAGE_HANDLE message, void* context)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_084: [**IoTHubClient_LL_MessageCallback() shall be invoked passing the client and the incoming message handles as parameters**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_085: [**The IOTHUB_MESSAGE_HANDLE instance shall be destroyed after invoking IoTHubClient_LL_MessageCallback().**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_086: [**on_message_received_callback shall return the result of messaging_delivery_accepted() if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_ACCEPTED**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_087: [**on_message_received_callback shall return the result of messaging_delivery_released() if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_ABANDONED**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_088: [**on_message_received_callback shall return the result of messaging_delivery_rejected("Rejected by application", "Rejected by application") if the IoTHubClient_LL_MessageCallback() returns IOTHUBMESSAGE_REJECTED**]**


### IoTHubTransport_AMQP_Common_Unsubscribe

```c
void IoTHubTransport_AMQP_Common_Unsubscribe(IOTHUB_DEVICE_HANDLE handle)
```

This function disables the notifications to the upper client layer of new messages received from the cloud to the device.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_089: [**If `handle` is NULL, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_090: [**If `device_state` is not registered, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_091: [**messenger_unsubscribe_for_messages() shall be invoked passing `device_instance->messenger`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_092: [**If messenger_unsubscribe_for_messages() fails, IoTHubTransport_AMQP_Common_Subscribe shall return a non-zero result**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_093: [**If no failures occur, IoTHubTransport_AMQP_Common_Unsubscribe shall return 0**]**

  
### IoTHubTransport_AMQP_Common_GetSendStatus

```c
IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_GetSendStatus(IOTHUB_DEVICE_HANDLE handle, IOTHUB_CLIENT_STATUS *iotHubClientStatus)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_094: [**If `handle` or `iotHubClientStatus` are NULL, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_095: [**IoTHubTransport_AMQP_Common_GetSendStatus shall invoke messenger_get_send_status() passing `device_instance->messenger`**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_096: [**If messenger_get_send_status() fails, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_097: [**If messenger_get_send_status() returns MESSENGER_IDLE, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_OK and status IOTHUB_CLIENT_SEND_STATUS_IDLE**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_098: [**If messenger_get_send_status() returns MESSENGER_BUSY, IoTHubTransport_AMQP_Common_GetSendStatus shall return IOTHUB_CLIENT_OK and status IOTHUB_CLIENT_SEND_STATUS_BUSY**]**

  
### IoTHubTransport_AMQP_Common_SetOption

```c
IOTHUB_CLIENT_RESULT IoTHubTransport_AMQP_Common_SetOption(TRANSPORT_LL_HANDLE handle, const char* option, const void* value)
```

Summary of options:

|Parameter              |Possible Values               |Details                                          |
|-----------------------|------------------------------|-------------------------------------------------|
|TrustedCerts           |                              |Sets the certificate to be used by the transport.|
|sas_token_lifetime     | 0 to TIME_MAX (seconds)      |Default: 3600 seconds (1 hour)	How long a SAS token created by the transport is valid, in seconds.|
|sas_token_refresh_time | 0 to TIME_MAX (seconds)      |Default: sas_token_lifetime/2	Maximum period of time for the transport to wait before refreshing the SAS token it created previously.|
|cbs_request_timeout    | 1 to TIME_MAX (seconds)      |Default: 30 seconds	Maximum time the transport waits for AMQP cbs_put_token() to complete before marking it a failure.|
|x509certificate        | const char*                  |Default: NONE. An x509 certificate in PEM format |
|x509privatekey         | const char*                  |Default: NONE. An x509 RSA private key in PEM format|
|logtrace               | true or false                |Default: false|


**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_099: [**If handle parameter is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_100: [**If parameter optionName is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_101: [**If parameter value is NULL then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_102: [**If `option` is "sas_token_lifetime" and the transport preferred authentication mode is not CBS, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_103: [**If `option` is "sas_token_lifetime", `value` shall be saved and applied to each registered device authentication instance, if defined, using authentication_set_sas_token_lifetime_secs()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_104: [**If `option` is "sas_token_refresh_time" and the transport preferred authentication mode is not CBS, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_105: [**If `option` is "sas_token_refresh_time", `value` shall be saved and applied to each registered device authentication instance, if defined, using authentication_set_sas_token_refresh_time_secs()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_106: [**If `option` is "cbs_request_timeout" and the transport preferred authentication mode is not CBS, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_107: [**If `option` is "cbs_request_timeout", `value` shall be saved and applied to each registered device authentication instance, if defined, using authentication_set_cbs_request_timeout_secs()**]**

The following requirements only apply to x509 authentication:
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_007: [** If `option` is `x509certificate` and the transport preferred authentication method is not x509 then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_008: [** If `option` is `x509privatekey` and the transport preferred authentication method is not x509 then IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_INVALID_ARG. **]**

The remaining requirements apply independent of the authentication mode:
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_108: [**If `option` is `logtrace`, `value` shall be saved and applied to `instance->connection` using amqp_connection_set_logging()**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_109: [**If `option` does not match one of the options handled by this module, it shall be passed to `instance->tls_io` using xio_setoption()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_110: [**If `instance->tls_io` is NULL, it shall be set invoking instance->underlying_io_transport_provider()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_111: [**If instance->underlying_io_transport_provider() fails, IoTHubTransport_AMQP_Common_SetOption shall fail and return IOTHUB_CLIENT_ERROR**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_09_112: [**When `instance->tls_io` is created, IoTHubTransport_AMQP_Common_SetOption shall apply `instance->saved_tls_options` with OptionHandler_FeedOptions()**]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_03_001: [**If xio_setoption fails, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_ERROR.**]**

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_03_001: [**If no failures occur, IoTHubTransport_AMQP_Common_SetOption shall return IOTHUB_CLIENT_OK.**]**


### IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin
```c
int IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle, IOTHUB_DEVICE_TWIN_STATE subscribe_state)
```

`IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin` subscribes to DeviceTwin's messages. Not implemented at the moment.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_009: [** `IoTHubTransport_AMQP_Common_Subscribe_DeviceTwin` shall return a non-zero value. **]**


### IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin
```c
void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin(IOTHUB_DEVICE_HANDLE handle, IOTHUB_DEVICE_TWIN_STATE subscribe_state)
```

`IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin` unsubscribes from DeviceTwin's messages. Not implemented.

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_02_010: [** `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceTwin` shall return. **]**


### IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod
```c
int IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_026: [** `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall remember that a subscribe is to be performed in the next call to DoWork and on success it shall return 0. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_004: [** If `handle` is NULL, `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall fail and return a non-zero value. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_005: [** If the transport is already subscribed to receive C2D method requests, `IoTHubTransport_AMQP_Common_Subscribe_DeviceMethod` shall perform no additional action and return 0. **]**


### IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod
```c
void IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod(IOTHUB_DEVICE_HANDLE handle)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_006: [** If `handle` is NULL, `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall do nothing. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_007: [** `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall unsubscribe from receiving C2D method requests by calling `iothubtransportamqp_methods_unsubscribe`. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_008: [** If the transport is not subscribed to receive C2D method requests then `IoTHubTransport_AMQP_Common_Unsubscribe_DeviceMethod` shall do nothing. **]**


### on_methods_request_received

```c
void on_methods_request_received(void* context, const char* method_name, const unsigned char* request, size_t request_size, IOTHUBTRANSPORT_AMQP_METHOD_HANDLE method_handle);
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_016: [** `on_methods_request_received` shall create a BUFFER_HANDLE by calling `BUFFER_new`. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_028: [** On success, `on_methods_request_received` shall return 0. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_025: [** If creating the buffer fails, on_methods_request_received shall fail and return a non-zero value. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_017: [** `on_methods_request_received` shall call the `IoTHubClient_LL_DeviceMethodComplete` passing the method name, request buffer and size and the newly created BUFFER handle. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_019: [** `on_methods_request_received` shall call `iothubtransportamqp_methods_respond` passing to it the `method_handle` argument, the response bytes, response size and the status code. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_020: [** The response bytes shall be obtained by calling `BUFFER_u_char`. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_021: [** The response size shall be obtained by calling `BUFFER_length`. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_022: [** The status code shall be the return value of the call to `IoTHubClient_LL_DeviceMethodComplete`. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_023: [** After calling `iothubtransportamqp_methods_respond`, the allocated buffer shall be freed by using BUFFER_delete. **]**
**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_029: [** If `iothubtransportamqp_methods_respond` fails, `on_methods_request_received` shall return a non-zero value. **]**


### on_methods_error

```c
void on_methods_error(void* context)
```

**SRS_IOTHUBTRANSPORT_AMQP_COMMON_01_030: [** `on_methods_error` shall do nothing. **]**
