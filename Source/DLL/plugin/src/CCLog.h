#pragma once

#include <cstdarg>

namespace CCLog
{
	void Init();
	void Write(const char* fmt, ...);
}
