#!/bin/bash

# Git Initialization Script for New Proposal App
# Run this after adding your data files

echo "🚀 Initializing New Proposal App Repository"
echo ""

# Check if git is already initialized
if [ -d .git ]; then
    echo "✅ Git already initialized"
else
    echo "📦 Initializing Git repository..."
    git init
    git branch -M main
fi

# Add remote (update URL if needed)
echo ""
echo "🔗 Setting up remote..."
git remote remove origin 2>/dev/null  # Remove if exists
git remote add origin https://github.com/briandahlen-droid/New-Proposal-App.git

# Verify required files are NOT being committed
echo ""
echo "🔍 Checking .gitignore..."
if [ -f .gitignore ]; then
    echo "✅ .gitignore exists"
    echo ""
    echo "⚠️  The following files will NOT be committed (protected):"
    echo "   - data/eContractMaster.xlsm"
    echo "   - data/Proposal Task Tool.xlsx"
    echo "   - assets/Template.docx"
    echo "   - output/*.docx (generated files)"
else
    echo "❌ .gitignore missing!"
    exit 1
fi

# Show what will be committed
echo ""
echo "📋 Files that WILL be committed:"
git add -n .

echo ""
read -p "Does this look correct? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted. Review files and try again."
    exit 1
fi

# Stage files
echo ""
echo "📤 Staging files..."
git add .

# First commit
echo ""
echo "💾 Creating initial commit..."
git commit -m "Initial commit - Pinellas consolidated zoning integration"

# Push to GitHub
echo ""
read -p "Push to GitHub now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Pushing to GitHub..."
    git push -u origin main
    echo ""
    echo "✅ Repository successfully pushed to GitHub!"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://share.streamlit.io"
    echo "2. Deploy app from your GitHub repository"
    echo "3. Upload data files to deployed app"
else
    echo "⏸️  Skipped push. Run manually when ready:"
    echo "   git push -u origin main"
fi

echo ""
echo "✅ Git setup complete!"
