#include <ESP8266WiFi.h>

// Static IP details
IPAddress local_IP(192, 168, 0, 50);
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);
IPAddress dns(8, 8, 8, 8);



const char* ssid = "VenbaACT";
const char* password = "9655514937";

void setup() {
  Serial.begin(115200);

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);  // LED off initially (active LOW)

  Serial.println();
  Serial.println("Connecting to WiFi...");
  
  // Set static IP before connecting
  WiFi.config(local_IP, gateway, subnet, dns);

  WiFi.begin(ssid, password);

  // blink LED while connecting
  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(LED_BUILTIN, LOW);   // LED OFF
    delay(200);
    digitalWrite(LED_BUILTIN, HIGH);  // LED ON
    delay(200);
    Serial.print(".");
  }

  Serial.println("\nWiFi Connected!");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());

  digitalWrite(LED_BUILTIN, LOW);   // LED OFF (connected)
}

void loop() {
  // If WiFi drops, turn LED OFF
  if (WiFi.status() != WL_CONNECTED) {
    digitalWrite(LED_BUILTIN, HIGH);  // LED ON
  }
}
