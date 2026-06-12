#include "GameState.h"

#include "GamePause.h"

#include <chrono>
#include <optional>

namespace
{
	constexpr auto kPlayableSettleTime = std::chrono::milliseconds(2000);

	bool PlayableSettled()
	{
		static std::chrono::steady_clock::time_point s_since;
		static bool s_was_ready_candidate = false;

		const bool ready_candidate =
			!QueryTitleScreenActive()
			&& !QueryLoadingScreenActive()
			&& !QueryCutsceneScreenActive()
			&& !QueryPlayerAbsent()
			&& !QueryPlayerDead()
			&& !QueryNativeGamePaused();

		if (!ready_candidate)
		{
			s_was_ready_candidate = false;
			return false;
		}

		const auto now = std::chrono::steady_clock::now();
		if (!s_was_ready_candidate)
		{
			s_was_ready_candidate = true;
			s_since = now;
		}

		return now - s_since >= kPlayableSettleTime;
	}

	int QueryRawGameState()
	{
		if (QueryTitleScreenActive())
		{
			return kGameStateWrongMode;
		}

		if (QueryLoadingScreenActive())
		{
			return kGameStateLoading;
		}

		if (QueryPlayerAbsent())
		{
			return kGameStateWrongMode;
		}

		if (QueryPlayerDead())
		{
			return kGameStateBadPlayerState;
		}

		if (QueryCutsceneScreenActive())
		{
			return kGameStateCutscene;
		}

		if (QueryNativeGamePaused())
		{
			return kGameStatePaused;
		}

		return kGameStateReady;
	}
}

int QueryGameState()
{
	const int raw_state = QueryRawGameState();
	if (raw_state == kGameStateReady && !PlayableSettled())
	{
		return kGameStateLoading;
	}

	return raw_state;
}

bool QueryEffectsBlocked()
{
	return QueryGameState() != kGameStateReady;
}

const char* GameStateName(int state)
{
	switch (state)
	{
	case kGameStateReady:
		return "Ready";
	case kGameStateLoading:
		return "Loading";
	case kGameStatePaused:
		return "Paused";
	case kGameStateWrongMode:
		return "WrongMode";
	case kGameStateCutscene:
		return "Cutscene";
	case kGameStateBadPlayerState:
		return "BadPlayerState";
	case kGameStateMenu:
		return "Menu";
	default:
		return "Unknown";
	}
}
