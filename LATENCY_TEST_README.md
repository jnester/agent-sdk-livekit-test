# LiveKit + Agent SDK Latency Test

## Overview
Minimal LiveKit agent routing audio through Claude Agent SDK to test latency.

**Flow**: Audio in → STT (AssemblyAI) → Agent SDK (localhost:8005) → TTS (Cartesia) → Audio out

## Setup Complete
- ✅ Cloned fresh agent-starter-python (console app version)
- ✅ Configured for Anthropic via Agent SDK endpoint
- ✅ Downloaded required models (Silero VAD, turn detector)
- ✅ Environment configured

## Configuration
The agent uses:
- **STT**: AssemblyAI Universal Streaming
- **LLM**: Claude Sonnet 4.5 via Agent SDK (http://localhost:8005/v1)
- **TTS**: Cartesia Sonic-3
- **VAD**: Silero VAD
- **Turn Detection**: LiveKit Multilingual Turn Detector

## Files Modified
1. `src/agent.py`: Changed LLM from OpenAI to Anthropic (claude-sonnet-4-5-20250929)
2. `.env.local`: Added LiveKit credentials and ANTHROPIC_BASE_URL

## Prerequisites
1. Agent SDK must be running at localhost:8005
   - Verify: `curl http://localhost:8005/health`
   - Expected: `{"status":"healthy","service":"claude-agent-sdk-api"}`

2. LiveKit Cloud credentials configured in `.env.local`

## Running the Agent

### Option 1: Console Mode (Local Testing)
Test locally with microphone/speaker:
```bash
cd /mnt/f/repos/agent-sdk-livekit-test
uv run python src/agent.py console
```

### Option 2: Text Mode (Quick Verification)
Test without audio hardware:
```bash
cd /mnt/f/repos/agent-sdk-livekit-test
uv run python src/agent.py console --text
```

### Option 3: Dev Mode (For Frontend/Telephony)
Run as a service for web/mobile frontends:
```bash
cd /mnt/f/repos/agent-sdk-livekit-test
uv run python src/agent.py dev
```

## Latency Testing
Jason will manually test latency by:
1. Speaking into the microphone
2. Measuring time until audio response
3. Comparing against baseline (OpenAI/direct Anthropic)

## Key Points
- **Bare bones setup**: No custom context, memory, or extra tools
- **Direct routing**: Audio → transcript → Agent SDK → response → TTS
- **Agent SDK benefits**: Warm session, agentic loops (max_turns=100), tool use
- **Goal**: Measure if Agent SDK adds acceptable latency vs direct LLM calls

## Troubleshooting

### Agent SDK not responding
```bash
# Check if running
curl http://localhost:8005/health

# Check logs
tail -f /mnt/f/repos/ClaudeLoop/server.log
```

### Audio device issues (console mode)
```bash
# List available devices
uv run python src/agent.py console --list-devices

# Specify device
uv run python src/agent.py console --input-device "Your Mic" --output-device "Your Speaker"
```

## Notes
- Models are downloaded to `~/.cache/huggingface/hub/`
- Agent SDK uses Claude Code subscription (no API key needed)
- The agent uses preemptive_generation=True for lower latency
