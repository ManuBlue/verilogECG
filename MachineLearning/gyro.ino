#include <WiFi.h>
#include <WebServer.h>
#include <AccelStepper.h>
#include <ESP32Servo.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <math.h>

int step1 = 14; // D5
int dir1 = 27;  // Replaced D6 with GPIO 27

int step2 = 13; // D7
int dir2 = 26;  // Replaced D8 with GPIO 26

int speed = 200;
AccelStepper stepper1(1, step1, dir1); // Motor 1 connected to pins D5 and GPIO 27
AccelStepper stepper2(1, step2, dir2); // Motor 2 connected to pins D7 and GPIO 26

const char *ssid = "NONAME 5368";
const char *password = "testing123";

WebServer server(80);

Servo rollServo;
Servo pitchServo;
Adafruit_MPU6050 mpu;
const int MIN_ANGLE = 0;
const int MAX_ANGLE = 180;
const float THRESHOLD = 5.0;
float currentPitchAngle = 90;
float currentRollAngle = 90;
bool gimbalEnabled = false;

const char htmlPage[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html>
<head>
  <title>Control Interface</title>
</head>
<body>
  <h1>Control Stepper Motors and Gimbal</h1>

  <h2>Stepper Motor Control</h2>
  <button onclick="sendCommand('motor1_forward')">Move Motor 1 Forward</button>
  <button onclick="sendCommand('motor1_backward')">Move Motor 1 Backward</button>
  <label for="motor1_speed">Motor 1 Speed:</label>
  <input type="range" id="motor1_speed" min="0" max="200" value="200" oninput="updateSpeed('motor1', this.value)">
  <span id="motor1_speed_value">200</span>
  <br>
  <button onclick="sendCommand('motor2_forward')">Move Motor 2 Forward</button>
  <button onclick="sendCommand('motor2_backward')">Move Motor 2 Backward</button>
  <label for="motor2_speed">Motor 2 Speed:</label>
  <input type="range" id="motor2_speed" min="0" max="200" value="200" oninput="updateSpeed('motor2', this.value)">
  <span id="motor2_speed_value">200</span>
  <br>
  <button onclick="sendCommand('stop_all')">Stop All Motors</button>

  <h2>Gimbal Control</h2>
  <button onclick="sendCommand('gimbal_on')">Turn Gimbal On</button>
  <button onclick="sendCommand('gimbal_off')">Turn Gimbal Off</button>
  <br>
  <button onclick="sendCommand('reset_servos')">Reset Servos</button>

  <script>
    function sendCommand(command) {
      fetch('/control?cmd=' + command)
        .then(response => console.log('Command sent: ' + command));
    }

    function updateSpeed(motor, speed) {
      document.getElementById(motor + '_speed_value').innerText = speed;
      fetch('/control?cmd=' + motor + '_speed&value=' + speed)
        .then(response => console.log(`Speed updated for ${motor}: ${speed}`));
    }
  </script>
  <h2>Servo Control</h2>
<label for="roll_servo">Roll Servo Position:</label>
<input type="number" id="roll_servo" min="0" max="180" value="90">
<button onclick="setServoPosition('roll', document.getElementById('roll_servo').value)">Set Roll</button>
<br>
<label for="pitch_servo">Pitch Servo Position:</label>
<input type="number" id="pitch_servo" min="0" max="180" value="75">
<button onclick="setServoPosition('pitch', document.getElementById('pitch_servo').value)">Set Pitch</button>
<br>

<script>
    function setServoPosition(servo, position) {
      fetch(`/control?cmd=${servo}_servo&value=${position}`)
        .then(response => console.log(`Servo ${servo} set to ${position}`));
    }
</script>

</body>
</html>
)rawliteral";

void setup()
{
    pinMode(step1, OUTPUT);
    pinMode(dir1, OUTPUT);
    pinMode(step2, OUTPUT);
    pinMode(dir2, OUTPUT);

    Serial.begin(115200);
    Serial.println("Starting...");

    stepper1.setMaxSpeed(1000);
    stepper1.setSpeed(0);
    stepper2.setMaxSpeed(1000);
    stepper2.setSpeed(0);

    rollServo.attach(18);  // Pin for roll servo
    pitchServo.attach(19); // Pin for pitch servo

    mpu.begin();
    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
    mpu.setGyroRange(MPU6050_RANGE_500_DEG);
    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

    Serial.print("Connecting to WiFi: ");
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected!");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    server.on("/", HTTP_GET, []()
              {
    Serial.println("Serving HTML page...");
    server.send_P(200, "text/html", htmlPage); });

    server.on("/control", HTTP_GET, []()
              {
    String command = server.arg("cmd");
    Serial.print("Received command: ");
    Serial.println(command);

    if (command == "motor1_forward") {
      Serial.println("Moving Motor 1 Forward");
      stepper1.setSpeed(abs(speed));

    } else if (command == "motor1_backward") {
      Serial.println("Moving Motor 1 Backward");
      stepper1.setSpeed(-1*abs(speed));
 
    } else if (command == "motor2_forward") {
      Serial.println("Moving Motor 2 Forward");
      stepper2.setSpeed(abs(speed));
    } else if (command == "motor2_backward") {
      Serial.println("Moving Motor 2 Backward");
      stepper2.setSpeed(-1*abs(speed));
    } else if (command == "stop_all") {
      Serial.println("Stopping both motors");
      stepper1.setSpeed(0);
      stepper2.setSpeed(0);
    } else if (command.startsWith("motor1_speed")) {
      speed = server.arg("value").toInt();
      Serial.print("Updated Motor 1 Speed: ");
      Serial.println(speed);
    } else if (command.startsWith("motor2_speed")) {
      speed = server.arg("value").toInt();
      Serial.print("Updated Motor 2 Speed: ");
      Serial.println(speed);
    } else if (command == "gimbal_on") {
      Serial.println("Turning gimbal on");
      gimbalEnabled = true;
    } else if (command == "gimbal_off") {
      Serial.println("Turning gimbal off");
      gimbalEnabled = false;
    } else if (command == "reset_servos") {
      Serial.println("Resetting servos to neutral position");
      currentPitchAngle = 75;
      currentRollAngle = 90;
      pitchServo.write(currentPitchAngle);
      rollServo.write(currentRollAngle);
    }
    else if (command.startsWith("roll_servo")) {
    int rollPos = server.arg("value").toInt();
    rollPos = constrain(rollPos, MIN_ANGLE, MAX_ANGLE);
    rollServo.write(rollPos);
    Serial.print("Roll servo set to: ");
    Serial.println(rollPos);
    } else if (command.startsWith("pitch_servo")) {
        int pitchPos = server.arg("value").toInt();
        pitchPos = constrain(pitchPos, MIN_ANGLE, MAX_ANGLE);
        pitchServo.write(pitchPos);
        Serial.print("Pitch servo set to: ");
        Serial.println(pitchPos);
    }

     else {
      Serial.println("Unknown command");
    }
    server.send(200, "text/plain", "OK"); });

    server.begin();
    Serial.println("HTTP server started");
}

void loop()
{
    server.handleClient();
    stepper1.runSpeed();
    stepper2.runSpeed();
    if (gimbalEnabled)
    {
        sensors_event_t a, g, temp;
        mpu.getEvent(&a, &g, &temp);

        float pitch = atan2(a.acceleration.y, sqrt(pow(a.acceleration.x, 2) + pow(a.acceleration.z, 2))) * 180.0 / M_PI;
        float roll = atan2(-a.acceleration.x, sqrt(pow(a.acceleration.y, 2) + pow(a.acceleration.z, 2))) * 180.0 / M_PI;
        currentPitchAngle = pitchServo.read();
        currentRollAngle = rollServo.read();
        if (fabs(pitch) > 0)
        {
            if (pitch < 0)
            {
                currentPitchAngle += 1;
            }
            else
            {
                currentPitchAngle -= 1;
            }
            currentPitchAngle = constrain(currentPitchAngle, MIN_ANGLE, MAX_ANGLE);
            pitchServo.write(currentPitchAngle);
            delay(10);
        }

        if (fabs(roll) > 0)
        {
            if (roll < 0)
            {
                currentRollAngle += 1;
            }
            else
            {
                currentRollAngle -= 1;
            }
            currentRollAngle = constrain(currentRollAngle, MIN_ANGLE, MAX_ANGLE);
            rollServo.write(currentRollAngle);
            delay(10);
        }

        Serial.print(pitch);
        Serial.print(", ");
        Serial.println(roll);
        if (pitch == 0 && roll == -90)
        {
            Serial.println("MPU6050 error detected, reinitializing...");

            Wire.begin(21, 22); // Use the correct SDA, SCL pins for ESP32

            delay(100);
            mpu.begin();
        }
    }
}