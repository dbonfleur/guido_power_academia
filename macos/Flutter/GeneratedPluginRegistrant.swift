//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import desktop_window
import device_info_plus
import file_selector_macos
import shared_preferences_foundation
import sqflite
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DesktopWindowPlugin.register(with: registry.registrar(forPlugin: "DesktopWindowPlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
