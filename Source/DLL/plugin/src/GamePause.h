#pragma once

void OnMenuOpenClose(const char* menuName, bool opening);

bool QueryNativeGamePaused();
bool QueryTitleScreenActive();
bool QueryLoadingScreenActive();
bool QueryCutsceneScreenActive();
bool QueryPlayerAbsent();
bool QueryPlayerDead();
