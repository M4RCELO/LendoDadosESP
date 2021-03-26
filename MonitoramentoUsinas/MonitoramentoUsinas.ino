#include <WiFi.h>
#include "FirebaseESP32.h"

// Credenciais wifi
#define WIFI_SSID "TUTU"
#define WIFI_PASSWORD "epsonl355"

// Credenciais Firebase
#define FIREBASE_HOST "https://testes-a00da-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "XrhWRbXZxpVNFEUajFfc0wAZGrY7lUBNN0uWyv9V"

// Tipo Firebase
FirebaseData firebaseData;

// Variáveis
String nodo = "/Geral";
bool iterar = true;

WiFiServer wifiServer(80);

void setup()
{

  Serial.begin(115200);
  Serial.println();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Conectando ao Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.println(WiFi.localIP());
  wifiServer.begin();

  // Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
}

void loop()
{
    WiFiClient client = wifiServer.available();
    if (client)
    {
      while (client.connected())
      {
        String dado = "";
        while (client.available() > 0)
        { 
          char c = client.read();
          dado += c;
          if(client.available()==1){
            Firebase.pushFloat(firebaseData, nodo+"/Dados", dado.toFloat());
          }
        }
      }

      client.stop();
    }
//    Firebase.end(firebaseData);
}
