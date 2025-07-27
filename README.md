#  AdNabbit - Digital Screen Advertising Platform

**AdNabbit** is a comprehensive digital advertising management platform designed to streamline the process of creating, deploying, and monitoring advertisements across digital screens and displays.

##  Live Demo

**Try AdNabbit now:** [https://LEED337.github.io/adnabbit/](https://LEED337.github.io/adnabbit/)

##  Features

###  Core Functionality
- **Professional Dashboard** - Clean, intuitive interface for managing campaigns
- **Location Browser** - Discover and select digital screens for advertising
- **Ad Management** - Create, edit, and deploy advertisements
- **Campaign Tracking** - Monitor performance and analytics
- **Subscription Management** - Handle billing and plan management

###  Technical Features
- **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- **Modern UI/UX** - Professional interface with smooth animations
- **Real-time Updates** - Live status monitoring and notifications
- **Cross-platform** - Built with Flutter for web, iOS, and Android

###  User Experience
- **Intuitive Navigation** - Sidebar navigation with clear sections
- **Professional Branding** - Consistent design language throughout
- **Demo Mode** - Easy testing without account setup
- **Fast Performance** - Optimized for quick loading and smooth interactions

##  Technology Stack

- **Framework:** Flutter 3.16+
- **Language:** Dart
- **Platform:** Web (with mobile support)
- **State Management:** Provider
- **HTTP Client:** Dio
- **UI Components:** Material Design 3
- **Deployment:** GitHub Pages

##  Screenshots

### Login Screen
Professional login interface with AdNabbit branding and demo access.

### Dashboard
Clean dashboard with sidebar navigation and overview metrics.

### Locations Browser
Browse and select from available digital screen locations.

### Ad Management
Create and manage advertising campaigns with intuitive tools.

##  Getting Started

### Prerequisites
- Flutter SDK 3.16 or higher
- Dart SDK 3.0 or higher
- Web browser (Chrome recommended)

### Installation

1. **Clone the repository:**
   `ash
   git clone https://github.com/LEED337/adnabbit.git
   cd adnabbit
   `

2. **Install dependencies:**
   `ash
   flutter pub get
   `

3. **Run the application:**
   `ash
   flutter run -d chrome
   `

### Building for Production

`ash
# Build for web
flutter build web --release

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
`

##  Deployment

The project is configured for automatic deployment to GitHub Pages:

1. **Enable GitHub Pages** in repository settings
2. **Select GitHub Actions** as the source
3. **Push to master branch** triggers automatic deployment
4. **Access live app** at https://LEED337.github.io/adnabbit/

##  Project Structure

`
lib/
 main.dart              # App entry point and main screens
 models/               # Data models (future expansion)
 services/             # API services (future expansion)
 widgets/              # Reusable UI components (future expansion)
 utils/                # Utility functions (future expansion)
`

##  Future Enhancements

### Phase 1: OptiSigns Integration
- **Real API Integration** - Connect to OptiSigns digital signage platform
- **Live Screen Management** - Real-time screen status and control
- **Content Deployment** - Direct ad deployment to physical screens

### Phase 2: Advanced Features
- **Analytics Dashboard** - Comprehensive performance metrics
- **A/B Testing** - Campaign optimization tools
- **Automated Scheduling** - Smart campaign scheduling
- **Multi-user Support** - Team collaboration features

### Phase 3: Enterprise Features
- **White-label Solution** - Customizable branding
- **API Access** - Third-party integrations
- **Advanced Reporting** - Custom report generation
- **Enterprise Security** - SSO and advanced permissions

##  Contributing

We welcome contributions to AdNabbit! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (git checkout -b feature/amazing-feature)
3. **Commit your changes** (git commit -m 'Add amazing feature')
4. **Push to the branch** (git push origin feature/amazing-feature)
5. **Open a Pull Request**

### Development Guidelines
- Follow Flutter/Dart best practices
- Write clear, commented code
- Test your changes thoroughly
- Update documentation as needed

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

##  Support

- **Issues:** [GitHub Issues](https://github.com/LEED337/adnabbit/issues)
- **Documentation:** [Project Wiki](https://github.com/LEED337/adnabbit/wiki)
- **Discussions:** [GitHub Discussions](https://github.com/LEED337/adnabbit/discussions)

##  Acknowledgments

- **Flutter Team** - For the amazing framework
- **Material Design** - For the design system
- **GitHub Pages** - For free hosting
- **OptiSigns** - For digital signage platform inspiration

---

**Built with  using Flutter**

*AdNabbit - Simplifying digital advertising, one screen at a time.*
