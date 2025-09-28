# ==========================================
# Setup and run Flutter project script
# Works on Linux, macOS, and Windows 
# ==========================================

set -euo pipefail

# ------------------------
# Function to print messages
# ------------------------
info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# ------------------------
# Detect Operating System
# ------------------------
OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
    Linux*)   PLATFORM="Linux" ;;
    Darwin*)  PLATFORM="macOS" ;;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="Windows" ;;
    *)        PLATFORM="Unknown" ;;
esac
info "Detected platform: $PLATFORM"

# ------------------------
# Set project directory
# ------------------------
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)/thermal_app"
info "Entering project directory: $PROJECT_DIR"
cd "$PROJECT_DIR" || { error "Failed to enter project directory"; exit 1; }

# ------------------------
# Check if Flutter is installed
# ------------------------
if ! command -v flutter >/dev/null 2>&1; then
    error "Flutter is not installed or not in PATH. Please install Flutter first."
    exit 1
fi

# ------------------------
# Download dependencies
# ------------------------
info "Downloading dependencies..."
flutter pub get
success "Dependencies downloaded successfully"

# ------------------------
# Run the project
# ------------------------
info "Running Flutter project..."
flutter run
