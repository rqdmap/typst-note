#!/bin/bash
GIT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_DATE=$(git log -1 --format=%cd --date=short 2>/dev/null || echo "unknown")

# 将版本信息输出到命令行
echo "git_version:$GIT_VERSION"
echo "git_commit:$GIT_COMMIT"
echo "git_date:$GIT_DATE"
