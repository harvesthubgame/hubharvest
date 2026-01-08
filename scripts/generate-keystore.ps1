# =========================================================================
# HARVEST HUB - Keystore Generation Script
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
#   .\generate-keystore.ps1
#
# OUTPUT:
#   - harvesthub-release.jks (keystore file)
#   - harvesthub-keystore-base64.txt (base64 encoded for GitHub Secrets)
#   - Instructions for setting up GitHub Secrets
# =========================================================================

# Get the script's directory (absolute path)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "  HARVEST HUB - Keystore Generation Script" -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  PRIVACY NOTICE:" -ForegroundColor Yellow
Write-Host "  - This script does NOT collect any system information" -ForegroundColor Yellow
Write-Host "  - This script does NOT read your IP, location, or device info" -ForegroundColor Yellow
Write-Host "  - All values are manually entered by you" -ForegroundColor Yellow
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

# ===== COMPANY/ORGANIZATION DETAILS =====
Write-Host "Please enter the following company/organization details:" -ForegroundColor Green
Write-Host "(These will be embedded in the certificate)" -ForegroundColor Gray
Write-Host ""

# Organization Name (Required)
do {
    $orgName = Read-Host "1. Organization Name (e.g., 'Harvest Hub Studios')"
    if ([string]::IsNullOrWhiteSpace($orgName)) {
        Write-Host "   Organization Name is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($orgName))

# Organization Unit (Required)
do {
    $orgUnit = Read-Host "2. Organization Unit (e.g., 'Mobile Development')"
    if ([string]::IsNullOrWhiteSpace($orgUnit)) {
        Write-Host "   Organization Unit is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($orgUnit))

# City/Locality (Required)
do {
    $city = Read-Host "3. City/Locality (e.g., 'Dubai')"
    if ([string]::IsNullOrWhiteSpace($city)) {
        Write-Host "   City is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($city))

# Country Code (Required - 2 letters)
do {
    $country = Read-Host "4. Country Code (2 letters, e.g., 'AE' for UAE, 'US' for USA)"
    $country = $country.ToUpper()
    if ([string]::IsNullOrWhiteSpace($country) -or $country.Length -ne 2) {
        Write-Host "   Country Code must be exactly 2 letters!" -ForegroundColor Red
        $country = ""
    }
} while ([string]::IsNullOrWhiteSpace($country))

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

# ===== KEYSTORE CREDENTIALS =====
Write-Host "Now enter the keystore credentials:" -ForegroundColor Green
Write-Host "(SAVE THESE - you will need them for GitHub Secrets!)" -ForegroundColor Yellow
Write-Host ""

# Key Alias
do {
    $keyAlias = Read-Host "5. Key Alias (e.g., 'harvesthub-release-key')"
    if ([string]::IsNullOrWhiteSpace($keyAlias)) {
        Write-Host "   Key Alias is required!" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($keyAlias))

# Keystore Password (hidden input)
do {
    $keystorePassword = Read-Host "6. Keystore Password (min 6 characters)" -AsSecureString
    $keystorePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($keystorePassword))
    if ([string]::IsNullOrWhiteSpace($keystorePasswordPlain) -or $keystorePasswordPlain.Length -lt 6) {
        Write-Host "   Password must be at least 6 characters!" -ForegroundColor Red
        $keystorePasswordPlain = ""
    }
} while ([string]::IsNullOrWhiteSpace($keystorePasswordPlain))

# Key Password (hidden input)
do {
    $keyPassword = Read-Host "7. Key Password (min 6 characters, can be same as keystore password)" -AsSecureString
    $keyPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPassword))
    if ([string]::IsNullOrWhiteSpace($keyPasswordPlain) -or $keyPasswordPlain.Length -lt 6) {
        Write-Host "   Password must be at least 6 characters!" -ForegroundColor Red
        $keyPasswordPlain = ""
    }
} while ([string]::IsNullOrWhiteSpace($keyPasswordPlain))

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

# ===== DISPLAY SUMMARY =====
Write-Host "Configuration Summary:" -ForegroundColor Green
Write-Host "  Organization:      $orgName" -ForegroundColor White
Write-Host "  Unit:              $orgUnit" -ForegroundColor White
Write-Host "  City:              $city" -ForegroundColor White
Write-Host "  Country:           $country" -ForegroundColor White
Write-Host "  Key Alias:         $keyAlias" -ForegroundColor White
Write-Host "  Passwords:         [HIDDEN]" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Proceed with keystore generation? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Generating keystore..." -ForegroundColor Cyan

# ===== CREATE OUTPUT DIRECTORY (using absolute path) =====
$outputDir = Join-Path $scriptDir "keystore-output"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Write-Host "Output directory: $outputDir" -ForegroundColor Gray

# ===== GENERATE KEYSTORE =====
$keystoreFile = Join-Path $outputDir "harvesthub-release.jks"
$dname = "CN=$orgName, OU=$orgUnit, O=$orgName, L=$city, C=$country"

try {
    # Check if keytool is available
    $keytool = Get-Command keytool -ErrorAction SilentlyContinue
    if (-not $keytool) {
        Write-Host ""
        Write-Host "ERROR: 'keytool' not found!" -ForegroundColor Red
        Write-Host "Please ensure Java JDK is installed and added to PATH." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "You can install it via:" -ForegroundColor White
        Write-Host "  - Download JDK from: https://adoptium.net/" -ForegroundColor Gray
        Write-Host "  - Or if you have Android Studio, find keytool in the JDK folder" -ForegroundColor Gray
        exit 1
    }

    # Remove existing keystore if present
    if (Test-Path $keystoreFile) {
        Remove-Item $keystoreFile -Force
    }

    # Generate the keystore using Start-Process for better control
    $keytoolArgs = "-genkeypair -v -keystore `"$keystoreFile`" -alias `"$keyAlias`" -keyalg RSA -keysize 2048 -validity 10000 -storepass `"$keystorePasswordPlain`" -keypass `"$keyPasswordPlain`" -dname `"$dname`""
    
    $process = Start-Process -FilePath "keytool" -ArgumentList $keytoolArgs -Wait -PassThru -NoNewWindow
    
    # Verify keystore was created
    if (-not (Test-Path $keystoreFile)) {
        throw "Keystore file was not created"
    }

    $keystoreSize = (Get-Item $keystoreFile).Length
    if ($keystoreSize -eq 0) {
        throw "Keystore file is empty"
    }

    Write-Host ""
    Write-Host "Keystore generated successfully! (Size: $keystoreSize bytes)" -ForegroundColor Green

    # ===== CONVERT TO BASE64 =====
    Write-Host "Converting to Base64..." -ForegroundColor Cyan
    
    $base64File = Join-Path $outputDir "harvesthub-keystore-base64.txt"
    
    # Read keystore bytes and convert to base64
    $keystoreBytes = Get-Content -Path $keystoreFile -Encoding Byte -Raw
    $base64String = [System.Convert]::ToBase64String($keystoreBytes)
    
    # Write base64 to file
    Set-Content -Path $base64File -Value $base64String -NoNewline
    
    $base64Size = (Get-Item $base64File).Length
    Write-Host "Base64 file created! (Size: $base64Size bytes)" -ForegroundColor Green

    Write-Host ""
    Write-Host "==========================================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! Keystore Generated" -ForegroundColor Green
    Write-Host "==========================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Files created in:" -ForegroundColor White
    Write-Host "  $outputDir" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. harvesthub-release.jks         - The keystore file (KEEP SAFE!)" -ForegroundColor Gray
    Write-Host "  2. harvesthub-keystore-base64.txt - Base64 encoded (for GitHub)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "==========================================================================" -ForegroundColor Yellow
    Write-Host "  GITHUB SECRETS SETUP" -ForegroundColor Yellow
    Write-Host "==========================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Add these secrets to your GitHub repository:" -ForegroundColor White
    Write-Host "(Settings -> Secrets and variables -> Actions -> New repository secret)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Secret Name                      | Value" -ForegroundColor Cyan
    Write-Host "-------------------------------- | --------------------------------" -ForegroundColor Gray
    Write-Host "HARVESTHUB_KEYSTORE_BASE64       | [Contents of harvesthub-keystore-base64.txt]" -ForegroundColor White
    Write-Host "HARVESTHUB_KEYSTORE_PASSWORD     | [Your keystore password]" -ForegroundColor White
    Write-Host "HARVESTHUB_KEY_ALIAS             | $keyAlias" -ForegroundColor White
    Write-Host "HARVESTHUB_KEY_PASSWORD          | [Your key password]" -ForegroundColor White
    Write-Host ""
    Write-Host "==========================================================================" -ForegroundColor Red
    Write-Host "  IMPORTANT SECURITY NOTES" -ForegroundColor Red
    Write-Host "==========================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "1. NEVER commit the .jks file or base64.txt to Git!" -ForegroundColor Yellow
    Write-Host "2. Store the keystore file in a SECURE location (backup!)" -ForegroundColor Yellow
    Write-Host "3. If you lose the keystore, you CANNOT update your app on Play Store!" -ForegroundColor Yellow
    Write-Host "4. Delete the files from this folder after adding to GitHub Secrets" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "==========================================================================" -ForegroundColor Green

    # Create a secrets reminder file
    $secretsFile = Join-Path $outputDir "GITHUB_SECRETS_REMINDER.txt"
    @"
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
HARVESTHUB_KEY_ALIAS             | $keyAlias
HARVESTHUB_KEY_PASSWORD          | [Your key password - you entered this]
-------------------------------------------------------------------------

SECURITY REMINDERS:
- NEVER commit .jks or base64.txt files to Git
- Store the keystore file in a secure backup location
- Delete these files after adding secrets to GitHub
- If you lose the keystore, you cannot update your app!

=========================================================================
"@ | Out-File -FilePath $secretsFile -Encoding UTF8

    Write-Host ""
    Write-Host "A reminder file has been created: $secretsFile" -ForegroundColor Cyan
    Write-Host ""

    # Open the output folder
    Write-Host "Opening output folder..." -ForegroundColor Cyan
    Start-Process explorer.exe -ArgumentList $outputDir

} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Debug info:" -ForegroundColor Gray
    Write-Host "  Keystore path: $keystoreFile" -ForegroundColor Gray
    Write-Host "  Keystore exists: $(Test-Path $keystoreFile)" -ForegroundColor Gray
    Write-Host ""
    exit 1
}
