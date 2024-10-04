<p align="center">
  <img src="logo/readme_logo.jpg" width="60%" alt="BLUETOOTH_MESSAGING_PROJECT-logo">
</p>
<p align="center">
    <h1 align="center">Bluetooth Messaging Project</h1>
</p>
<p align="center">
	<img src="https://img.shields.io/github/license/melihcelik09/bluetooth_messaging_project?style=flat&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
	<img src="https://img.shields.io/github/last-commit/melihcelik09/bluetooth_messaging_project?style=flat&logo=git&logoColor=white&color=0080ff" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/melihcelik09/bluetooth_messaging_project?style=flat&color=0080ff" alt="repo-top-language">
</p>
<p align="center">
		<em>Built with the tools and technologies:</em>
</p>
<p align="center">
	<img src="https://img.shields.io/badge/Dart-0175C2.svg?style=flat&logo=Dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/Flutter-0175C2.svg?style=flat&logo=Flutter&logoColor=white" alt="Flutter">
</p>

<br>

##### 🔗 Table of Contents

- [📍 Overview](#-overview)
- [👾 Features](#-features)
- [📂 Repository Structure](#-repository-structure)
- [🚀 Getting Started](#-getting-started)
  - [📦 Installation](#-installation)
  - [🤖 Usage](#-usage)
- [🤝 Contributing](#-contributing)
- [🎗 License](#-license)

---

## 📍 Overview

The Bluetooth Messaging App is a Flutter-based application for real-time messaging over Bluetooth. It features text and voice interactions, device management, and sound playback. The app is built with a modular structure for easy scalability, offering a seamless user experience with custom widgets and smooth navigation.

---

## 👾 Features

Here are the key features based on your file structure that you can list under a "features" section:

### 1. **Messaging System**

- **Chat View**: Handles the chat interface, including message display and user interactions.
- **Chat Bubble**: Custom widget for displaying chat messages.
- **Chat Input**: A card interface for sending messages.
- **Sound Features**: Includes recording and playing sound functionality (`record_sound.dart`, `play_sound.dart`).
- **Noises**: Custom widget for managing noise-related functionality in chat.
- **Chat Type**: Enum for differentiating between chat types.

### 2. **Device Management**

- **Device List View**: Displays a list of connected devices, possibly for Bluetooth pairing or communication.
- **Device Type Enum**: Defines the types of devices that can connect or interact with the app.

### 3. **Home View**

- **Home Screen**: Main view for navigating to different sections of the app.

### 4. **Core Functionality**

- **Message Model**: Defines the structure of a message within the app.
- **Common Widgets**: Shared components like `common_text_form_field.dart` for reusable UI elements.
- **Message Type Enum**: Differentiates between types of messages (e.g., text, sound).

### 5. **Extensions and Utilities**

- **Duration Extension**: Extends functionality related to time durations, likely for handling time in chat or audio features.

### 6. **Navigation**

- **App Router**: Handles navigation between different views of the app.
- **Auto-Generated Router**: Likely includes routes for different app sections.

Let me know if you'd like to expand or adjust any of these points!

---

## 📂 Repository Structure

```
└── 📁lib
    └── 📁app
        └── 📁views
            └── 📁chat
                └── 📁mixin
                    └── chat_view_mixin.dart
                └── 📁view
                    └── 📁widgets
                        └── chat_bubble.dart
                        └── chat_input_card.dart
                        └── noises.dart
                        └── play_sound.dart
                        └── record_sound.dart
                    └── chat_view.dart
            └── 📁device_list
                └── 📁view
                    └── device_list_view.dart
            └── 📁home
                └── 📁view
                    └── home_view.dart
        └── bluetooth_messaging_app.dart
    └── 📁core
        └── 📁common
            └── 📁models
                └── message_model.dart
            └── common_text_form_field.dart
        └── 📁enum
            └── chat_type.dart
            └── device_type.dart
            └── message_type.dart
        └── 📁extension
            └── duration_extension.dart
        └── 📁navigation
            └── app_router.dart
            └── app_router.gr.dart
    └── main.dart
```

---

## 🚀 Getting Started

### 📦 Installation

Build the project from source:

1. Clone the bluetooth_messaging_project repository:

```sh
❯ git clone https://github.com/melihcelik09/bluetooth_messaging_project
```

2. Navigate to the project directory:

```sh
❯ cd bluetooth_messaging_project
```

3. Install the required dependencies:

```sh
❯ pub get
```

### 🤖 Usage

To run the project, execute the following command:

```sh
❯ flutter run main.dart
```

## 🤝 Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/melihcelik09/bluetooth_messaging_project/issues)**: Submit bugs found or log feature requests for the `bluetooth_messaging_project` project.
- **[Submit Pull Requests](https://github.com/melihcelik09/bluetooth_messaging_project/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/melihcelik09/bluetooth_messaging_project/discussions)**: Share your insights, provide feedback, or ask questions.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/melihcelik09/bluetooth_messaging_project
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="left">
   <a href="https://github.com{/melihcelik09/bluetooth_messaging_project/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=melihcelik09/bluetooth_messaging_project">
   </a>
</p>
</details>

---

## 🎗 License

This project is protected under the [MIT License](https://github.com/melihcelik09/bluetooth_messaging_project/blob/main/LICENSE) License. For more details, refer to the [LICENSE](https://github.com/melihcelik09/bluetooth_messaging_project/blob/main/LICENSE) file.

---
