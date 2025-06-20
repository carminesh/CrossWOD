# 🏋️‍♂️ CrossWOD

**CrossWOD** is a multimodal iOS and watchOS application designed to enhance **CrossFit** and high-intensity workouts through customizable timers, intuitive interaction modes (touch, voice, wearable), and synchronized experiences across devices. Built in SwiftUI with an MVVM architecture, CrossWOD is your next-gen fitness companion.

---

## 📱 Features

- ⏱ **Workout Modes**: AMRAP, EMOM, For Time, Tabata — fully customizable.
- 🗣 **Voice Control**: Hands-free commands with `SFSpeechRecognizer`.
- ⌚️ **Apple Watch Integration**: Sync and control workouts seamlessly via `WatchConnectivity`.
- 📊 **Workout History**: Track all completed sessions with CoreData.
- 🎨 **Rive Animations**: Dynamic, responsive visual feedback throughout the workout.

---

## 🧱 Architecture

CrossWOD follows the **MVVM** pattern with SwiftUI:

- **Model**: Workout structures, persistence (CoreData), parameters
- **ViewModel**: Business logic, UI state, input validation
- **View**: Reactive UI in SwiftUI, animations, controls

The Apple Watch app mirrors this architecture with optimized ViewModels for performance and real-time synchronization.

---

## 🎮 Interaction Modes

| Mode         | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| Touch        | Navigate workouts, set parameters, browse history                          |
| Voice        | Use natural language to `start`, `pause`, `resume` workouts hands-free      |
| Wearable     | Control workouts via Apple Watch with haptic feedback and real-time sync    |

---

## 🧩 Technologies

- SwiftUI
- MVVM Design Pattern
- CoreData (Persistence)
- WatchConnectivity
- SFSpeechRecognizer (Voice control)
- Rive (Animations)

---

## 🚀 Getting Started

### Requirements

- Xcode 15+
- iOS 17+ / watchOS 10+
- Swift 5.9+
- Apple Watch Series 4 or newer (recommended)

