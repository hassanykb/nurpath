#!/bin/bash
# NurPath — GitHub Deploy Script
# Run this once from inside the nurpath folder:
#   chmod +x deploy_github.sh && ./deploy_github.sh

set -e  # exit on any error

REPO_NAME="nurpath"
REPO_DESC="NurPath — Cross-platform Quran companion app built with Flutter (iOS, Android & Web)"

echo ""
echo "🌿 NurPath — GitHub Deploy"
echo "──────────────────────────"

# ── 1. Check prerequisites ──────────────────────────────────────────────────
echo ""
echo "▶ Checking prerequisites..."

if ! command -v git &> /dev/null; then
  echo "❌ git not found. Install Xcode Command Line Tools: xcode-select --install"
  exit 1
fi
echo "  ✓ git $(git --version | cut -d' ' -f3)"

if ! command -v gh &> /dev/null; then
  echo "❌ GitHub CLI (gh) not found."
  echo "   Install with: brew install gh"
  echo "   Then authenticate: gh auth login"
  exit 1
fi
echo "  ✓ gh $(gh --version | head -1 | cut -d' ' -f3)"

# Check gh auth
if ! gh auth status &> /dev/null; then
  echo ""
  echo "❌ Not logged in to GitHub CLI. Run: gh auth login"
  exit 1
fi
GH_USER=$(gh api user --jq '.login' 2>/dev/null)
echo "  ✓ Logged in as: $GH_USER"

# ── 2. Git init ─────────────────────────────────────────────────────────────
echo ""
echo "▶ Initialising git repository..."

if [ ! -d ".git" ]; then
  git init
  git branch -M main
  echo "  ✓ Initialised"
else
  echo "  ✓ Already initialised"
fi

# ── 3. Configure git identity (if not set) ──────────────────────────────────
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")

if [ -z "$GIT_EMAIL" ]; then
  git config --global user.email "hassanykb@gmail.com"
fi
if [ -z "$GIT_NAME" ]; then
  git config --global user.name "Hassan Yakubu"
fi
echo "  ✓ Git identity: $(git config user.name) <$(git config user.email)>"

# ── 4. Stage & commit ────────────────────────────────────────────────────────
echo ""
echo "▶ Staging all files..."
git add -A
echo "  ✓ $(git diff --cached --numstat | wc -l | tr -d ' ') files staged"

echo ""
echo "▶ Creating initial commit..."
git commit -m "🌙 Initial commit — NurPath Flutter Quran companion app

- Full design system: Emerald #0A6C5E + Gold #D4A017 dark theme
- 10 screens: Onboarding, Home, Learn Mode, Reflect & Grow, Faith Score,
  Thematic Journeys, Profile, Memorize Mode, Quran list
- Riverpod 2.5 state management
- Isar offline-first database
- just_audio recitation with al-quran.cloud API
- SRS (Spaced Repetition) memorization system
- Faith Score dashboard with circular rings & sparkline chart
- Geometric Islamic pattern backgrounds
- GoRouter navigation with ShellRoute bottom nav
- flutter_animate animations throughout

Co-authored by: Claude (Anthropic)"
echo "  ✓ Committed"

# ── 5. Create GitHub repo ────────────────────────────────────────────────────
echo ""
echo "▶ Creating GitHub repository '$REPO_NAME'..."

# Check if repo already exists
EXISTING=$(gh repo view "$GH_USER/$REPO_NAME" --json name --jq '.name' 2>/dev/null || echo "")

if [ -n "$EXISTING" ]; then
  echo "  ℹ️  Repo already exists — using existing: https://github.com/$GH_USER/$REPO_NAME"
  REPO_URL="https://github.com/$GH_USER/$REPO_NAME.git"
else
  gh repo create "$REPO_NAME" \
    --description "$REPO_DESC" \
    --public \
    --source=. \
    --remote=origin \
    --push
  echo "  ✓ Created: https://github.com/$GH_USER/$REPO_NAME"
  echo ""
  echo "🎉 Done! Your repo is live at:"
  echo "   https://github.com/$GH_USER/$REPO_NAME"
  exit 0
fi

# ── 6. Push (if repo already existed) ───────────────────────────────────────
echo ""
echo "▶ Setting remote and pushing..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"
git push -u origin main --force
echo "  ✓ Pushed to origin/main"

echo ""
echo "🎉 Done! Your repo is live at:"
echo "   https://github.com/$GH_USER/$REPO_NAME"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next steps:"
echo ""
echo "1. Install Flutter Web renderer (if not already):"
echo "   flutter config --enable-web"
echo ""
echo "2. Build Flutter Web:"
echo "   flutter build web --release"
echo ""
echo "3. Deploy to Vercel (install once):"
echo "   npm install -g vercel"
echo "   cd build/web && vercel --prod"
echo ""
echo "4. OR: Connect GitHub repo on vercel.com for auto-deploy on every push"
echo "   → Build command:  flutter build web --release"
echo "   → Output dir:     build/web"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
