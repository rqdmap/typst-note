# 定义变量和目标
.PHONY: all main clean git_log.json

# 获取 Git 版本信息
GIT_VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_DATE := $(shell git log -1 --format=%cd --date=short 2>/dev/null || echo "unknown")

all: main

# 获取 Git 提交历史并生成 JSON 文件
git_log.json:
	@echo '[' > git_log.json
	@git log --pretty=format:'{"hash":"%h","time":"%cd","msg":"%s"},' --date=format:"%Y-%m-%d %H:%M:%S" | sed '$$s/,$$//' >> git_log.json
	@echo ']' >> git_log.json

# 主要编译目标
main: git_log.json
	typst compile main.typ

# 清理目标
clean:
	rm -f output.pdf git_log.json
