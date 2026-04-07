import Flutter
import UIKit
import flutter_downloader
import Firebase
import FirebaseMessaging
import flutter_local_notifications
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

      if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
        // We have a link, propagate it to your Flutter app or not
        AppLinks.shared.handleLink(url: url)
        return true // Returning true will stop the propagation to other packages
      }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
