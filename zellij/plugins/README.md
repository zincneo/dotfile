# Zellij plugins

本目录集中保存 Zellij 使用的本地 WASM 插件。

## zjstatus

- 用途：底部可配置状态栏
- 下载地址：<https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm>
- 当前文件：`zjstatus.wasm`
- SHA-256：`1ccedece1ded62cf3e209be690cdd39ca6fb9e8228ed71a951f6507f9956669b`
- 使用布局：`layouts/zjstatus_layout.kdl`

## zjframes

- 用途：按条件显示或隐藏 pane 边框
- 下载地址：<https://github.com/dj95/zjstatus/releases/latest/download/zjframes.wasm>
- 当前文件：`zjframes.wasm`
- SHA-256：`044ed6c1784ee98c6d22ba7530644dc16c7ee2d1681c34ee603237358e123bda`
- 加载位置：`config.kdl` 的 `load_plugins` 块

## 更新插件

```bash
curl -fL -o ~/.config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

curl -fL -o ~/.config/zellij/plugins/zjframes.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjframes.wasm
```
