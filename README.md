# MapZin

MapZin is an innovative indoor and outdoor navigation app developed as the final project for my software engineering degree, for which I received a grade of 100. Leveraging advanced technologies such as LiDAR, augmented reality (AR), and QR code scanning, MapZin delivers seamless navigation in complex environments.

[View the Design Presentation](https://www.canva.com/design/DAGQJYVVxpg/ESLgJiLuLE5WfVamIVDJoQ/view?utm_content=DAGQJYVVxpg&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=he786a555e1)

[View the Design Presentation](https://www.canva.com/design/DAGQJYVVxpg/ESLgJiLuLE5WfVamIVDJoQ/view?utm_content=DAGQJYVVxpg&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=he786a555e1)

<div style="position: relative; width: 100%; height: 0; padding-top: 56.2500%; padding-bottom: 0; box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); margin-top: 1.6em; margin-bottom: 0.9em; overflow: hidden; border-radius: 8px; will-change: transform;">
  <iframe loading="lazy" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0; border: none; padding: 0; margin: 0;"
    src="https://www.canva.com/design/DAGQJYVVxpg/gjby7IlRCWUvnLJVFE3oWw/view?embed" allowfullscreen="allowfullscreen" allow="fullscreen">
  </iframe>
</div>
<a href="https://www.canva.com/design/DAGQJYVVxpg/gjby7IlRCWUvnLJVFE3oWw/view?utm_content=DAGQJYVVxpg&amp;utm_campaign=designshare&amp;utm_medium=embeds&amp;utm_source=link" target="_blank" rel="noopener">MapZin</a>  

Let me know if you'd like to integrate this directly into your Markdown file or adjust further.

## Documentation
For detailed project documentation, including design decisions and technical specifications, refer to the [MapZin Design Document](https://docs.google.com/document/d/1cAqzi_OsJIlCIW4Adzp5h8gm62EZpwC-UGmul_WBvV8/edit?tab=t.0).

## Features
- **LiDAR-Enhanced Floor Mapping**: Create accurate indoor maps using LiDAR scans.
- **Augmented Reality Navigation**: Combine AR with QR codes and smartphone sensors for precise user positioning.
- **Seamless Indoor-Outdoor Navigation**: Transition smoothly between indoor and outdoor environments.
- **Efficient Pathfinding**: Utilize the A* algorithm for optimal route calculations.
- **Modern Architecture**: Built with SwiftUI and following the MVVM-C architecture for maintainability and scalability.

## Technologies Used
- **SwiftUI**: For building a modern, declarative user interface.
- **ARKit**: To power AR-based navigation and object detection.
- **LiDAR Scanning**: For creating precise indoor maps.
- **MongoDB**: Backend database for managing map and user data.
- **Node.js with TypeScript**: Server-side logic, including the A* algorithm for pathfinding.

## How It Works
1. **Initial Setup**: Users scan a QR code to establish their starting position.
2. **Navigation System**: AR and Inertial Navigation Sensors (INS) guide users along the optimal path to their destination.
3. **Dynamic Updates**: The app recalculates routes in real-time to handle deviations or changes in the environment.
4. **End-to-End Integration**: Combines outdoor GPS navigation with indoor AR-based systems for a seamless experience.


## Installation
To clone and run the app locally, you’ll need:
1. An iOS device with ARKit support (iOS 15 or later recommended).
2. Xcode installed on macOS.
3. Access to a developer account to run the app on a physical device.

```bash
# Clone the repository
git clone https://github.com/malamud3/Mapzin2.git

# Navigate to the project directory
cd Mapzin2

# Open the project in Xcode
open MapZin.xcodeproj
