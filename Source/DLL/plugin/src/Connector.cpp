#include "Connector.h"

#include <ws2tcpip.h>
#include <stdio.h>
#include <iostream>
#include <functional>
#include <chrono>

#include "rapidjson/document.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/writer.h"
#include "skse64/GameUtilities.h"
#include "skse64/gamethreads.h"
#include "skse64/GameAPI.h"
#pragma comment(lib, "Ws2_32.lib")

namespace
{
	static std::atomic<int> g_wsaRefCount{ 0 };

	void AcquireWSA()
	{
		if (g_wsaRefCount.fetch_add(1) == 0)
		{
			WSADATA wsaData = {};
			const int err = WSAStartup(MAKEWORD(2, 2), &wsaData);
			if (err != 0)
			{
				g_wsaRefCount.fetch_sub(1);
				_ERROR("[Connector] WSAStartup failed: %d", err);
			}
		}
	}

	void ReleaseWSA()
	{
		if (g_wsaRefCount.fetch_sub(1) == 1)
		{
			WSACleanup();
		}
	}
}

Connector::Connector()
{
	AcquireWSA();
}

Connector::~Connector()
{
	StopBackgroundThreads();
	CloseSocket();
	ReleaseWSA();
}

void Connector::CloseSocket()
{
	if (m_socket != INVALID_SOCKET)
	{
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;
	}
}

void Connector::StopBackgroundThreads()
{
	m_shutdown.store(true);
	CloseSocket();

	if (run_thread.valid())
	{
		run_thread.wait();
	}

	if (command_check_thread.valid())
	{
		command_check_thread.wait();
	}

	if (connect_thread.valid())
	{
		connect_thread.wait();
	}
}

bool Connector::HasError()
{
	return hasError;
}

const char* Connector::GetError()
{
	return error;
}

void Connector::ResetError()
{
	hasError = false;
	ZeroMemory(error, sizeof(error));
}

bool Connector::IsConnected()
{
	return m_socket != INVALID_SOCKET && !connecting.load();
}

bool Connector::IsRunning()
{
	return running.load() && checking.load();
}

void Connector::OnMenu(bool isOpen)
{
	menuOpened.store(isOpen);
}

int Connector::GetItemCount()
{
	std::lock_guard guard(m_mutex);
	return static_cast<int>(command_map.size());
}

std::shared_ptr<Command> Connector::FindCommandLocked(UINT command_id)
{
	auto pending = pending_map.find(command_id);
	if (pending != pending_map.end())
	{
		return pending->second;
	}

	auto queued = command_map.find(command_id);
	if (queued != command_map.end())
	{
		return queued->second;
	}

	return nullptr;
}

std::shared_ptr<Command> Connector::PopItem()
{
	try
	{
		std::lock_guard guard(m_mutex);
		if (command_map.empty())
		{
			return nullptr;
		}

		auto iter = command_map.begin();
		auto command = iter->second;
		command_map.erase(iter);
		command->time = GetElapsedTime();
		pending_map.insert({ command->id, command });
		return command;
	}
	catch (const std::exception& e)
	{
		_ERROR("[Connector::PopItem] %s", e.what());
	}

	return nullptr;
}

void Connector::NewTimer(UINT command_id, int miliseconds)
{
	std::lock_guard guard(m_mutex);
	auto c = FindCommandLocked(command_id);
	if (!c)
	{
		return;
	}

	c->type = 2;
	if (c->duration > 0)
	{
		miliseconds = c->duration;
	}

	c->time = GetElapsedTime() + static_cast<long long>(miliseconds);
	timer_map.insert({ c->command, c });
}

void Connector::ExtendTimer(UINT command_id, int miliseconds)
{
	std::lock_guard guard(m_mutex);
	auto c = FindCommandLocked(command_id);
	if (!c)
	{
		return;
	}

	c->time += miliseconds;
}

bool Connector::HasTimerLocked(const std::string& command_name)
{
	return timer_map.find(command_name) != timer_map.end();
}

bool Connector::HasTimer(UINT command_id)
{
	try
	{
		std::lock_guard guard(m_mutex);
		auto c = FindCommandLocked(command_id);
		if (!c)
		{
			return false;
		}

		return HasTimerLocked(c->command);
	}
	catch (const std::exception& e)
	{
		_ERROR("[Connector::HasTimer] %s", e.what());
	}

	return false;
}

bool Connector::HasTimer(const std::string& command_name)
{
	std::lock_guard guard(m_mutex);
	return HasTimerLocked(command_name);
}

void Connector::ClearTimers()
{
	std::lock_guard lock(m_mutex);
	timer_map.clear();
}

void Connector::ConnectAsync(const char* port)
{
	if (IsConnected())
	{
		return;
	}

	if (connect_thread.valid())
	{
		const auto status = connect_thread.wait_for(std::chrono::milliseconds::zero());
		if (status == std::future_status::ready)
		{
			const bool result = connect_thread.get();
			if (!result)
			{
				connect_thread = std::async(std::launch::async, &Connector::Connect, this, port);
			}
			else
			{
				connect_thread = std::future<bool>();
			}
		}
	}
	else
	{
		connect_thread = std::async(std::launch::async, &Connector::Connect, this, port);
	}
}

bool Connector::SetSocketNonBlocking(SOCKET socket)
{
	u_long mode = 1;
	return ioctlsocket(socket, FIONBIO, &mode) == 0;
}

bool Connector::Connect(const char* port)
{
	connecting.store(true);

	try
	{
		addrinfo hints = {};
		hints.ai_family = AF_INET;
		hints.ai_socktype = SOCK_STREAM;
		hints.ai_protocol = IPPROTO_TCP;

		addrinfo* result = nullptr;
		iResult = getaddrinfo("127.0.0.1", port, &hints, &result);
		if (iResult != 0)
		{
			hasError = true;
			snprintf(error, sizeof(error), "getaddrinfo error: %d", iResult);
			connecting.store(false);
			return false;
		}

		SOCKET socketCandidate = INVALID_SOCKET;
		for (addrinfo* ptr = result; ptr != nullptr; ptr = ptr->ai_next)
		{
			socketCandidate = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
			if (socketCandidate == INVALID_SOCKET)
			{
				continue;
			}

			if (connect(socketCandidate, ptr->ai_addr, static_cast<int>(ptr->ai_addrlen)) == SOCKET_ERROR)
			{
				closesocket(socketCandidate);
				socketCandidate = INVALID_SOCKET;
				continue;
			}

			break;
		}

		freeaddrinfo(result);

		if (socketCandidate == INVALID_SOCKET)
		{
			hasError = true;
			snprintf(error, sizeof(error), "Error connecting to Crowd Control");
			connecting.store(false);
			return false;
		}

		if (!SetSocketNonBlocking(socketCandidate))
		{
			hasError = true;
			snprintf(error, sizeof(error), "Failed to configure socket: %d", WSAGetLastError());
			closesocket(socketCandidate);
			connecting.store(false);
			return false;
		}

		m_shutdown.store(false);
		m_socket = socketCandidate;
		ResetError();
		connecting.store(false);
		Run();
		return true;
	}
	catch (const std::exception& e)
	{
		_ERROR("[Connector::Connect] %s", e.what());
		CloseSocket();
		connecting.store(false);
	}

	return false;
}

bool Connector::SendSocket(const char* data, size_t length)
{
	if (m_socket == INVALID_SOCKET)
	{
		return false;
	}

	size_t totalSent = 0;
	while (totalSent < length)
	{
		const int sent = send(m_socket, data + totalSent, static_cast<int>(length - totalSent), 0);
		if (sent == SOCKET_ERROR)
		{
			const int lastError = WSAGetLastError();
			if (lastError == WSAEWOULDBLOCK)
			{
				Sleep(1);
				continue;
			}

			hasError = true;
			snprintf(error, sizeof(error), "send failed: %d", lastError);
			CloseSocket();
			return false;
		}

		if (sent == 0)
		{
			return false;
		}

		totalSent += static_cast<size_t>(sent);
	}

	return true;
}

void Connector::Respond(SInt32 id, SInt32 status, BSFixedString message, int miliseconds)
{
	try
	{
		std::shared_ptr<Command> c;
		{
			std::lock_guard lock(m_mutex);
			c = FindCommandLocked(static_cast<UINT>(id));
			if (!c)
			{
				return;
			}
		}

		bool timer_created = false;
		if (status == 4)
		{
			timer_created = true;
			status = 0;
			if (!HasTimer(id))
			{
				NewTimer(static_cast<UINT>(id), miliseconds);
			}
			else
			{
				_MESSAGE("Extending timer for %s", c->command.c_str());
				ExtendTimer(static_cast<UINT>(id), miliseconds);
			}
		}

		if (c->type == 1 || timer_created)
		{
			Respond(id, status, message);
		}

		std::lock_guard lock(m_mutex);
		pending_map.erase(c->id);
		command_map.erase(c->id);
	}
	catch (const std::exception& e)
	{
		_ERROR("[Connector::Respond] %s", e.what());
	}
}

void Connector::Respond(SInt32 id, SInt32 status, BSFixedString message)
{
	try
	{
		if (m_socket == INVALID_SOCKET)
		{
			return;
		}

		rapidjson::Document data;
		data.SetObject();

		rapidjson::Document::AllocatorType& allocator = data.GetAllocator();
		data.AddMember("id", id, allocator);
		data.AddMember("status", status, allocator);

		const char* messageText = message.c_str();
		if (messageText && messageText[0] != '\0')
		{
			rapidjson::Value val;
			val.SetString(messageText, static_cast<rapidjson::SizeType>(strlen(messageText)), allocator);
			data.AddMember("message", val, allocator);
		}

		rapidjson::StringBuffer buf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(buf);
		data.Accept(writer);
		buf.Put('\0');

		if (!SendSocket(buf.GetString(), buf.GetLength()))
		{
			_ERROR("[Connector::Respond] Failed to send response for id %d", id);
		}
	}
	catch (const std::exception& e)
	{
		_ERROR("[Connector::Respond 2] %s", e.what());
	}
}

void Connector::Run()
{
	if (!IsConnected())
	{
		return;
	}

	if (run_thread.valid())
	{
		const auto status = run_thread.wait_for(std::chrono::milliseconds::zero());
		if (status == std::future_status::ready)
		{
			run_thread = std::async(std::launch::async, &Connector::_Run, this);
		}
	}
	else
	{
		run_thread = std::async(std::launch::async, &Connector::_Run, this);
	}

	if (command_check_thread.valid())
	{
		const auto status = command_check_thread.wait_for(std::chrono::milliseconds::zero());
		if (status == std::future_status::ready)
		{
			command_check_thread = std::async(std::launch::async, &Connector::_RunTimer, this);
		}
	}
	else
	{
		command_check_thread = std::async(std::launch::async, &Connector::_RunTimer, this);
	}
}

long long Connector::GetElapsedTime()
{
	return GetElapsedTime(start_time);
}

long long Connector::GetElapsedTime(std::chrono::steady_clock::time_point time)
{
	return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - time).count();
}

void Connector::_RunTimer()
{
	checking.store(true);
	while (!m_shutdown.load())
	{
		Sleep(500);
		try
		{
			std::vector<UINT> timedOut;
			{
				std::lock_guard guard(m_mutex);

				long long delta_time = 0;
				if (menuOpened.load())
				{
					delta_time = GetElapsedTime(last_update);
				}

				const long long cur_timer = GetElapsedTime();

				for (auto iter = pending_map.begin(); iter != pending_map.end();)
				{
					if (iter->second->type == 1 && cur_timer - iter->second->time > 2000)
					{
						timedOut.push_back(iter->first);
						iter = pending_map.erase(iter);
					}
					else
					{
						++iter;
					}
				}

				for (auto timer_iter = timer_map.begin(); timer_iter != timer_map.end();)
				{
					timer_iter->second->time += delta_time;
					auto c = timer_iter->second;
					if (cur_timer > c->time)
					{
						command_map.insert({ c->id, c });
						timer_iter = timer_map.erase(timer_iter);
					}
					else
					{
						++timer_iter;
					}
				}

				last_update = std::chrono::steady_clock::now();
			}

			for (UINT commandId : timedOut)
			{
				Respond(static_cast<SInt32>(commandId), 3, "");
			}
		}
		catch (const std::exception& e)
		{
			_ERROR("[Connector::_RunTimer] %s", e.what());
		}
	}

	checking.store(false);
}

bool Connector::ParseCommand(const std::string& json, UINT& command_id, std::string& command_code, std::string& command_viewer, int& command_type, int& command_dur)
{
	rapidjson::Document data;
	data.Parse(json.c_str());
	if (!data.IsObject())
	{
		return false;
	}

	if (!data.HasMember("id") || !data["id"].IsUint())
	{
		return false;
	}

	if (!data.HasMember("code") || !data["code"].IsString())
	{
		return false;
	}

	if (!data.HasMember("viewer") || !data["viewer"].IsString())
	{
		return false;
	}

	if (!data.HasMember("type") || !data["type"].IsInt())
	{
		return false;
	}

	command_id = data["id"].GetUint();
	command_code = data["code"].GetString();
	command_viewer = data["viewer"].GetString();
	command_type = data["type"].GetInt();
	command_dur = 0;

	if (command_code.empty())
	{
		return false;
	}

	if (data.HasMember("duration") && data["duration"].IsInt())
	{
		command_dur = data["duration"].GetInt();
	}

	return true;
}

void Connector::_Run()
{
	running.store(true);
	while (!m_shutdown.load() && m_socket != INVALID_SOCKET)
	{
		try
		{
			char recvbuf[DEFAULT_BUFLEN] = {};
			iResult = recv(m_socket, recvbuf, DEFAULT_BUFLEN - 1, 0);
			if (iResult > 0)
			{
				const auto commands = BufferSocketResponse(recvbuf, static_cast<size_t>(iResult));
				for (const auto& c : commands)
				{
					if (c.empty())
					{
						continue;
					}

					UINT command_id = 0;
					std::string command_code;
					std::string command_viewer;
					int command_type = 0;
					int command_dur = 0;
					if (!ParseCommand(c, command_id, command_code, command_viewer, command_type, command_dur))
					{
						_ERROR("[Connector::_Run] Ignoring invalid command payload");
						continue;
					}

					std::lock_guard<std::mutex> lock(m_mutex);
					command_map[command_id] = std::make_shared<Command>(Command{
						command_id,
						command_code,
						command_viewer,
						command_type,
						GetElapsedTime(),
						command_dur
					});
				}
			}
			else if (iResult == 0)
			{
				hasError = true;
				snprintf(error, sizeof(error), "Connection closed");
				CloseSocket();
				break;
			}
			else
			{
				const int last_error = WSAGetLastError();
				if (last_error == WSAEWOULDBLOCK)
				{
					Sleep(10);
					continue;
				}

				hasError = true;
				snprintf(error, sizeof(error), "recv failed: %d", last_error);
				CloseSocket();
				break;
			}
		}
		catch (const std::exception& e)
		{
			_ERROR("[Connector::_Run] %s", e.what());
		}
	}

	running.store(false);
}

std::vector<std::string> Connector::BufferSocketResponse(const char* buf, size_t buf_size)
{
	socketBuffer.append(buf, buf_size);
	std::vector<std::string> buffer_array;

	size_t index = socketBuffer.find('\0');
	while (index != std::string::npos)
	{
		buffer_array.push_back(socketBuffer.substr(0, index));
		socketBuffer = socketBuffer.substr(index + 1);
		index = socketBuffer.find('\0');
	}

	return buffer_array;
}
