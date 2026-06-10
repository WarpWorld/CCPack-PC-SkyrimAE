#include "CCLog.h"

#include <ShlObj.h>
#include <Windows.h>

#include <cstdio>
#include <mutex>
#include <string>
#include <vector>

namespace
{
	std::mutex g_logMutex;
	std::vector<FILE*> g_logFiles;

	void OpenLogFile(const char* path)
	{
		if (!path || !path[0])
		{
			return;
		}

		FILE* file = nullptr;
		if (fopen_s(&file, path, "a") != 0 || !file)
		{
			return;
		}

		setvbuf(file, nullptr, _IONBF, 0);
		g_logFiles.push_back(file);
		fprintf(file, "\n--- CrowdControl log session ---\n");
		fflush(file);
	}

	void EnsureDirectoryForFile(const char* filePath)
	{
		char dir[MAX_PATH] = {};
		strncpy_s(dir, filePath, _TRUNCATE);
		char* slash = strrchr(dir, '\\');
		if (!slash)
		{
			return;
		}

		*slash = '\0';
		SHCreateDirectoryExA(nullptr, dir, nullptr);
	}
}

void CCLog::Init()
{
	std::lock_guard lock(g_logMutex);
	if (!g_logFiles.empty())
	{
		return;
	}

	char documentsPath[MAX_PATH] = {};
	if (SUCCEEDED(SHGetFolderPathA(nullptr, CSIDL_MYDOCUMENTS, nullptr, SHGFP_TYPE_CURRENT, documentsPath)))
	{
		char documentsLog[MAX_PATH] = {};
		snprintf(documentsLog, sizeof(documentsLog), "%s\\My Games\\Skyrim Special Edition\\SKSE\\CrowdControl.log", documentsPath);
		EnsureDirectoryForFile(documentsLog);
		OpenLogFile(documentsLog);
	}

	HMODULE module = nullptr;
	if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
		reinterpret_cast<LPCSTR>(&CCLog::Init),
		&module))
	{
		char dllPath[MAX_PATH] = {};
		if (GetModuleFileNameA(module, dllPath, MAX_PATH) > 0)
		{
			char* slash = strrchr(dllPath, '\\');
			if (slash)
			{
				*(slash + 1) = '\0';
				char pluginLog[MAX_PATH] = {};
				snprintf(pluginLog, sizeof(pluginLog), "%sCrowdControl.log", dllPath);
				OpenLogFile(pluginLog);
			}
		}
	}

	char tempLog[MAX_PATH] = {};
	if (GetTempPathA(MAX_PATH, tempLog) > 0)
	{
		char tempFile[MAX_PATH] = {};
		snprintf(tempFile, sizeof(tempFile), "%sCrowdControl-SkyrimAE.log", tempLog);
		OpenLogFile(tempFile);
	}
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
	for (FILE* file : g_logFiles)
	{
		if (file)
		{
			fputs(line, file);
			fflush(file);
		}
	}

	OutputDebugStringA(line);
}
