
# MovieFlix

MovieFlix is an intuitive iOS app that allows users to browse popular movies, view detailed information, and manage their own list of favorite movies.

## The Goal:

This project was developed independently from scratch, as part of a self-guided learning experience. The objective and the challenge was to complete the MVP version within 2 weeks (divided into 2 sprints) — and this is the result.

## Features:

- Browse popular movies
- Search for movies by title
- Add and remove movies from your favorites list
- View detailed information about each movie, including:
  - Poster
  - Synopsis
  - Rating
  - Release date
  - And more

## Technology used:

- **Swift** (UIKit)
- **Clean** architecture
- **UserDefaults** for local persistence (Movies IDs)
- **The Movie Database (TMDB) API** for movie data
- **Kingfisher** for image downloading and caching
- **SnapKit** for UI layout
- **Lovable** used to create and guide the UI/UX design

## How It Works:

- The **Home screen** displays a list of popular movies from the TMDB API.
- The **Search bar** allows users to search for movies by title.
- The **Favorites screen** shows movies the user has saved locally.
- Poster images are displayed using `Kingfisher` with placeholder handling if a movie has no poster.
- Smooth transitions and fade-ins for a polished UI experience.

## Project Structure

```
MovieFlix/
├── Features/
│    ├── Details/
│    ├── Favorites/
│    └── Home/
|         ├── Data/
|         |     └── HomeDataSource.swift
|         ├── Domain/
|         |     ├── HomeEntity.swift
|         |     └── HomeViewModel.swift
|         └── Presentation/
|               ├── HomeView.swift
|               └── HomeViewController.swift
└── Core/
      ├── DesignSystem/
      ├── Extensions/
      |        └── UIColor.swift
      ├── Infrastructure/
      |        └── Network/
      |              └── TokenManager.swift
      └── Persistence/
               └── AppDefaults.swift
```

## Future Improvements:

Due to the limited timeframe, some decisions were made based on priority, and certain aspects were simplified or postponed in order to meet the deadline.

- Save favorites Movies to CoreData instead of UserDefaults
- Allow filtering by genre or year
- Add localization support
- Unit and UI testing
- Create a `BaseAPI` class to simplify and replicate API requests.
- Add error enumeration for better error management and debugging.
- Improve error handling and user feedback.
- Implement push/local notifications.
- Reduce the number of hardcoded strings by using centralized `Constants`.

## Author:

Developed by Ingrid von Baranow  
[LinkedIn](https://www.linkedin.com/in/ingrid-von-baranow-178965350/)  
[GitHub](https://github.com/ingridbaranow)
