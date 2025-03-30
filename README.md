# 🎬 Movie App - Flutter Project

A feature-rich mobile application for discovering trending movies, top-rated films, and popular TV shows. Built with Flutter for cross-platform compatibility.

---

## 🎬 Overview
A beautifully designed Flutter app that helps you explore and favorite movies with ease. Experience smooth animations, intuitive navigation, and a feature-packed movie discovery platform.

---

## ✨ Key Features

### 🎥 Movie Discovery
- Browse **trending movies**, updated daily
- Explore **top-rated films** across various genres
- Discover **popular TV shows** with ease

### ❤️ Favorites System
- Save your favorite movies with a single tap
- Access all saved favorites in a dedicated section
- Instantly update heart icons when toggling favorites

### 🔍 Powerful Search
- Find movies and TV shows **quickly** with real-time results
- Search across all available content seamlessly

### 🖼️ Rich Media Experience
- **High-quality** movie posters and backdrops
- **Detailed movie information** including:
    - Ratings
    - Release dates
    - Plot summaries

### 🌟 Modern & Responsive UI
- **Follows Material Design 3** for a polished experience
- **Optimized for all screen sizes**, from small to large devices

---

## 🛠️ Technical Implementation

### **Frontend**
- **Built with Flutter** for cross-platform compatibility
- **Custom Animations** for smooth transitions
- **Responsive Design** ensuring great visuals on all devices

### **Backend Integration**
- **Movie API integration** for real-time data updates
- **Local storage** to persist favorite movies
- **Share functionality** using native device capabilities

### **State Management**
- **Efficient state handling** for favorites and search results
- **Optimistic UI updates** for seamless user experience

---

## 📱 Screens

1. **Home Screen** - Trending movies carousel
2. **Top Rated** - Highest-rated films
3. **TV Shows** - Popular television series
4. **Favorites** - Your saved content
5. **Search** - Find any movie or show
6. **Details** - Comprehensive movie info

---

## 🚀 Getting Started

### 📌 Prerequisites
- Install the latest **Flutter SDK**
- Ensure you have **Dart SDK** installed
- Use **Android Studio** or **VS Code** with the Flutter plugin

### 🔧 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/movie-app.git
   ```  
2. Navigate to the project folder:
   ```bash
   cd movie-app
   ```  
3. Install dependencies:
   ```bash
   flutter pub get
   ```  
4. Run the app:
   ```bash
   flutter run
   ```  

---

## 🔧 Configuration

Add your API keys to:
```
lib/utils/movie_service.dart
```

---

## 📚 Dependencies & Libraries

The app uses the following Flutter packages:
- `share_plus` - For sharing functionality
- `flutter_staggered_animations` - For beautiful animations
- `http` - For API calls
- `shared_preferences` – Store your favorite movies locally

Add them in `pubspec.yaml`:
```yaml
dependencies:
  flutter_staggered_animations: ^1.0.0
  shared_preferences: ^2.0.0
  share_plus: ^1.0.0
  http: ^1.0.0
```

---

## 🗂️ Project Structure

```
lib/
├── model/
│   ├── movie_model.dart
│
├── screens/
│   ├── favourites_list.dart
│   ├── home_screen_movie_list.dart
│   ├── movie_description.dart
│   ├── search_page.dart
│
├── utils/
│   ├── movie_service.dart
│   ├── text.dart
│
├── widgets/
│   ├── movie_card.dart
│   ├── toprated.dart
│   ├── trending.dart
│   ├── tv.dart
│
├── main.dart
```

---

## 🎨 Customization

Want to tweak the app? Here’s where to start:
- **Change Colors** → Modify in `main.dart`
- **Update Movie List** → Edit movie data in `movie_model.dart`
- **Customize App Bar** → Modify headers in different pages

## 🤝 Contributing

We welcome contributions! If you’d like to improve the app, feel free to **open an issue** or **submit a pull request**.

---

Happy Coding! 💙