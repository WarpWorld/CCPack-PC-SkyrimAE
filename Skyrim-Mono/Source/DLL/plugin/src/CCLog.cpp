#include "CCLog.h"

#include <Windows.h>

#include <cstdio>
#include <mutex>

namespace
{
	std::mutex g_logMutex;
	FILE* g_logFile = nullptr;

	void OpenDllLogFile()
	{
		HMODULE module = nullptr;
		if (!GetModuleHandleExA(
			GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
			reinterpret_cast<LPCSTR>(&CCLog::Init),
			&module))
		{
			return;
		}

		char dllPath[MAX_PATH] = {};
		if (GetModuleFileNameA(module, dllPath, MAX_PATH) == 0)
		{
			return;
		}

		char* slash = strrchr(dllPath, '\\');
		if (!slash)
		{
			return;
		}

		*(slash + 1) = '\0';

		char logPath[MAX_PATH] = {};
		snprintf(logPath, sizeof(logPath), "%sCrowdControl.log", dllPath);

		FILE* file = nullptr;
		if (fopen_s(&file, logPath, "w") != 0 || !file)
		{
			return;
		}

		setvbuf(file, nullptr, _IONBF, 0);
		g_logFile = file;
	}
}

void CCLog::Init()
{
	std::lock_guard lock(g_logMutex);
	if (g_logFile)
	{
		return;
	}

	OpenDllLogFile();
}

void CCLog::Write(const char* fmt, ...)
{
	if (!fmt)
	{
		return;
	}

	Init();

	char message[2048] = {};
	va_list args;
	va_start(args, fmt);
	vsnprintf(message, sizeof(message), fmt, args);
	va_end(args);

	SYSTEMTIME time = {};
	GetLocalTime(&time);

	char line[2304] = {};
	snprintf(line, sizeof(line), "[%02u:%02u:%02u.%03u] %s\n",
		time.wHour,
		time.wMinute,
		time.wSecond,
		time.wMilliseconds,
		message);

	std::lock_guard lock(g_logMutex);
	if (g_logFile)
	{
		fputs(line, g_logFile);
		fflush(g_logFile);
	}

	OutputDebugStringA(line);
}
