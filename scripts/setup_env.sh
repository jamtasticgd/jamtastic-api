#!/bin/bash

# itch.io OAuth Environment Setup Script
# This script helps you set up the environment variables for itch.io OAuth integration

echo "🎮 itch.io OAuth Environment Setup"
echo "=================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created!"
    echo ""
fi

echo "🔧 itch.io OAuth Configuration"
echo "=============================="
echo ""
echo "To complete the setup, you need to:"
echo ""
echo "1. 🌐 Register your OAuth application at:"
echo "   https://itch.io/user/settings/oauth"
echo ""
echo "2. 📋 Set the following in your .env file:"
echo "   ITCHIO_CLIENT_ID=your_client_id_here"
echo "   ITCHIO_CLIENT_SECRET=your_client_secret_here (optional)"
echo ""
echo "3. 🔗 Set your redirect URI in itch.io to:"
echo "   $(grep API_URL .env | cut -d'=' -f2)/users/itchio_oauth/callback"
echo ""

# Check if ITCHIO_CLIENT_ID is set
if grep -q "ITCHIO_CLIENT_ID=$" .env || ! grep -q "ITCHIO_CLIENT_ID=" .env; then
    echo "⚠️  ITCHIO_CLIENT_ID is not configured in .env"
    echo ""
    read -p "Would you like to set it now? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your itch.io Client ID: " client_id
        if [ ! -z "$client_id" ]; then
            # Update .env file
            if grep -q "ITCHIO_CLIENT_ID=" .env; then
                sed -i "s/ITCHIO_CLIENT_ID=.*/ITCHIO_CLIENT_ID=$client_id/" .env
            else
                echo "ITCHIO_CLIENT_ID=$client_id" >> .env
            fi
            echo "✅ ITCHIO_CLIENT_ID set to: $client_id"
        fi
    fi
else
    client_id=$(grep "ITCHIO_CLIENT_ID=" .env | cut -d'=' -f2)
    echo "✅ ITCHIO_CLIENT_ID is configured: ${client_id:0:8}..."
fi

echo ""
echo "🚀 Next steps:"
echo "1. Start your Rails server: bin/rails server"
echo "2. Test OAuth flow: GET /users/itchio_oauth/authorize"
echo "3. Check logs for configuration status"
echo ""
echo "📚 For more information, see: docs/ITCHIO_OAUTH.md"
