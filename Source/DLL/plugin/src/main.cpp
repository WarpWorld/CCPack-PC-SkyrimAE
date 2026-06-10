#include "skse64_common/skse_version.h"
#include "skse64/GameTypes.h"
#include "skse64/PapyrusNativeFunctions.h"
#include "skse64/PapyrusVM.h"
#include "skse64/PluginAPI.h"
#include "simpleini/SimpleIni.h"

#include <ShlObj.h>

#include "version.h"
#include "Connector.h"
#include "CCLog.h"
#include "GamePause.h"

#include "skse64/GameEvents.h"
#include "skse64/GameMenus.h"

#define CC_PORT "59420"

static Connector* connector = nullptr;

class MenuPauseLogSink : public BSTEventSink<MenuOpenCloseEvent>
{
public:
	EventResult ReceiveEvent(MenuOpenCloseEvent* evn, EventDispatcher<MenuOpenCloseEvent>* dispatcher) override
	{
		MenuManager* menuManager = MenuManager::GetSingleton();
		UInt32 pauseCount = 0;
		if (menuManager)
		{
			pauseCount = *reinterpret_cast<const UInt32*>(reinterpret_cast<const UInt8*>(menuManager) + 0x160);
		}

		CCLog::Write("[CC MENU] %s opening=%d pauseCount=%u nativePaused=%d",
			evn->menuName.c_str(),
			evn->opening ? 1 : 0,
			pauseCount,
			QueryNativeGamePaused() ? 1 : 0);
		return kEvent_Continue;
	}
};

static MenuPauseLogSink g_menuPauseLogSink;

static void RegisterMenuPauseLogging()
{
	MenuManager* menuManager = MenuManager::GetSingleton();
	if (menuManager)
	{
		menuManager->MenuOpenCloseEventDispatcher()->AddEventSink(&g_menuPauseLogSink);
		CCLog::Write("[CC MENU] registered native menu pause logging");
	}
}

static void SKSEMessageHandler(SKSEMessagingInterface::Message* message)
{
	if (!message)
	{
		return;
	}

	if (message->type == SKSEMessagingInterface::kMessage_PostLoadGame
		|| message->type == SKSEMessagingInterface::kMessage_NewGame
		|| message->type == SKSEMessagingInterface::kMessage_InputLoaded)
	{
		RegisterMenuPauseLogging();
	}
}

bool CrowdControlIsGamePaused(StaticFunctionTag*)
{
	return QueryNativeGamePaused();
}

BSFixedString CrowdControlCheck(StaticFunctionTag*)
{
	return BSFixedString(MYFP_VERSION_VERSTRING);
}

BSFixedString CrowdControlState(StaticFunctionTag*)
{
	if (connector == nullptr)
	{
		return BSFixedString("uninitialized");
	}
	else if (!connector->IsConnected())
	{
		return BSFixedString("disconnected");
	}
	else if (!connector->IsRunning())
	{
		return BSFixedString("stopped");
	}
	else
	{
		return BSFixedString("running");
	}
}

void CrowdControlReconnect(StaticFunctionTag*)
{
	if (connector == nullptr)
	{
		connector = new Connector();
	}

	if (!connector->IsConnected())
	{
		connector->ConnectAsync(CC_PORT);
	}
	else if (!connector->IsRunning())
	{
		connector->Run();
	}
	else
	{
		_MESSAGE("[Reconnect] Already connected");
	}
}

void CrowdControlRun(StaticFunctionTag*)
{
	if (connector == nullptr)
	{
		return;
	}

	connector->Run();
}

void CrowdControlRespond(StaticFunctionTag*, SInt32 id, SInt32 status, BSFixedString message, SInt32 miliseconds = 0)
{
	if (connector != nullptr)
	{
		connector->Respond(id, status, message, miliseconds);
	}
}

SInt32 CrowdControlItemCount(StaticFunctionTag*)
{
	if (connector == nullptr)
	{
		return 0;
	}

	return connector->GetItemCount();
}

VMResultArray<BSFixedString> CrowdControlPopItem(StaticFunctionTag*)
{
	if (connector == nullptr)
	{
		return VMResultArray<BSFixedString>();
	}

	auto item = connector->PopItem();
	if (!item)
	{
		return VMResultArray<BSFixedString>();
	}

	auto arr = VMResultArray<BSFixedString>();

	char buffer[30];
	_itoa_s(item->id, buffer, 10);
	arr.push_back(BSFixedString(buffer));

	arr.push_back(BSFixedString(item->command.c_str()));
	arr.push_back(BSFixedString(item->viewer.c_str()));

	_itoa_s(item->type, buffer, 10);
	arr.push_back(BSFixedString(buffer));

	return arr;
}

SInt32 CrowdControlHasTimer(StaticFunctionTag*, BSFixedString command_name)
{
	if (connector != nullptr)
	{
		return connector->HasTimer(command_name.c_str()) ? 1 : 0;
	}
	return 0;
}

void CrowdControlClearTimers(StaticFunctionTag*)
{
	if (connector != nullptr)
	{
		connector->ClearTimers();
	}
}

void CrowdControlSetGamePaused(StaticFunctionTag*, bool isPaused)
{
	if (connector != nullptr)
	{
		connector->SetGamePaused(isPaused);
	}
}

void CrowdControlRetryQueued(StaticFunctionTag*)
{
	if (connector != nullptr)
	{
		connector->RetryQueued();
	}
}

bool CrowdControlIsCommandFinished(StaticFunctionTag*, SInt32 command_id)
{
	if (connector == nullptr || command_id <= 0)
	{
		return true;
	}

	return connector->IsCommandFinished(static_cast<UINT>(command_id));
}

static CSimpleIniA ini;
static bool iniLoaded = false;

bool LoadIni()
{
	if (!iniLoaded)
	{
		char path[MAX_PATH];
		HRESULT error = SHGetFolderPath(NULL, CSIDL_MYDOCUMENTS | CSIDL_FLAG_CREATE, NULL, SHGFP_TYPE_CURRENT, path);
		if (SUCCEEDED(error))
		{
			strcat_s(path, sizeof(path), "\\My Games\\Skyrim Special Edition\\CrowdControl.ini");
			const SI_Error loadError = ini.LoadFile(path);
			if (loadError < 0)
			{
				return false;
			}
			iniLoaded = true;
		}
		else
		{
			_ERROR("Getting path to Crowd Control ini failed (result = %08X lasterr = %08X)", error, GetLastError());
			return false;
		}
	}

	return true;
}

SInt32 GetIntSetting(StaticFunctionTag*, BSFixedString section, BSFixedString key)
{
	if (!LoadIni())
	{
		return 0;
	}
	return static_cast<SInt32>(ini.GetLongValue(section, key, 0));
}

float GetFloatSetting(StaticFunctionTag*, BSFixedString section, BSFixedString key)
{
	if (!LoadIni())
	{
		return 0.0f;
	}
	return static_cast<float>(ini.GetDoubleValue(section, key, 0.0));
}

bool RegisterFuncs(VMClassRegistry* a_registry)
{
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, BSFixedString>("CC_Version", "CrowdControl", CrowdControlCheck, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, BSFixedString>("CC_GetState", "CrowdControl", CrowdControlState, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, void>("CC_Reconnect", "CrowdControl", CrowdControlReconnect, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, void>("CC_Run", "CrowdControl", CrowdControlRun, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, SInt32>("CC_GetItemCount", "CrowdControl", CrowdControlItemCount, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, VMResultArray<BSFixedString>>("CC_PopItem", "CrowdControl", CrowdControlPopItem, a_registry));
	a_registry->RegisterFunction(new NativeFunction4<StaticFunctionTag, void, SInt32, SInt32, BSFixedString, SInt32>("CC_Respond", "CrowdControl", CrowdControlRespond, a_registry));
	a_registry->RegisterFunction(new NativeFunction1<StaticFunctionTag, SInt32, BSFixedString>("CC_HasTimer", "CrowdControl", CrowdControlHasTimer, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, void>("CC_ClearTimers", "CrowdControl", CrowdControlClearTimers, a_registry));
	a_registry->RegisterFunction(new NativeFunction1<StaticFunctionTag, void, bool>("CC_SetGamePaused", "CrowdControl", CrowdControlSetGamePaused, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, bool>("CC_IsGamePaused", "CrowdControl", CrowdControlIsGamePaused, a_registry));
	a_registry->RegisterFunction(new NativeFunction0<StaticFunctionTag, void>("CC_RetryQueued", "CrowdControl", CrowdControlRetryQueued, a_registry));
	a_registry->RegisterFunction(new NativeFunction1<StaticFunctionTag, bool, SInt32>("CC_IsCommandFinished", "CrowdControl", CrowdControlIsCommandFinished, a_registry));
	a_registry->RegisterFunction(new NativeFunction2<StaticFunctionTag, SInt32, BSFixedString, BSFixedString>("CC_GetIntSetting", "CrowdControl", GetIntSetting, a_registry));
	a_registry->RegisterFunction(new NativeFunction2<StaticFunctionTag, float, BSFixedString, BSFixedString>("CC_GetFloatSetting", "CrowdControl", GetFloatSetting, a_registry));

	return true;
}


extern "C" {
	__declspec(dllexport) SKSEPluginVersionData SKSEPlugin_Version =
	{
		SKSEPluginVersionData::kVersion,

		1,
		"Skyrim Crowd Control",

		"dtothefourth",
		"dtothefourth@gmail.com",

		0,
		0,

		{ RUNTIME_VERSION_1_6_1170, 0 },

		0,
	};

	bool SKSEPlugin_Query(const SKSEInterface* a_skse, PluginInfo* a_info)
	{
		CCLog::Init();
		CCLog::Write("CrowdControl v%s (Query)", MYFP_VERSION_VERSTRING);

		gLog.OpenRelative(CSIDL_MYDOCUMENTS, "\\My Games\\Skyrim Special Edition\\SKSE\\CrowdControl.log");
		gLog.SetPrintLevel(IDebugLog::kLevel_DebugMessage);
		gLog.SetLogLevel(IDebugLog::kLevel_DebugMessage);

		_MESSAGE("CrowdControl v%s", MYFP_VERSION_VERSTRING);

		a_info->infoVersion = PluginInfo::kInfoVersion;
		a_info->name = "CrowdControl";
		a_info->version = MYFP_VERSION_MAJOR;

		if (a_skse->isEditor) {
			_FATALERROR("[FATAL ERROR] Loaded in editor, marking as incompatible!\n");
			return false;
		}

		return true;
	}


	bool SKSEPlugin_Load(const SKSEInterface* a_skse)
	{
		CCLog::Write("CrowdControl plugin loaded (Load)");
		_MESSAGE("CrowControlPlugin loaded");

		try
		{
			connector = new Connector();

			SKSEPapyrusInterface* papyrus = (SKSEPapyrusInterface*)a_skse->QueryInterface(kInterface_Papyrus);
			if (!papyrus)
			{
				_ERROR("[SKSEPlugin_Load] Failed to query Papyrus interface");
				return false;
			}

			papyrus->Register(RegisterFuncs);

			const SKSEMessagingInterface* messaging = (SKSEMessagingInterface*)a_skse->QueryInterface(kInterface_Messaging);
			if (messaging)
			{
				messaging->RegisterListener(a_skse->GetPluginHandle(), "SKSE", SKSEMessageHandler);
			}

			RegisterMenuPauseLogging();
			connector->ConnectAsync(CC_PORT);
		}
		catch (const std::exception& e)
		{
			_ERROR("[SKSEPlugin_Load] %s", e.what());
		}

		return true;
	}
};
