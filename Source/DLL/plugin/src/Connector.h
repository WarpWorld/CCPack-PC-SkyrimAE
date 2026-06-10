#pragma once
#define DEFAULT_BUFLEN 512

#include <winsock2.h>
#include <vector>
#include <mutex>
#include <future>
#include <thread>
#include <array>
#include <map>
#include <atomic>
#include <memory>
#include <string>

#include "skse64/GameTypes.h"
#include "skse64/PluginAPI.h"

struct Command
{
	UINT id = 0;
	std::string command;
	std::string viewer;
	int type = 0;
	long long time = 0;
	int duration = 0;
};

class Connector
{
	SOCKET m_socket = INVALID_SOCKET;
	int iResult = 0;

	bool hasError = false;
	char error[100] = {};

	std::mutex m_mutex;
	std::map<UINT, std::shared_ptr<Command>> command_map;
	std::map<UINT, std::shared_ptr<Command>> pending_map;
	std::map<std::string, std::shared_ptr<Command>> timer_map;

	std::future<void> run_thread;
	std::future<void> command_check_thread;
	std::future<bool> connect_thread;

	std::chrono::steady_clock::time_point start_time = std::chrono::steady_clock::now();
	std::chrono::steady_clock::time_point last_update = std::chrono::steady_clock::now();

	std::atomic<bool> m_shutdown{ false };
	std::atomic<bool> running{ false };
	std::atomic<bool> connecting{ false };
	std::atomic<bool> checking{ false };
	std::atomic<bool> menuOpened{ false };

	std::string socketBuffer;

	long long GetElapsedTime();
	long long GetElapsedTime(std::chrono::steady_clock::time_point time);

	std::shared_ptr<Command> FindCommandLocked(UINT command_id);
	bool HasTimerLocked(const std::string& command_name);
	bool SendSocket(const char* data, size_t length);
	bool SetSocketNonBlocking(SOCKET socket);
	void CloseSocket();
	void StopBackgroundThreads();
	bool ParseCommand(const std::string& json, UINT& command_id, std::string& command_code, std::string& command_viewer, int& command_type, int& command_dur);

	void _RunTimer();
	void _Run();

	std::vector<std::string> BufferSocketResponse(const char* buf, size_t buf_size);

public:

	Connector();
	~Connector();

	void ResetError();
	const char* GetError();
	bool HasError();
	bool IsConnected();
	bool IsRunning();

	void OnMenu(bool isOpen);

	int GetItemCount();
	std::shared_ptr<Command> PopItem();

	void NewTimer(UINT command_id, int miliseconds);
	void ExtendTimer(UINT command_id, int miliseconds);
	bool HasTimer(UINT command_id);
	bool HasTimer(const std::string& command_name);
	void ClearTimers();

	void ConnectAsync(const char* port);
	bool Connect(const char* port);

	void Respond(SInt32 id, SInt32 status, BSFixedString message, int miliseconds);
	void Respond(SInt32 id, SInt32 status, BSFixedString message);

	void Run();
};
