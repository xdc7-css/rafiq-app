# Rafeeq (رَفِيقْ) — Qibla Compass Architecture

> **Function**: Real-time Kaaba Direction Pointer  
> **Target Sacred Point**: Kaaba, Mecca (Latitude: $21.4225^\circ\text{ N}$, Longitude: $39.8262^\circ\text{ E}$)  
> **Core Libraries**: `flutter_qiblah: ^3.2.0`, `geolocator: ^14.0.2`, `permission_handler: ^11.3.1`  

---

## 1. Mathematical Bearing Calculation

The direction of the Qibla from any geographic coordinate $(\phi_1, \lambda_1)$ to Mecca $(\phi_2, \lambda_2)$ is determined using the Great Circle navigation formula:

$$\theta = \text{atan2}\Big(\sin(\Delta\lambda) \cdot \cos(\phi_2), \cos(\phi_1) \cdot \sin(\phi_2) - \sin(\phi_1) \cdot \cos(\phi_2) \cdot \cos(\Delta\lambda)\Big)$$

Where:
- $\phi_1, \lambda_1$ = User's current latitude and longitude in radians.
- $\phi_2, \lambda_2$ = Mecca's coordinates ($21.4225^\circ, 39.8262^\circ$) in radians.
- $\Delta\lambda = \lambda_2 - \lambda_1$.
- $\theta$ = Qibla azimuth relative to True North.

---

## 2. Sensor Fusion & Stream Pipeline

```
┌───────────────────────────────┐     ┌───────────────────────────────┐
│     Device Magnetometer       │     │     Device Accelerometer      │
│   (Measures Magnetic Field)   │     │    (Measures Gravity Tilt)    │
└──────────────┬────────────────┘     └──────────────┬────────────────┘
               │                                     │
               └──────────────────┬──────────────────┘
                                  │ Raw Sensor Fusion
                                  ▼
               ┌─────────────────────────────────────┐
               │    flutter_qiblah Sensor Stream     │
               │   - Compensates for tilt angle      │
               │   - Filters high-frequency jitter   │
               └──────────────────┬──────────────────┘
                                  │
                                  ▼
               ┌─────────────────────────────────────┐
               │    QiblaProvider (Riverpod)         │
               │  Combines compass heading with GPS  │
               │  Kaaba offset calculation           │
               └──────────────────┬──────────────────┘
                                  │
                                  ▼
               ┌─────────────────────────────────────┐
               │    QiblaScreen UI Presentation      │
               │  - Animated compass dial rotation   │
               │  - Gold pointer towards Kaaba       │
               │  - Haptic feedback when aligned     │
               └─────────────────────────────────────┘
```

---

## 3. Sensor Calibration & Degradation Modes

1. **Uncalibrated Sensor**: If sensor accuracy returns low, a prompt advises the user to move the device in a figure-8 motion to recalibrate the magnetometer.
2. **Missing Sensor (Tablets / Laptops / Web)**: When run on hardware without a magnetic compass sensor, Rafeeq gracefully catches the missing sensor exception and renders a static map view indicating the bearing in degrees.
3. **Location Permission Denied**: If GPS is unavailable, the user can select their city manually from settings, computing the static Qibla azimuth without real-time GPS queries.
