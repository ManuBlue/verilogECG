#include "WiFi.h"
#include "ESPAsyncWebServer.h"
#include "segments.cpp"

// Wi-Fi Credentials
const char *ssid = "YourSSID";
const char *password = "YourPassword";

// Define output pins
const int outputPins[12] = {2, 4, 5, 12, 13, 14, 15, 16, 17, 18, 19, 21};

// Sampling frequency and timer
const int samplingFrequency = 360;
const int samplingInterval = 1000000 / samplingFrequency; // in microseconds

// Use std::vector<int> for dynamic arrays
std::vector<int> *segments[] = {&segment_N, &segment_S, &segment_V, &segment_F, &segment_Q};

// Variables for data control
volatile int currentIndex = 0;
volatile int currentSegment = 0;

// Web server setup
AsyncWebServer server(80);

// Timer handle
hw_timer_t *timer = NULL;

// Function to output 12-bit data
void output12BitData(int data)
{
    for (int i = 0; i < 12; i++)
    {
        digitalWrite(outputPins[i], (data >> i) & 0x01);
    }
}

// Timer ISR for sampling
void IRAM_ATTR timerISR()
{
    if (currentIndex < segments[currentSegment]->size())
    {
        output12BitData((*segments[currentSegment])[currentIndex]);
        currentIndex++;
    }
    else
    {
        currentIndex = 0; // Restart the array when done
    }
}

void setup()
{
    Serial.begin(115200);

    // Initialize output pins
    for (int i = 0; i < 12; i++)
    {
        pinMode(outputPins[i], OUTPUT);
    }

    // Initialize hardware timer
    timer = timerBegin(0, 80, true); // Timer 0, prescaler 80 (1μs resolution)
    timerAttachInterrupt(timer, &timerISR, true);
    timerAlarmWrite(timer, samplingInterval, true);
    timerAlarmEnable(timer);

    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");
    Serial.println(WiFi.localIP());

    // Web server to select which segment to play
    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request)
              {
        String html = "<h1>ESP32 Data Output Controller</h1>";
        html += "<p>Current Segment: " + String(currentSegment) + "</p>";
        html += "<a href='/select?seg=0'><button>Segment N</button></a> ";
        html += "<a href='/select?seg=1'><button>Segment S</button></a> ";
        html += "<a href='/select?seg=2'><button>Segment V</button></a> ";
        html += "<a href='/select?seg=3'><button>Segment F</button></a> ";
        html += "<a href='/select?seg=4'><button>Segment Q</button></a>";
        request->send(200, "text/html", html); });

    server.on("/select", HTTP_GET, [](AsyncWebServerRequest *request)
              {
        if (request->hasParam("seg"))
        {
            int newSegment = request->getParam("seg")->value().toInt();
            if (newSegment >= 0 && newSegment < 5)
            {
                currentSegment = newSegment;
                currentIndex = 0; // Reset index when changing segments
                Serial.println("Switched to segment: " + String(currentSegment));
            }
        }
        request->send(200, "text/plain", "Segment changed"); });

    server.begin();
}

void loop()
{
    // Nothing to do, everything is handled by the timer and web server
}
