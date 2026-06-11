#pragma once

// ConnectorLib.JSON.GameState values (see CrowdControl-Native/ConnectorLib.JSON/GameState.cs)
enum CCGameState : int
{
	kGameStateUnknown = 0,
	kGameStateReady = 1,
	kGameStateLoading = -6,
	kGameStatePaused = -7,
	kGameStateWrongMode = -8,
	kGameStateCutscene = -11,
	kGameStateBadPlayerState = -12,
	kGameStateMenu = -13,
};

constexpr int kRequestTypeGameUpdate = 0xFD;
constexpr int kResponseTypeGameUpdate = 0xFD;
constexpr int kRequestTypeKeepAlive = 0xFF;
constexpr int kRequestTypeLogin = 0xF0;
constexpr int kRequestTypePlayerInfo = 0xE0;

int QueryGameState();
bool QueryEffectsBlocked();
const char* GameStateName(int state);
