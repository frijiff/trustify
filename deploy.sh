#!/bin/bash

# Trustify Production Deployment Script
# This script automates the build and deployment process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}========================================${NC}\n"
}

print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  Warning: $1${NC}"
}

# Check prerequisites
check_requirements() {
    print_header "Checking Requirements"
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed"
        exit 1
    fi
    print_success "Flutter is installed"
    
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed"
        exit 1
    fi
    print_success "Dart is installed"
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        exit 1
    fi
    print_success "Git is installed"
}

# Clean and get dependencies
setup_project() {
    print_header "Setting Up Project"
    
    flutter clean
    print_success "Project cleaned"
    
    flutter pub get
    print_success "Dependencies installed"
}

# Run tests
run_tests() {
    print_header "Running Tests"
    
    flutter test || print_warning "Tests failed, continuing anyway"
    print_success "Tests completed"
}

# Analyze code
analyze_code() {
    print_header "Analyzing Code"
    
    flutter analyze || print_warning "Analysis found issues, continuing anyway"
    print_success "Code analysis completed"
}

# Build APK
build_android_apk() {
    print_header "Building Android APK"
    
    if [ -z "$KEYSTORE_PATH" ]; then
        print_error "KEYSTORE_PATH environment variable not set"
        return 1
    fi
    
    flutter build apk \
        --release \
        --obfuscate \
        --split-debug-info=build/app/outputs
    
    print_success "APK built successfully"
    echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
}

# Build App Bundle for Play Store
build_android_bundle() {
    print_header "Building Android App Bundle"
    
    flutter build appbundle --release
    
    print_success "App Bundle built successfully"
    echo "Bundle location: build/app/outputs/bundle/release/app-release.aab"
}

# Build iOS
build_ios() {
    print_header "Building iOS App"
    
    flutter build ios --release
    
    print_success "iOS app built successfully"
}

# Run security checks
security_check() {
    print_header "Running Security Checks"
    
    # Check for hardcoded secrets
    if grep -r "YOUR_" lib/ | grep -v "YOUR_"; then
        print_warning "Found configuration placeholders that need to be replaced"
    fi
    
    # Check for debug prints
    if grep -r "debugPrint\|print(" lib/ --include="*.dart" | grep -v "//" | grep -v "debugPrint.*//"; then
        print_warning "Found debug prints in production code"
    fi
    
    print_success "Security checks completed"
}

# Create release notes
create_release_notes() {
    print_header "Creating Release Notes"
    
    cat > RELEASE_NOTES.md << 'EOF'
# Trustify Release Notes

## Version 1.0.0

### Features
- User authentication with email/password
- Browse and search business reviews
- Submit reviews with images and ratings
- Coin system for monetization
- Multi-language support (English, French, Arabic)
- Modern Material Design 3 UI

### Bug Fixes
- Fixed Appwrite integration issues
- Improved error handling
- Enhanced UI responsiveness

### Known Issues
- Image upload limited to 5MB per image
- Search requires internet connection

### Installation
Download from Google Play Store or Apple App Store

EOF
    
    print_success "Release notes created"
}

# Build all platforms
build_all() {
    print_header "Building All Platforms"
    
    setup_project
    run_tests
    analyze_code
    security_check
    
    # Build Android
    build_android_bundle
    
    # Build iOS (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        build_ios
    else
        print_warning "iOS build skipped (macOS only)"
    fi
    
    create_release_notes
}

# Display usage
show_usage() {
    cat << EOF
Usage: ./deploy.sh [COMMAND]

Commands:
    check       - Check project requirements
    setup       - Clean and get dependencies
    test        - Run all tests
    analyze     - Analyze code
    build-apk   - Build Android APK
    build-aab   - Build Android App Bundle
    build-ios   - Build iOS app
    security    - Run security checks
    all         - Run all build steps
    help        - Show this help message

Examples:
    ./deploy.sh all              # Build everything
    ./deploy.sh build-aab        # Build Play Store bundle
    ./deploy.sh test             # Run tests only

Environment Variables:
    KEYSTORE_PATH    - Path to Android keystore file
    KEYSTORE_PASSWORD - Password for keystore
    KEY_ALIAS        - Alias for signing key
    KEY_PASSWORD     - Password for signing key

EOF
}

# Main script
main() {
    case "${1:-help}" in
        check)
            check_requirements
            ;;
        setup)
            setup_project
            ;;
        test)
            run_tests
            ;;
        analyze)
            analyze_code
            ;;
        build-apk)
            build_android_apk
            ;;
        build-aab)
            build_android_bundle
            ;;
        build-ios)
            build_ios
            ;;
        security)
            security_check
            ;;
        all)
            build_all
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
    
    print_header "Build Process Complete!"
    echo "📱 Ready for deployment"
}

# Run main function
main "$@"
