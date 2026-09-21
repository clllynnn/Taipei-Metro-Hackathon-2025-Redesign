# Product Overview | Product Characteristics, Information Architecture, User Flows, and Technical Feasibility

This document introduces the Taipei Metro Go iteration developed with Codex after the competition. This version is no longer centered on showcasing every feature in the competition demo. Instead, it uses information architecture as the foundation for deciding what passengers should understand first, where each function belongs, and how different contexts can share one product structure.

For the competition background and design process, see [UX Process & Insights](UX_INSIGHTS.en.md). The competition Figma prototype is preserved as a reference for the original proposal and final demo.

## Product positioning

This iteration is not simply about integrating information. It helps passengers quickly understand their situation and make a choice within a short amount of time. It also provides emotional companionship that responds to the feelings of commuting through music, interaction, and mutual help. In addition, I designed an accessibility mode centered on voice navigation and simplified flows, as well as a tourist mode for a more convenient travel experience.

The main change in the latest version is its focus on information architecture and the presentation of information by priority:

- **Four priority layers**: P0 Real-time information, P1 Companionship and innovation, P2 Frequently used information, and P3 Conditional triggers.

These priority layers determine the order, density, and trigger conditions for information in the product. The five primary areas are explained in the interface and feature specification below.

## Product characteristics

### 1. Home supports the decision before guiding users into features

Home is not a collection of every function. It is the entry point for a travel decision. It first presents the current context, live status, frequent destinations, and a system-organized journey recommendation, then lets the passenger move into Map, Features, or MetroTogether.

### 2. P0–P3 present information according to timing and importance

- **P0 | Real-time information**: content that affects the travel decision immediately, such as the nearby station, destination prediction, inbound countdown, crowding, and service disruptions.
- **P1 | Companionship and innovation**: music, mutual help, community, and emotional support that passengers can choose while waiting or riding.
- **P2 | Frequently used information**: functions passengers revisit but do not need to see first every time they open the app, such as feature search, station services, and membership activities.
- **P3 | Conditional triggers**: functions that appear only in a particular context, after permission, or through an intentional action.

### 3. Different needs share one product skeleton

General, tourist, and accessibility contexts are not three separate apps. They are different information priorities and interaction supports within the same IA. This keeps navigation consistent while responding to different passenger situations.

### 4. MetroTogether is an optional companionship layer

MetroTogether provides Lucky Radio, music, lightweight interaction, mutual help, and emotional companionship. It does not block the main travel task; it offers another form of support during waiting or riding.

### 5. AI is a service layer, not a replacement for user decisions

AI can use behavior and location data to predict destinations, recommend routes, or provide voice and customer-service support. The passenger can still inspect the recommendation, manually change the origin or destination, or return to conventional interaction.

## Interface and feature specification

### Home | Travel decision entry point

Commuters use Home while walking or rushing to a train and need to understand the most important travel information with close to zero interaction.

#### Core content

- **AI journey card**: uses the time the user opens the app, current station, and frequent destination to provide contextual travel guidance.
- **Train arrival countdown**: shows the relevant train information and last-updated time for the current direction.
- **Crowding status**: provides the relevant crowding state after the intended direction is identified.
- **Service disruption**: presents delays, suspensions, or line changes as high-visibility status messages.
- **Frequent stations and destinations**: lets passengers switch to a familiar journey without re-entering everything.

#### Modes and conditional features

- General mode: prioritizes live journey information.
- Accessibility mode: provides high contrast, larger type, simplified flows, voice guidance, elevator support, and emergency assistance.
- Tourist mode: provides elevator and locker information, luggage support, and routes that avoid stairs or crowds.

### Map | Route and station decisions

Passengers enter Map when they need a route, transfer, or station facility. They can select a destination directly and receive the next information needed for the journey.

#### Core content

- An interactive map that supports pan, zoom, and GPS-based current location.
- Selecting a destination triggers route planning, transfer estimates, and an in-station information card.
- The station card has three tabs: Travel, Station, and Transfer.
- Car-position and exit recommendations based on the destination and the passenger’s current car position.
- Restrooms, escalators, elevators, and service desks organized by exit to reduce the cost of finding facilities.
- Bus, TRA, and high-speed rail transfer directions, including the most efficient exit for leaving the station.

### MetroTogether | Micro-companionship while waiting and riding

Passengers can choose music, lightweight interaction, or functional mutual help when they feel tired, anxious, or alone while waiting or riding.

#### Core content

- **Lucky Passenger Radio**: selects a passenger each day to request a song, supported by registration, a short description, and Metro Points.
- **Mutual help**: passengers on the same line at the same time can ask about routes, remind one another when to get off, or offer wheelchair assistance. Private messages are limited to passengers on the same train.
- **Casual chat communities**: time-limited spaces organized by line or shared interest. They are automatically archived or disappear for the user after exiting the station.

### Features | Functions and service entry point

Existing Taipei Metro functions do not need to be learned again. They are reorganized through clear categories, four dynamic shortcuts, and global search.

#### Core content

- Four dynamic shortcuts that change according to context.
- Global feature search for operations, station services, nearby life, membership, and points activities.
- Lower-frequency or complete functions stay in Features so Home is not overloaded.

### Account | Personal data and travel history

#### Context

Passengers enter Account when they need personal information, travel analytics, rewards, preferences, or security settings.

#### Core content

- Travel history, monthly or yearly trip counts, and frequent routes or stations.
- Frequent-rider rewards, Metro Points, redemption history, and points-store entry.
- Carbon-reduction estimates and green commuting badges.
- Profile, account security, notification, and personalized push settings.
- AI support, feedback, and secure logout.

## User flows

These flows are based on the latest IA and the current iOS and web prototypes. The competition Figma primarily presents the original concept and final demo; the current GitHub version focuses on inspecting navigation, information hierarchy, and a rapid MVP.

### Flow 1 | Get a journey recommendation from Home

1. Open Home.
2. Review the current context, nearby station, destination, arrival countdown, and crowding.
3. Read the journey recommendation and last-updated time.
4. Move into Map, Features, or MetroTogether depending on the need.
5. Manually adjust the origin, destination, route, or mode when the recommendation does not fit.

### Flow 2 | Plan a route and inspect a station from Map

1. Open Map from a Home shortcut or the primary navigation.
2. Select a destination or set an origin and destination.
3. Review routes, transfers, estimated time, and journey conditions.
4. Open the station card to inspect facilities, exits, and transfer support.
5. Choose a route based on time, convenience, crowding, and personal needs.

### Flow 3 | Find companionship or mutual help in MetroTogether

1. Open MetroTogether from the primary navigation.
2. Choose Lucky Radio, song requests, casual chat, or mutual help.
3. Open song-request registration, choose a song, and fill in the meaning the song conveys for the current journey.
4. Register once per day to participate in the daily draw.
5. If selected, play the winning animation and receive the corresponding reward.
6. Participate when useful; all interactions remain separate from the main journey flow.
7. Return to Home or Map.

### Flow 4 | Find an existing function through Features

1. Open Features.
2. Use one of the four AI-recommended dynamic shortcuts or search by keyword.
3. Browse operations, station services, nearby life, membership, and points activities.
4. Keep a frequently used function available as a faster entry point later.

### Flow 5 | Manage personal information in Account

1. Open Account.
2. Review travel history, rewards, points, and carbon-reduction data.
3. Manage travel preferences, notifications, account security, and personal data.
4. Adjust settings so future journey recommendations better reflect the passenger’s needs.

## Prototype and production boundary

| Area | Current prototype | What production would require |
| --- | --- | --- |
| IA and navigation | Five primary areas are established: Home, Map, MetroTogether, Features, and Account. | Tree testing, first-click testing, and task testing to validate comprehension. |
| Live journey information | Contextual screens, states, and interaction flows communicate the experience. | Official metro APIs, live schedules, station facilities, and service status. |
| Widget | Countdown, crowding, color states, and minimal information are defined. | Android and iOS refresh limits, background execution rules, and power usage. |
| AI recommendations | Prediction and recommendation are represented in the Home flow. | Data-quality rules, recommendation evaluation, error handling, and manual fallback. |
| Location and personalization | Contextual recommendations are represented. | Consent, permission handling, retention rules, and data minimization. |
| MetroTogether | Music, companionship, mutual help, and short-lived communities are represented. | Reporting, blocking, content moderation, and user-safety mechanisms. |
| Accessibility | Modes, voice, elevator, and emergency support are part of the structure. | VoiceOver, Dynamic Type, color contrast, and real-user validation. |

## Technical feasibility

### Implemented product layer

- **iOS prototype**: SwiftUI screens, navigation, and interaction states corresponding to Home, Map, MetroTogether, Features, and Account.
- **Web prototype**: static HTML, CSS, and JavaScript for an installable concept version.
- **IA-to-code mapping**: the product layer uses Home, Map, MetroTogether, Features, and Account; the SwiftUI repository modules are implemented as `HomeView`, `RouteMapView`, `MetroRadioView`, `ServiceMenuView`, and `AccountView`.
- **Codex iteration**: rapidly converting IA assumptions into inspectable iOS and web versions, then iterating on navigation, naming, and information priority.

### Competition AI and cloud architecture

```text
User behavior and location data
             ↓
Firebase / Firestore
             ↓
AWS Lambda
    ├── Dynamic location and route planning
    ├── UI recommendations
    ├── Station prediction
    └── AI support flow
             ↓
AWS Bedrock LLM
             ↓
Journey recommendations, station prediction, and AI conversation
```

The AI architecture was mainly developed by teammates. My product-level focus was how AI recommendations entered Home and the other primary areas, whether passengers could understand the recommendation, and whether they could return to manual operation.

Technical overview: [AI technical overview](https://www.canva.com/design/DAGw1sl83c4/K83wtoP41e_NU1fRmC4lpg/view?utm_content=DAGw1sl83c4&utm_campaign=designshare&utm_medium=link&utm_source=viewer)

### Feasibility risks and product responses

| Technical or product risk | Product response |
| --- | --- |
| An AI recommendation may be inaccurate. | Explain recommendation factors and preserve manual adjustment and conventional route planning. |
| Location and behavior data create privacy concerns. | Request consent, provide permission and data controls, and avoid making personalization mandatory. |
| Real-time data may be delayed or missing. | Show data status and timestamps, and provide a flow that does not depend on AI. |
| LLM responses may be inconsistent. | Constrain high-risk tasks and keep essential transit information grounded in structured data. |
| Social interaction may create safety issues. | Add reporting, blocking, moderation, and clear safety boundaries to MetroTogether. |

## Project links

- [UX Process & Insights](UX_INSIGHTS.en.md): research, design thinking, product structure, and AI-assisted iteration.
- [Competition Figma final-demo prototype](https://www.figma.com/proto/467ZwEnIUOrVpREiduKbd5/%E8%A6%81%E4%B8%8D%E8%A6%81%E6%90%AD%E6%8D%B7%E9%81%8B?node-id=1-2&t=4C8RnnGyL7Vt3QZN-1)
