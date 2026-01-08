# Harvest Hub - CI/CD Setup Guide

This document explains how to set up automated Android builds using GitHub Actions.

---

## 🔒 Privacy & Security Notice

**This setup does NOT collect any personal information:**

- ✅ No system data collection
- ✅ No IP address tracking
- ✅ No location data
- ✅ No device identifiers
- ✅ No auto-filled credentials
- ✅ All sensitive data stored only in GitHub Secrets
- ✅ Keystore generated locally on your machine
- ✅ Credentials entered manually by you

---

## 📋 Quick Start

### Step 1: Generate the Keystore

Run the keystore generation script on your local machine:

**Windows (PowerShell):**
```powershell
cd scripts
.\generate-keystore.ps1
```

**macOS/Linux (Bash):**
```bash
cd scripts
chmod +x generate-keystore.sh
./generate-keystore.sh
```

The script will:
1. Ask for your **company/organization details** (4 required fields)
2. Ask for **keystore credentials** (alias and passwords)
3. Generate a `.jks` keystore file
4. Output a base64-encoded version for GitHub Secrets
5. Display instructions for adding secrets to GitHub

---

### Step 2: Add GitHub Secrets

Go to your GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

Add these 4 secrets:

| Secret Name | Value |
|-------------|-------|
| `HARVESTHUB_KEYSTORE_BASE64` | Contents of `harvesthub-keystore-base64.txt` |
| `HARVESTHUB_KEYSTORE_PASSWORD` | Your keystore password (entered during generation) |
| `HARVESTHUB_KEY_ALIAS` | Your key alias (entered during generation) |
| `HARVESTHUB_KEY_PASSWORD` | Your key password (entered during generation) |

---

### Step 3: Push to GitHub

The workflow triggers automatically on:
- Push to `main` or `master` branch
- Push to any `release/*` branch
- Pull requests to `main` or `master`
- Manual trigger (Actions → Android Release Build → Run workflow)

```bash
git add .
git commit -m "Add CI/CD workflow"
git push origin main
```

---

### Step 4: Download Artifacts

After the workflow completes:
1. Go to **Actions** tab in your GitHub repository
2. Click on the completed workflow run
3. Scroll to **Artifacts** section
4. Download:
   - `HarvestHub-Release-APK` - Signed APK file
   - `HarvestHub-Release-AAB` - Signed AAB for Play Store

---

## 📁 Files Created

| File | Purpose |
|------|---------|
| `.github/workflows/android-release.yml` | GitHub Actions workflow |
| `android/app/build.gradle.kts` | Updated with signing configuration |
| `android/app/proguard-rules.pro` | ProGuard rules for release builds |
| `scripts/generate-keystore.ps1` | Windows keystore generator |
| `scripts/generate-keystore.sh` | Unix/macOS keystore generator |

---

## 🔐 Security Best Practices

### DO:
- ✅ Store keystore file in a secure backup location
- ✅ Use strong passwords (12+ characters recommended)
- ✅ Delete local keystore files after adding to GitHub Secrets
- ✅ Rotate credentials periodically if needed

### DON'T:
- ❌ NEVER commit `.jks` files to Git
- ❌ NEVER commit `key.properties` to Git
- ❌ NEVER share keystore passwords in code or comments
- ❌ NEVER lose your keystore (you can't update your app without it!)

---

## 🛠️ Workflow Details

The GitHub Actions workflow:

1. **Checks out** the repository
2. **Sets up** Java 17 and Flutter 3.38.5
3. **Decodes** the keystore from base64 secret
4. **Creates** `key.properties` from secrets
5. **Builds** signed APK (`flutter build apk --release`)
6. **Builds** signed AAB (`flutter build appbundle --release`)
7. **Cleans up** sensitive files (keystore, key.properties)
8. **Uploads** APK and AAB as artifacts

### ProGuard Configuration

The `proguard-rules.pro` file includes rules to:
- Keep Flutter classes
- Suppress Google Play Core warnings (not used in this app)
- Optimize the release build

---

## ❓ Troubleshooting

### "Keystore not found" error
- Ensure all 4 secrets are added to GitHub
- Check that `HARVESTHUB_KEYSTORE_BASE64` contains the full base64 string

### "Invalid keystore format" error
- Re-run the keystore generation script
- Ensure the base64 string was copied completely (no line breaks)

### "keytool not found" error
- Install Java JDK: https://adoptium.net/
- Ensure `keytool` is in your system PATH

### Build succeeds but APK is unsigned
- Verify `key.properties` secrets are correct
- Check the workflow logs for signing-related errors

---

## 📞 Support

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Verify all secrets are correctly configured
3. Ensure the keystore was generated with valid credentials

---

## 📜 License

This CI/CD setup is part of the Harvest Hub project.
All sensitive files are excluded from version control.
