//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <desktop_lifecycle/desktop_lifecycle_plugin.h>
#include <desktop_multi_window/desktop_multi_window_plugin.h>
#include <desktop_webview_auth/desktop_webview_auth_plugin.h>
#include <flutter_acrylic/flutter_acrylic_plugin.h>
#include <local_notifier/local_notifier_plugin.h>
#include <quick_notify/quick_notify_plugin.h>
#include <system_tray/system_tray_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  DesktopLifecyclePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopLifecyclePlugin"));
  DesktopMultiWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopMultiWindowPlugin"));
  DesktopWebviewAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWebviewAuthPlugin"));
  FlutterAcrylicPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAcrylicPlugin"));
  LocalNotifierPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalNotifierPlugin"));
  QuickNotifyPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QuickNotifyPlugin"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
