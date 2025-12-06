#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// ----- GPIO PINS -----
#define GPIO2_PIN   2
#define GPIO3_PIN   3
#define GPIO12_PIN  12
#define GPIO13_PIN  13
#define GPIO14_PIN  14
#define GPIO15_PIN  15

//------ ESP8622 HWs -- While programming to be Changed 
//1. ESP8622 - Test
int ip_address_test = 50;
const char* topic_cmd_test   = "home/esp/esp8266_test";    // HA → ESP
const char* topic_state_test = "home/esp/esp8266_test/state";  // ESP → HA
//2. ESP8622 - Motor
int ip_address_motor = 51;
const char* topic_cmd_motor   = "home/esp/esp8266_motor";    // HA → ESP
const char* topic_state_motor = "home/esp/esp8266_motor/state";  // ESP → HA
//1. ESP8622 - TV
int ip_address_tv = 52;
const char* topic_cmd_tv = "home/esp/esp8266_tv";    // HA → ESP
const char* topic_state_tv = "home/esp/esp8266_tv/state";  // ESP → HA


// ----- WiFi -----
// Static IP details
IPAddress local_IP(192, 168, 0, ip_address_motor); 
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);
IPAddress dns(8, 8, 8, 8);

// Topics used by HA
const char* topic_cmd   = topic_cmd_motor;
const char* topic_state = topic_state_motor;


const char* ssid = "VenbaACT";
const char* password = "9655514937";

// ----- MQTT -----
const char* mqtt_server = "192.168.0.9";
const int mqtt_port = 1883;
const char* mqtt_user = "sarathkumar";
const char* mqtt_pass = "9655514937";


WiFiClient espClient;
PubSubClient client(espClient);

// --------------------------------------------------------------------

void callback(char* topic, byte* payload, unsigned int length) {
  payload[length] = '\0';
  String msg = String((char*)payload);
  String t = String(topic);

  Serial.printf("MQTT → Topic: %s | Message: %s\n", t.c_str(), msg.c_str());

  if (t != topic_cmd) return;

  // ----- Built-in LED -----
  if (msg == "LED_ON") {
    digitalWrite(LED_BUILTIN, LOW);
  } 
  else if (msg == "LED_OFF") {
    digitalWrite(LED_BUILTIN, HIGH);
  }

  // ----- GPIO CONTROL -----
  else if (msg == "GPIO2_ON") digitalWrite(GPIO2_PIN, HIGH);
  else if (msg == "GPIO2_OFF") digitalWrite(GPIO2_PIN, LOW);

  else if (msg == "GPIO3_ON") digitalWrite(GPIO3_PIN, HIGH);
  else if (msg == "GPIO3_OFF") digitalWrite(GPIO3_PIN, LOW);

  else if (msg == "GPIO12_ON") digitalWrite(GPIO12_PIN, HIGH);
  else if (msg == "GPIO12_OFF") digitalWrite(GPIO12_PIN, LOW);

  else if (msg == "GPIO13_ON") digitalWrite(GPIO13_PIN, HIGH);
  else if (msg == "GPIO13_OFF") digitalWrite(GPIO13_PIN, LOW);

  else if (msg == "GPIO14_ON") digitalWrite(GPIO14_PIN, HIGH);
  else if (msg == "GPIO14_OFF") digitalWrite(GPIO14_PIN, LOW);

  else if (msg == "GPIO15_ON") digitalWrite(GPIO15_PIN, HIGH);
  else if (msg == "GPIO15_OFF") digitalWrite(GPIO15_PIN, LOW);

  // Publish received command as state
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

    // Set GPIOs as OUTPUT
  pinMode(GPIO2_PIN, OUTPUT);
  pinMode(GPIO3_PIN, OUTPUT);
  pinMode(GPIO12_PIN, OUTPUT);
  pinMode(GPIO13_PIN, OUTPUT);
  pinMode(GPIO14_PIN, OUTPUT);
  pinMode(GPIO15_PIN, OUTPUT);

  // Default OFF
  digitalWrite(GPIO2_PIN, LOW);
  digitalWrite(GPIO3_PIN, LOW);
  digitalWrite(GPIO12_PIN, LOW);
  digitalWrite(GPIO13_PIN, LOW);
  digitalWrite(GPIO14_PIN, LOW);
  digitalWrite(GPIO15_PIN, LOW);


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
