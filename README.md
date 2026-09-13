# 🚚 Tanker – On-Demand Fuel & Water Logistics Platform

[![Firebase Realtime Database](https://img.shields.io/badge/Firebase-Realtime_DB-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Android](https://img.shields.io/badge/Android-Kotlin-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)
[![iOS](https://img.shields.io/badge/iOS-Swift-FA7343?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/swift/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-blue?style=for-the-badge)](https://developer.android.com/topic/architecture)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**Tanker** is a cross-platform, enterprise-grade logistics ecosystem designed for on-demand utility vehicle delivery services (Diesel/Fuel Tankers, Potable/Raw Water Tankers, and Specialized Service Vehicles).

The system consists of **4 distinct native applications** (2 for Android and 2 for iOS) split across **User** and **Admin/Provider** portals, synchronized through a low-latency **Firebase Realtime Database** backbone.

---

## 📱 Ecosystem Applications


```

```
                          ┌─────────────────────────────┐
                          │  Firebase Realtime Engine   │
                          └──────────────┬──────────────┘
                                         │
           ┌─────────────────────────────┴─────────────────────────────┐
           ▼                                                           ▼
 ┌──────────────────┐                                        ┌──────────────────┐
 │   USER SUITE     │                                        │   ADMIN SUITE    │
 ├──────────────────┤                                        ├──────────────────┤
 │  Android User    │                                        │  Android Admin   │
 │  iOS User        │                                        │  iOS Admin       │
 └──────────────────┘                                        └──────────────────┘

```

```

| Portal | Native Android | Native iOS | Core Target & Responsibility |
| :--- | :--- | :--- | :--- |
| **User Apps** | `tn user/` | `Tanker User iOS/` | Service booking, live location pin drop, real-time tracking, order status, order history. |
| **Admin Apps** | `tn admin android/` | `Tn Admin/` | Fleet dispatching, live order fulfillment, driver assignment, price configuration, user management. |

---

## 🚀 Key Features & Service Workflows

### 💧 On-Demand Service Categories
* **Diesel & Fuel Tankers:** Scheduled and emergency refueling deliveries for heavy machinery, private fleets, and generators.
* **Water Tankers:** Potable drinking water and non-potable utility water delivery for residential, commercial, or agricultural needs.
* **Car Service Units:** On-site maintenance and mobile washing unit bookings.

### ⚡ Core Functionality
* **Real-time Order Synchronization:** Sub-second status updates between User and Admin applications powered by Firebase web sockets.
* **Interactive Map Integration:** Precise GPS location picker and delivery destination pin-dropping.
* **Fulfillment Lifecycle Management:** Full state machine workflow (`Pending` ➔ `Assigned` ➔ `In Transit` ➔ `Delivered` ➔ `Completed` / `Cancelled`).
* **Admin Dispatch Hub:** Centralized control panel for administrators to accept incoming requests, assign available service trucks, and update operational pricing.
* **Push Notifications:** Instant event triggers when order status changes occur.

---

## 🛠️ Tech Stack & Architecture

### Backend & Infrastructure
* **Database:** Firebase Realtime Database (JSON-tree architecture with real-time listeners and security rules)
* **Authentication:** Firebase Auth (Phone / Email authentication)
* **Cloud Messaging:** Firebase Cloud Messaging (FCM) for push notifications

### Native Android (User & Admin Apps)
* **Language:** Kotlin 1.9+ / Java
* **Architecture:** MVVM (Model-View-ViewModel) + Clean Architecture
* **UI Framework:** Android Jetpack / Material Design Components
* **Asynchronous Execution:** Kotlin Coroutines & Flow
* **Services:** Google Maps SDK, FusedLocationProviderClient

### Native iOS (User & Admin Apps)
* **Language:** Swift 5.0+
* **Architecture:** MVVM / Delegate Pattern
* **UI Framework:** UIKit / Storyboards / SwiftUI
* **Services:** MapKit, CoreLocation

---

## 📂 Repository Structure

```text
tanker/
├── Tn Admin/               # Native iOS Admin Application
├── Tanker User iOS/        # Native iOS User Application
├── tn admin android/       # Native Android Admin Application
├── tn user/                # Native Android User Application
└── README.md

```

---

## ⚙️ Technical Highlights & System Engineering

1. **Dual-Platform Architecture:** Maintained visual and functional parity across both Android (Kotlin) and iOS (Swift) platforms while respecting platform-specific design guidelines (Material Design vs Human Interface Guidelines).
2. **Event-Driven Real-time State:** Replaced traditional REST polling with persistent WebSocket listeners (`ValueEventListener` on Android and `DatabaseHandle` on iOS) to achieve instant UI synchronization across all 4 apps.
3. **Decoupled Admin & Client Workflows:** Enforced strict separation of concerns between user-facing request flows and admin management portals, secured via Firebase Database Security Rules based on user roles.

---

## 🏃 Getting Started

### Prerequisites

1. **Android Setup:** Android Studio Jellyfish or newer, JDK 17+.
2. **iOS Setup:** macOS with Xcode 15+, CocoaPods / Swift Package Manager.
3. **Firebase Console:** A active Firebase Project with **Realtime Database** and **Authentication** enabled.

### Configuration

1. **Clone the repository:**
```bash
git clone [https://github.com/mo-abouelsaad/tanker.git](https://github.com/mo-abouelsaad/tanker.git)
cd tanker

```


2. **Add Firebase Credentials:**
* **Android Apps:** Download `google-services.json` from your Firebase Console and place it in both:
* `tn user/app/google-services.json`
* `tn admin android/app/google-services.json`


* **iOS Apps:** Download `GoogleService-Info.plist` and add it via Xcode to both:
* `Tn Admin/GoogleService-Info.plist`
* `Tanker User iOS/GoogleService-Info.plist`




3. **Build & Run:**
* **Android:** Open `tn user` or `tn admin android` in Android Studio, sync Gradle, and run.
* **iOS:** Open the respective `.xcworkspace` file in Xcode, resolve dependencies, and run on a simulator or device.



---

## 🤝 Author & Contact

**Mohamed Abouelsaad**

* GitHub: [@mo-abouelsaad](https://www.google.com/search?q=https://github.com/mo-abouelsaad)
* LinkedIn: [Connect on LinkedIn](https://www.google.com/search?q=https://www.linkedin.com/in/mo-abouelsaad/)

---

```

```
