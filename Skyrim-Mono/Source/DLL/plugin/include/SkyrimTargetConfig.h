#ifndef SKYRIM_TARGET_CONFIG_H
#define SKYRIM_TARGET_CONFIG_H

// Build target is selected via CC_TARGET_* preprocessor defines from configs/*.props

#if defined(CC_TARGET_GOG1179)
#define CC_COMPATIBLE_RUNTIME_HEX 0x010649B1 /* RUNTIME_VERSION_1_6_1179_GOG */
#define CC_LOG_RELATIVE_PATH "\\My Games\\Skyrim Special Edition\\SKSE\\CrowdControl.log"
#elif defined(CC_TARGET_OLD640)
#define CC_COMPATIBLE_RUNTIME_HEX 0x01062800 /* RUNTIME_VERSION_1_6_640 */
#define CC_LOG_RELATIVE_PATH "\\My Games\\Skyrim Special Edition\\SKSE\\CrowdControl.log"
#elif defined(CC_TARGET_VR)
#define CC_LOG_RELATIVE_PATH "\\My Games\\Skyrim VR\\SKSE\\CrowdControl.log"
#else
/* CC_TARGET_STEAM1170 (default) */
#define CC_COMPATIBLE_RUNTIME_HEX 0x01064920 /* RUNTIME_VERSION_1_6_1170 */
#define CC_LOG_RELATIVE_PATH "\\My Games\\Skyrim Special Edition\\SKSE\\CrowdControl.log"
#endif

#endif
