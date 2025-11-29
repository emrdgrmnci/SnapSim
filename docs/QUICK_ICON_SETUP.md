# Quick Icon Setup

## Easiest Method: SF Symbols (5 minutes)

1. **Open SF Symbols app** (comes with Xcode)
   - Or download from: https://developer.apple.com/sf-symbols/

2. **Search for "iphone"**

3. **Export the icon:**
   - Select the `iphone` symbol
   - File > Export Symbol...
   - Choose SVG format

4. **Create icon using online tool:**
   - Go to https://www.appicon.co
   - Upload your SVG or create from SF Symbol
   - Download all sizes

5. **Add to Xcode:**
   - Open `SnapSim.xcodeproj`
   - Navigate to `SnapSim/Assets.xcassets/AppIcon`
   - Drag and drop icon files OR
   - Use the "AppIcon Set" from appicon.co

## Method 2: Quick Figma Design (15 minutes)

**Free Figma Template:**

1. Go to https://figma.com
2. Create free account
3. Create new file (1024x1024)
4. Draw:
   - Rounded rectangle (1024x1024, corner radius: 200)
   - Add gradient: #007AFF → #5AC8FA
   - Add iPhone symbol from SF Symbols
   - Center it

5. Export:
   - Select all
   - Export as PNG @1x, @2x, @3x
   - Use https://appicon.co to generate all sizes

## Method 3: AI Generation (10 minutes)

**DALL-E Prompt:**
```
"Modern macOS app icon, minimalist iPhone simulator icon, 
blue gradient background, iOS style, flat design, 
simple and clean, 1024x1024"
```

**ChatGPT (with DALL-E):**
- Ask: "Create an app icon for a macOS app called SnapSim that hides iOS Simulator windows"

**Process:**
1. Generate with AI
2. Download image
3. Use https://appicon.co to create all sizes
4. Import to Xcode

## Current Placeholder

Right now, the app uses the SF Symbol `iphone` as a temporary menu bar icon, which is fine for development but you'll want a proper app icon for distribution.

## Required Sizes for macOS

You need these sizes (or use a generator tool):
- 16x16, 16x16@2x
- 32x32, 32x32@2x
- 128x128, 128x128@2x
- 256x256, 256x256@2x
- 512x512, 512x512@2x
- 1024x1024

## Recommended Colors

- **iOS Blue:** #007AFF
- **Light Blue:** #5AC8FA
- **Gradient:** From #007AFF to #5AC8FA
- **White:** For contrast

## Quick Test

After adding icon:
1. Build and run in Xcode
2. Check Applications folder
3. Icon should appear on the app file
4. Icon shows in menu bar when app runs

