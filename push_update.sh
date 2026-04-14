#!/bin/bash
cd "$(dirname "$0")"
git add vercel.json .github/workflows/deploy.yml
git commit -m "ci: add GitHub Actions Flutter Web → Vercel deploy workflow

- Strips oversized installCommand from vercel.json (was >256 chars)
- GitHub Actions builds Flutter Web on ubuntu-latest with subosito/flutter-action
- Auto-downloads Amiri + AmiriQuran fonts during CI
- Runs build_runner for Isar codegen
- Deploys build/web to Vercel via vercel-action
- Uses VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID secrets"
git push origin main
echo ""
echo "✓ Pushed. Now add 3 secrets to GitHub:"
echo ""
echo "  Go to: https://github.com/hassanykb/nurpath/settings/secrets/actions"
echo "  Add:"
echo "    VERCEL_TOKEN     → from vercel.com/account/tokens"
echo "    VERCEL_ORG_ID    → run: vercel whoami --json | grep id  (or from vercel project settings)"
echo "    VERCEL_PROJECT_ID → from vercel.com → project → Settings → General"
echo ""
echo "  Then any push to main auto-deploys to Vercel."
