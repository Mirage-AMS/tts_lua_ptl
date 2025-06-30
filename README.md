# TTS_LUA_PTL
TTS_LUA_PTL 是一个由Lua编写的项目，用于在Tabletop Simulator框架下构建Path Towards Legendary模组的自动化脚本

# 项目结构
./com 公共方法对应的Lua文件
./mock 模拟TTS的API，用于测试和开发
./src 模组核心逻辑对应的Lua文件
./main.lua 模组入口文件
./README.md 说明文档

# 开发环境
Lua 5.2
VS Code
tts_lua_builder (https://github.com/Mirage-AMS/tts_lua_builder)

# 构建
使用tts_lua_builder将项目构建为可用的脚本文件，
并将构建后的.mod文件导入Tabletop Simulator，然后在游戏中加载该模组即可开始游戏。

# 贡献者
Mirage-AMS (https://github.com/Mirage-AMS)

# 许可证
GPL-3.0