<h1 align="center">🎬 GifFinder</h1>

<p align="center">
A lightweight iOS application for searching and exploring GIFs using the <b>Giphy API</b>.<br>
Built with <b>UIKit</b>, <b>Combine</b>, and <b>MVVM architecture</b>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-16.0%2B-blue" alt="iOS version">
  <img src="https://img.shields.io/badge/Swift-5.9-orange" alt="Swift">
  <img src="https://img.shields.io/badge/Architecture-MVVM-green" alt="Architecture">
  <img src="https://img.shields.io/badge/Dependencies-CocoaPods-red" alt="Dependencies">
</p>

---

## 🚀 Features

- 🔍 **Instant Search** — search GIFs with debounce delay after typing stops  
- 📜 **Infinite Scroll** — automatically loads more results as you scroll  
- 🖼️ **Grid Layout** — clean, adaptive grid (portrait + landscape support)  
- 💬 **Detail View** — tap a GIF to open a detailed screen with large preview  
- ⏳ **Loading Indicators** — main spinner + footer spinner for pagination  
- ⚠️ **Error Handling** — handles empty results, rate limits, and connection issues  
- 🧠 **Reactive Bindings** — powered by Combine for View ↔ ViewModel communication  

---

## 🏗️ Architecture

**Pattern:** `MVVM`  
**Frameworks:** `UIKit`, `Combine`, `Diffable Data Source`, `CocoaPods`

### 🧩 Key Components
| Component | Description |
|------------|-------------|
| `GifListViewController` | Displays search results in a UICollectionView |
| `GifViewModel` | Handles query, pagination, and Combine bindings |
| `NetworkManager` | Performs Giphy API requests and decodes JSON |
| `GifCell` | Custom UICollectionViewCell showing GIF previews |
| `DetailViewController` | Shows selected GIF with full-size image and title |

---

## 🔌 API Integration

**Powered by:** [Giphy Search API](https://developers.giphy.com/docs/api/)

#### 🔑 API Key Setup
1. Create a file `SecretAPI.xcconfig` in the project root  
2. Add:
   ```text
   API_KEY = your_api_key_here
