# 🎬 PremierMovies

**PremierMovies** is a modern iOS application built with **SwiftUI**, following a clean and scalable **MVVM architecture**. It enables users to explore and browse top-rated movies with a smooth, dynamic UI and modular design. The app emphasizes testability, caching efficiency, and responsiveness across both light and dark modes.

---

## 🧠 Architecture

- **MVVM Pattern**: Clear separation between `Models`, `ViewModels`, and `Views` for modularity and unit testing.
- **SwiftUI + @StateObject / @ObservedObject**: Reactive UI powered by observable state containers.
- **Component-Based Design**: UI broken down into reusable views and view models.

---

## 💾 Caching

- **Custom In-Memory Caching Layer** in `APIService`:
  - Smart caching policy using `CachePolicy.useCacheIfAvailable` and TTL.
  - Greatly reduces redundant network calls for genres and movie details.
  - Pluggable via `CacheProtocol` for future extensibility.

---

## 🔍 Search Functionality

- **Live Movie Search by Title, Genre, and Overview**:
  - Uses `@Published` and `debounce` for smooth, non-blocking input handling.
  - Results update instantly based on user input with no UI lag.

---

## 🔄 View States

- **State-Driven UI**: Each screen reacts to loading, success, and error states via enums like `ViewState`.
- **Custom Error and Loading Views**:
  - Centralized components for `ProgressView`, empty states, and retry handlers.

---

## 🧩 Modularity

- **Networking Layer**:
  - Built around a generic `Request<Value>` abstraction.
  - Easily extendable with endpoints like `Movie.topRated`, `Movie.similar(for:)`, `Genres.genresRequest()`.

- **Cache Layer**:
  - Implements TTL-based in-memory caching with pluggable storage.

- **Separation of Features**:
  - Movie list, details view, and similar movies handled in their own view models and components.

---

## 🧰 Development Features

- **Mock Data Support**:
  - Simplified previewing and unit testing via hardcoded movie mocks.
- **Testable API Layer**:
  - Built to work with dependency injection (e.g., `APIServiceProtocol`) and fully testable.

---

## 🚀 Getting Started

```bash
git clone https://github.com/capitan112/PremierMovies.git
cd PremierMovies
open PremierMovies.xcodeproj
