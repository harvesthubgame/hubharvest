#!/bin/bash
# =========================================================================
# HARVEST HUB - Keystore Generation Script (Unix/macOS/Linux)
# =========================================================================
# This script generates a secure keystore for signing Android releases.
#
# PRIVACY NOTICE:
# - This script does NOT collect any system information
# - This script does NOT read your IP address, location, or device info
# - This script does NOT auto-fill any values
# - All information is manually entered by you
# - The keystore is generated LOCALLY on your machine
#
# USAGE:
#   chmod +x generate-keystore.sh
#   ./generate-keystore.sh
#
# OUTPUT:
#   - harvesthub-release.jks (keystore file)
#   - harvesthub-keystore-base64.txt (base64 encoded for GitHub Secrets)
#   - Instructions for setting up GitHub Secrets
# =========================================================================

set -e

echo ""
echo "=========================================================================="
echo "  HARVEST HUB - Keystore Generation Script"
echo "=========================================================================="
echo ""
echo "  PRIVACY NOTICE:"
echo "  - This script does NOT collect any system information"
echo "  - This script does NOT read your IP, location, or device info"
echo "  - All values are manually entered by you"
echo ""
echo "=========================================================================="
echo ""

# ===== COMPANY/ORGANIZATION DETAILS =====
echo "Please enter the following company/organization details:"
echo "(These will be embedded in the certificate)"
echo ""

# Organization Name (Required)
while true; do
    read -p "1. Organization Name (e.g., 'Harvest Hub Studios'): " ORG_NAME
    if [ -n "$ORG_NAME" ]; then break; fi
    echo "   Organization Name is required!"
done

# Organization Unit (Required)
while true; do
    read -p "2. Organization Unit (e.g., 'Mobile Development'): " ORG_UNIT
    if [ -n "$ORG_UNIT" ]; then break; fi
    echo "   Organization Unit is required!"
done

# City/Locality (Required)
while true; do
    read -p "3. City/Locality (e.g., 'Dubai'): " CITY
    if [ -n "$CITY" ]; then break; fi
    echo "   City is required!"
done

# Country Code (Required - 2 letters)
while true; do
    read -p "4. Country Code (2 letters, e.g., 'AE' for UAE, 'US' for USA): " COUNTRY
    COUNTRY=$(echo "$COUNTRY" | tr '[:lower:]' '[:upper:]')
    if [ ${#COUNTRY} -eq 2 ]; then break; fi
    echo "   Country Code must be exactly 2 letters!"
done

echo ""
echo "=========================================================================="
echo ""

# ===== KEYSTORE CREDENTIALS =====
echo "Now enter the keystore credentials:"
echo "(SAVE THESE - you will need them for GitHub Secrets!)"
echo ""

# Key Alias
while true; do
    read -p "5. Key Alias (e.g., 'harvesthub-release-key'): " KEY_ALIAS
    if [ -n "$KEY_ALIAS" ]; then break; fi
    echo "   Key Alias is required!"
done

# Keystore Password (hidden input)
while true; do
    read -sp "6. Keystore Password (min 6 characters): " KEYSTORE_PASSWORD
    echo ""
    if [ ${#KEYSTORE_PASSWORD} -ge 6 ]; then break; fi
    echo "   Password must be at least 6 characters!"
done

# Key Password (hidden input)
while true; do
    read -sp "7. Key Password (min 6 characters, can be same as keystore password): " KEY_PASSWORD
    echo ""
    if [ ${#KEY_PASSWORD} -ge 6 ]; then break; fi
    echo "   Password must be at least 6 characters!"
done

echo ""
echo "=========================================================================="
echo ""

# ===== DISPLAY SUMMARY =====
echo "Configuration Summary:"
echo "  Organization:      $ORG_NAME"
echo "  Unit:              $ORG_UNIT"
echo "  City:              $CITY"
echo "  Country:           $COUNTRY"
echo "  Key Alias:         $KEY_ALIAS"
echo "  Passwords:         [HIDDEN]"
echo ""

read -p "Proceed with keystore generation? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Generating keystore..."

# ===== CREATE OUTPUT DIRECTORY =====
OUTPUT_DIR="./keystore-output"
mkdir -p "$OUTPUT_DIR"

# ===== GENERATE KEYSTORE =====
KEYSTORE_FILE="$OUTPUT_DIR/harvesthub-release.jks"
DNAME="CN=$ORG_NAME, OU=$ORG_UNIT, O=$ORG_NAME, L=$CITY, C=$COUNTRY"

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo ""
    echo "ERROR: 'keytool' not found!"
    echo "Please ensure Java JDK is installed and added to PATH."
    echo ""
    echo "You can install it via:"
    echo "  - macOS: brew install openjdk"
    echo "  - Ubuntu: sudo apt install default-jdk"
    echo "  - Or download from: https://adoptium.net/"
    exit 1
fi

# Generate the keystore
keytool -genkeypair \
    -v \
    -keystore "$KEYSTORE_FILE" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "$DNAME"

echo ""
echo "Keystore generated successfully!"

# ===== CONVERT TO BASE64 =====
echo "Converting to Base64..."

BASE64_FILE="$OUTPUT_DIR/harvesthub-keystore-base64.txt"
base64 < "$KEYSTORE_FILE" | tr -d '\n' > "$BASE64_FILE"

echo ""
echo "=========================================================================="
echo "  SUCCESS! Keystore Generated"
echo "=========================================================================="
echo ""
echo "Files created in '$OUTPUT_DIR':"
echo "  1. harvesthub-release.jks     - The keystore file (KEEP SAFE!)"
echo "  2. harvesthub-keystore-base64.txt - Base64 encoded (for GitHub)"
echo ""
echo "=========================================================================="
echo "  GITHUB SECRETS SETUP"
echo "=========================================================================="
echo ""
echo "Add these secrets to your GitHub repository:"
echo "(Settings -> Secrets and variables -> Actions -> New repository secret)"
echo ""
echo "Secret Name                      | Value"
echo "-------------------------------- | --------------------------------"
echo "HARVESTHUB_KEYSTORE_BASE64       | [Contents of harvesthub-keystore-base64.txt]"
echo "HARVESTHUB_KEYSTORE_PASSWORD     | [Your keystore password]"
echo "HARVESTHUB_KEY_ALIAS             | $KEY_ALIAS"
echo "HARVESTHUB_KEY_PASSWORD          | [Your key password]"
echo ""
echo "=========================================================================="
echo "  IMPORTANT SECURITY NOTES"
echo "=========================================================================="
echo ""
echo "1. NEVER commit the .jks file or base64.txt to Git!"
echo "2. Store the keystore file in a SECURE location (backup!)"
echo "3. If you lose the keystore, you CANNOT update your app on Play Store!"
echo "4. Delete the files from this folder after adding to GitHub Secrets"
echo ""
echo "=========================================================================="

# Create a secrets reminder file
cat > "$OUTPUT_DIR/GITHUB_SECRETS_REMINDER.txt" << EOF
=========================================================================
HARVEST HUB - GitHub Secrets Configuration
=========================================================================

Add these 4 secrets to your GitHub repository:
Go to: Settings -> Secrets and variables -> Actions -> New repository secret

-------------------------------------------------------------------------
SECRET NAME                      | VALUE
-------------------------------------------------------------------------
HARVESTHUB_KEYSTORE_BASE64       | [Paste entire contents of harvesthub-keystore-base64.txt]
HARVESTHUB_KEYSTORE_PASSWORD     | [Your keystore password - you entered this]
HARVESTHUB_KEY_ALIAS             | $KEY_ALIAS
HARVESTHUB_KEY_PASSWORD          | [Your key password - you entered this]
-------------------------------------------------------------------------

SECURITY REMINDERS:
- NEVER commit .jks or base64.txt files to Git
- Store the keystore file in a secure backup location
- Delete these files after adding secrets to GitHub
- If you lose the keystore, you cannot update your app!

=========================================================================
EOF

echo ""
echo "A reminder file has been created: $OUTPUT_DIR/GITHUB_SECRETS_REMINDER.txt"
echo ""
