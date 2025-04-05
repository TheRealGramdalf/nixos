/*
  user_config_override.h - user configuration overrides my_user_config.h for Tasmota

  Copyright (C) 2021  Theo Arends

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _USER_CONFIG_OVERRIDE_H_
#define _USER_CONFIG_OVERRIDE_H_

// force the compiler to show a warning to confirm that this file is included
#warning **** Message from the void: Using Settings from Nix ****

#ifdef ESP8266
#define MODULE                 USER_MODULE      // [Module] Select default module, use the template defined below
#define USER_TEMPLATE "{\"NAME\":\"Teckin SP10\",\"GPIO\":[255,255,56,255,255,255,0,0,255,17,255,21,255],\"FLAG\":0,\"BASE\":18}"  // [Template] Set JSON template
#endif  // ESP8266

#ifndef USE_MQTT_TLS
#define USE_MQTT_TLS                          // Use TLS for MQTT connection (+34.5k code, +7.0k mem and +4.8k additional during connection handshake)
#define USE_MQTT_TLS_CA_CERT              // Force full CA validation instead of fingerprints, slower, but simpler to use.  (+2.2k code, +1.9k mem during connection handshake)
                                              // This includes the LetsEncrypt CA in tasmota_ca.ino for verifying server certificates

// -- Setup your own MQTT settings  ---------------
#undef  MQTT_HOST
#define MQTT_HOST         "mqtt.aer.dedyn.io" // [MqttHost]

#undef  MQTT_PORT
#define MQTT_PORT         8883                   // [MqttPort] MQTT port (10123 on CloudMQTT)

#undef  MQTT_USER
#define MQTT_USER         "iot-devices"         // [MqttUser] Optional user

#undef  MQTT_PASS
#define MQTT_PASS         "changeme"         // [MqttPassword] Optional password

#define MQTT_TLS_ENABLED       true           // [SetOption103] Enable TLS mode (requires TLS version)

#endif // USE_MQTT_TLS

#ifndef USE_4K_RSA  // Support 4k RSA keys
#define USE_4K_RSA
#endif


#endif  // _USER_CONFIG_OVERRIDE_H_