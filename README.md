# HireWise - Flutter-based Service Provider App

HireWise is a mobile application developed using Flutter that connects service providers with clients. The app features a sleek user interface that allows clients to browse through categories, view worker profiles, and explore gig listings. All data is powered by Supabase, ensuring real-time updates and efficient data management.

## Key Features

- **Category Browsing**: Browse through different service categories with circular icons and images fetched from Supabase Storage.
- **Worker Listings**: Detailed gig cards displaying worker information, allowing clients to find the best service providers.
- **User Profiles**: Personalize the app experience with user-specific profiles and settings.
- **Supabase Integration**: Real-time data fetching and storage using Supabase, including authentication and file storage.
- **Responsive UI**: The app adapts seamlessly to different screen sizes, ensuring a smooth experience on any device.
- **Image Caching**: Images are efficiently loaded using the `cached_network_image` package, improving app performance.

## Technical Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL, Storage, Auth)
- **State Management**: Built-in Flutter state management
- **Image Handling**: `cached_network_image` package for caching images
- **UI Effects**: Shimmer loading animations for smooth UI transitions

## Installation

To run HireWise locally, follow the steps below:

### Prerequisites

- Install the latest stable version of **Flutter SDK**: [Flutter installation guide](https://flutter.dev/docs/get-started/install)
- Install **Dart SDK** (comes bundled with Flutter)
- Create a **Supabase account** at [Supabase](https://supabase.io/) and set up your backend project

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/hirewise.git
   cd hirewise
