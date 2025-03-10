#include <vector>
#include "WiFi.h"
#include "ESPAsyncWebServer.h"
#include "ArduinoJson.h"

std::vector<int> segment_N = {1, 2, 3};
std::vector<int> segment_V = {4, 5, 6};
std::vector<int> segment_S = {7, 8, 9};
std::vector<int> segment_F = {10, 11, 12};
std::vector<int> segment_Q = {13, 1040, 15};

const char *ssid = "NONAME 5368";
const char *password = "testing123";
const int outputPins[12] = {4, 13, 14, 16, 17, 18, 19, 21, 22, 23, 25, 26};
const int outputFreq = 350;

AsyncWebServer server(80);

bool outputActive = false;
std::vector<int> *currentSegment = nullptr;
std::vector<int> dataSamples;

void output12BitData(int data)
{
    Serial.print("Decimal: ");
    Serial.print(data);
    Serial.print(" Binary: ");
    for (int i = 11; i >= 0; i--)
    {
        Serial.print((data >> i) & 0x01);
    }
    Serial.println();

    for (int i = 0; i < 12; i++)
    {
        digitalWrite(outputPins[i], (data >> i) & 0x01);
    }

    // Store data sample
    dataSamples.push_back(data);
    if (dataSamples.size() > 1000)
    {
        dataSamples.erase(dataSamples.begin());
    }
}

void setup()
{
    Serial.begin(115200);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    for (int i = 0; i < 12; i++)
    {
        pinMode(outputPins[i], OUTPUT);
    }

    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
        String html = "<!doctype html><html><head><meta charset=\"UTF-8\" />";
        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
        html += "<script src=\"https://unpkg.com/@tailwindcss/browser@4\"></script></head><body>";
        html += "<div class=\"container mx-auto p-4\">";
        html += "<h1 class=\"text-3xl font-bold underline mb-4\">Select Segment to Output</h1>";
        html += "<button class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"startSegment('N')\">Segment N</button><br>";
        html += "<button class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"startSegment('V')\">Segment V</button><br>";
        html += "<button class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"startSegment('S')\">Segment S</button><br>";
        html += "<button class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"startSegment('F')\">Segment F</button><br>";
        html += "<button class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"startSegment('Q')\">Segment Q</button><br>";
        html += "<button class=\"bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded mb-2\" onclick=\"stopSegment()\">Stop</button><br>";
        html += "<p id=\"status\" class=\"mt-4 text-xl\"></p>";
        html += "<canvas id=\"graph\" width=\"600\" height=\"400\" class=\"border border-gray-300\"></canvas>";
        html += "<script>";
        html += "function startSegment(segment) {";
        html += "fetch('/start_' + segment).then(response => response.text()).then(data => {";
        html += "document.getElementById('status').innerText = data;";
        html += "});";
        html += "}";
        html += "function stopSegment() {";
        html += "fetch('/stop').then(response => response.text()).then(data => {";
        html += "document.getElementById('status').innerText = data;";
        html += "});";
        html += "}";
        html += "function drawGraph(dataSamples) {";
        html += "var canvas = document.getElementById('graph');";
        html += "var ctx = canvas.getContext('2d');";
        html += "ctx.clearRect(0, 0, canvas.width, canvas.height);";
        html += "ctx.beginPath();";
        html += "ctx.moveTo(0, canvas.height / 2);";
        html += "for (var i = 0; i < dataSamples.length; i++) {";
        html += "var x = (i / dataSamples.length) * canvas.width;";
        html += "var y = canvas.height / 2 - (dataSamples[i] / 2048.0) * (canvas.height / 2);"; // Scale data to fit canvas
        html += "ctx.lineTo(x, y);";
        html += "}";
        html += "ctx.stroke();";
        html += "}";
        html += "setInterval(function() {";
        html += "fetch('/data').then(response => response.json()).then(data => {";
        html += "drawGraph(data.samples);";
        html += "});";
        html += "}, 1000);"; // Update graph every second
        html += "</script></div></body></html>";
        request->send(200, "text/html", html);
    });

    server.on("/start_N", HTTP_GET, [](AsyncWebServerRequest *request) {
        currentSegment = &segment_N;
        outputActive = true;
        request->send(200, "text/plain", "Outputting Segment N");
    });

    server.on("/start_V", HTTP_GET, [](AsyncWebServerRequest *request) {
        currentSegment = &segment_V;
        outputActive = true;
        request->send(200, "text/plain", "Outputting Segment V");
    });

    server.on("/start_S", HTTP_GET, [](AsyncWebServerRequest *request) {
        currentSegment = &segment_S;
        outputActive = true;
        request->send(200, "text/plain", "Outputting Segment S");
    });

    server.on("/start_F", HTTP_GET, [](AsyncWebServerRequest *request) {
        currentSegment = &segment_F;
        outputActive = true;
        request->send(200, "text/plain", "Outputting Segment F");
    });

    server.on("/start_Q", HTTP_GET, [](AsyncWebServerRequest *request) {
        currentSegment = &segment_Q;
        outputActive = true;
        request->send(200, "text/plain", "Outputting Segment Q");
    });

    server.on("/stop", HTTP_GET, [](AsyncWebServerRequest *request) {
        outputActive = false;
        request->send(200, "text/plain", "Output stopped");
    });

    server.on("/data", HTTP_GET, [](AsyncWebServerRequest *request) {
        DynamicJsonDocument doc(2048);
        JsonArray samples = doc.createNestedArray("samples");
        for (int sample : dataSamples)
        {
            samples.add(sample);
        }
        String jsonString;
        serializeJson(doc, jsonString);
        request->send(200, "application/json", jsonString);
    });

    server.begin();
}

void loop()
{
    if (outputActive && currentSegment != nullptr)
    {
        static unsigned long lastOutputTime = 0;
        if (millis() - lastOutputTime >= 1000 / outputFreq)
        {
            for (int data : *currentSegment)
            {
                output12BitData(data);
                lastOutputTime = millis();
            }
        }
    }
}
