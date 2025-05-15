#!/bin/bash
set -euo pipefail

# Default values
GIT_REF=$(git rev-parse HEAD 2>/dev/null || echo "local")
INCLUDES=()
RELEASE_VERSION=""
ORIGINAL_DIR=$(pwd)
OUTPUT_FILE=""
BASE_DIR=""
VERSION_JSON_PATH="version.json"

function show_help {
  echo "Usage: $0 [options]"
  echo ""
  echo "Build a release package with source files for an application"
  echo ""
  echo "Options:"
  echo "  --base-dir             The base source directory (REQUIRED)"
  echo "  --includes             A space-separated list of paths to include in the package relative to the --base-dir (REQUIRED)"
  echo "  --version              Release version (REQUIRED)"
  echo "  --output               Output file name (REQUIRED)"
  echo "  --git-ref              Git reference (default: current HEAD)"
  echo "  --version-json-path    The location where version.json needs to be stored (default: version.json)"
  echo "  --help                 Display this help message"
  echo ""
  echo "Example:"
  echo "  $0 --base-dir \".\" --includes \"app\" --version v1.0.0 --output mypackage.tar.gz"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --base-dir)
      BASE_DIR="$2"
      shift 2
      ;;
    --includes)
      INCLUDES="$2"
      shift 2
      ;;
    --version)
      RELEASE_VERSION="$2"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --git-ref)
      GIT_REF="$2"
      shift 2
      ;;
    --version-json-path)
      VERSION_JSON_PATH="$2"
      shift 2
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

# Required argument checks
[ -z "$BASE_DIR" ] && { echo "ERROR: Source dir is required. Use --base-dir to set it."; show_help; exit 1; }
[ -z "$INCLUDES" ] && { echo "ERROR: Include paths are required. Use --includes to set it."; show_help; exit 1; }
[ -z "$RELEASE_VERSION" ] && { echo "ERROR: Release version is required. Use --version to set it."; show_help; exit 1; }
[ -z "$OUTPUT_FILE" ] && { echo "ERROR: Output file name is required. Use --output to set it."; show_help; exit 1; }

WORK_DIR="/tmp/package-${OUTPUT_FILE}"

echo "Creating release package with the following settings:"
echo "  Version:           ${RELEASE_VERSION}"
echo "  Git ref:           ${GIT_REF}"
echo "  Output:            ${OUTPUT_FILE}"
echo "  Included paths:    ${INCLUDES}"
echo "  version.json path: ${VERSION_JSON_PATH}"

# Create a clean working directory
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"

# Copy source files from the specified source directory
cp -r "${BASE_DIR}"/* "${WORK_DIR}/"

# Ensure the directory for version.json exists
VERSION_JSON_DIR=$(dirname "${WORK_DIR}/${VERSION_JSON_PATH}")
mkdir -p "${VERSION_JSON_DIR}"

# Create or update the version.json with version and git_ref
VERSION_JSON_FULL_PATH="${WORK_DIR}/${VERSION_JSON_PATH}"
echo '{
    "version": "'${RELEASE_VERSION}'",
    "git_ref": "'${GIT_REF}'"
}' > "${VERSION_JSON_FULL_PATH}"

echo "Creating archive ${OUTPUT_FILE}..."

# Create an empty file to avoid tar errors
touch "${ORIGINAL_DIR}/${OUTPUT_FILE}"

# Always include version.json in the tar
EXTRA_INCLUDES="${VERSION_JSON_PATH}"
tar -zcvf "${ORIGINAL_DIR}/${OUTPUT_FILE}" -C "${WORK_DIR}" ${INCLUDES} ${EXTRA_INCLUDES}

echo "You can inspect the contents with: tar -tvf ${ORIGINAL_DIR}/${OUTPUT_FILE}"
