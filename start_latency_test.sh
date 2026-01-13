#!/bin/bash
# Quick start script for LiveKit Agent SDK latency test

set -e

echo "=== LiveKit + Agent SDK Latency Test ==="
echo ""

# Check if Agent SDK is running
echo "Checking Agent SDK..."
if curl -sf http://localhost:8005/health > /dev/null; then
    echo "✅ Agent SDK is running at localhost:8005"
else
    echo "❌ Agent SDK is NOT running!"
    echo "   Start it first: cd /mnt/f/repos/ClaudeLoop && source venv/bin/activate && python anthropic_api_server.py"
    exit 1
fi

echo ""
echo "Choose test mode:"
echo "1. Console mode (with audio - requires mic/speaker)"
echo "2. Text mode (keyboard input - no audio)"
echo "3. Dev mode (run as service for frontend)"
echo ""
read -p "Enter choice (1-3): " choice

cd /mnt/f/repos/agent-sdk-livekit-test

case $choice in
    1)
        echo ""
        echo "Starting console mode with audio..."
        echo "Speak into your microphone to test latency."
        uv run python src/agent.py console
        ;;
    2)
        echo ""
        echo "Starting text mode..."
        echo "Type messages to test (no audio)."
        uv run python src/agent.py console --text
        ;;
    3)
        echo ""
        echo "Starting dev mode..."
        echo "Agent will connect to LiveKit and wait for connections."
        uv run python src/agent.py dev
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
