# DevSpace – GitHub Profile Analytics Dashboard

DevSpace is a production-ready Flutter application designed to analyze and visualize public GitHub developer profiles. By interacting with the GitHub REST API, the application transforms raw JSON metrics into beautiful, interactive analytics dashboards, language distribution charts, and side-by-side user comparison modules.

## Key Features

* **Search & Profile Analytics:** Instantly parses user profiles to map structural metrics including total followers, following count, public repositories, and bio details into a clean interface.
* **Language Distribution Visualization:** Computes programming language usage across all public repositories and renders an interactive graphical breakdown.
* **Top Repositories Engine:** Dynamically filters and highlights the user's top 10 repositories based on stargazers count and fork metrics.
* **Dynamic Dark Mode:** Includes a complete light and dark theme architecture with a smooth transitions mechanism that retains user preferences across application restarts.
* **Shimmer Skeleton Loading:** Replaces traditional loading spinners with high-fidelity, structure-aware gray shimmering placeholders to drastically improve User Experience (UX).
* **Persistent Search History:** Retains a cache of recently viewed profiles, displaying them as interactive, clickable structural chips under the search query component.
* **Horizontal User Comparison:** Features a dedicated analytical model to contrast two developer profiles simultaneously, placing their respective language breakdowns side-by-side for precise comparison.

## Architecture & Technical Stack

* **UI Framework:** Flutter & Dart for cross-platform rendering, smooth widget lifecycle management, and clean view layouts.
* **Networking Layer:** HTTP client utility classes optimized for REST API parsing, status code evaluation, and rate-limit handling.
* **Data Visualization:** Built-in charting modules leveraging vector graphs (`fl_chart`) to build clean, proportional language distribution charts.
* **Local Caching Layer:** Persistent Key-Value system (`shared_preferences`) utilized for managing synchronous user configuration states (theme selection) and local historical strings data.
* **Asynchronous Animation UI:** Shimmer masking patterns used to handle async network states gracefully before data hydration.
* **Typography & Design:** Integrated professional design tokens (`google_fonts`) ensuring high scannability and uniform appearance across all target platforms.

## Core API Integration

The application operates seamlessly by consuming unauthenticated GitHub public endpoints:
* **User Profile Hydration:** Maps global user metadata via `https://api.github.com/users/{username}`
* **Repository Processing:** Evaluates repository metadata, parent language streams, and engagement statistics via `https://api.github.com/users/{username}/repos`

## License

Distributed under the MIT License. Open for modification, scaling, and educational distributions.
