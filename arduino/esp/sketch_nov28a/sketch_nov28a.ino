#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// ----- WiFi -----
// Static IP details
IPAddress local_IP(192, 168, 0, 50);
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);
IPAddress dns(8, 8, 8, 8);

const char* ssid = "VenbaACT";
const char* password = "9655514937";

// ----- MQTT -----
const char* mqtt_server = "192.168.0.9";
const int mqtt_port = 1883;
const char* mqtt_user = "sarathkumar";
const char* mqtt_pass = "9655514937";

// Topics used by HA
const char* topic_cmd   = "home/esp/esp8266_1";        // HA → ESP
const char* topic_state = "home/esp/esp8266_1/state";  // ESP → HA

// Relay pins
int relayPins[] = {D1, D2, D5, D6};
int relayCount = sizeof(relayPins) / sizeof(relayPins[0]);

WiFiClient espClient;
PubSubClient client(espClient);

// --------------------------------------------------------------------

void callback(char* topic, byte* payload, unsigned int length) {
  payload[length] = '\0';
  String msg = String((char*)payload);
  String t = String(topic);

  Serial.printf("MQTT → Topic: %s | Message: %s\n", t.c_str(), msg.c_str());

  // Only accept the main command topic
  if (t != topic_cmd) return;

  // Control built-in LED
  if (msg == "ON") {
    digitalWrite(LED_BUILTIN, LOW);   // LED ON
  } else if (msg == "OFF") {
    digitalWrite(LED_BUILTIN, HIGH);  // LED OFF
  }

  // Publish state back
  client.publish(topic_state, msg.c_str(), true);
}

// --------------------------------------------------------------------

void reconnectMQTT() {
  while (!client.connected()) {
    Serial.print("Connecting to MQTT... ");

    if (client.connect("esp8266_1", mqtt_user, mqtt_pass)) {
      Serial.println("Connected!");

      // Subscribe to only main command topic
      client.subscribe(topic_cmd);
      Serial.printf("Subscribed: %s\n", topic_cmd);

    } else {
      Serial.print("Failed, rc=");
      Serial.print(client.state());
      Serial.println(" Retrying in 3 seconds...");
      delay(3000);
    }
  }
}

// --------------------------------------------------------------------

void setup() {
  Serial.begin(115200);
  delay(500);

  // Built-in LED
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);  // LED initially OFF

  // Relay pins
  for (int i = 0; i < relayCount; i++) {
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], LOW);
  }

  // Static IP
  WiFi.config(local_IP, gateway, subnet, dns);

  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }

  Serial.println("\nWiFi Connected");
  Serial.println(WiFi.localIP());

  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

// --------------------------------------------------------------------

void loop() {
  if (!client.connected()) {
    reconnectMQTT();
  }
  client.loop();
}
