import Flutter
import UIKit

public class FlutterDeepLinksPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    fileprivate var eventSink: FlutterEventSink?
    fileprivate var initialLink: String?
    fileprivate var latestLink: String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "deep_links/messages", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "deep_links/events", binaryMessenger: registrar.messenger())
        
        let instance = FlutterDeepLinksPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInitialLink":
            result(initialLink)
            break
        case "getLatestLink":
            result(latestLink)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    public func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]) -> Void) -> Bool {
            
            switch userActivity.activityType {
            case NSUserActivityTypeBrowsingWeb:
                guard let url = userActivity.webpageURL else {
                    return false
                }
                handleLink(url: url)
                return false
            default: return false
            }
        }
    
    public func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            
            handleLink(url: url)
            return false
        }
    
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            
            self.eventSink = events
            return nil
        }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    fileprivate func handleLink(url: URL) -> Void {
        let link = url.absoluteString
        
        debugPrint("iOS handleLink: \(link)")
        
        latestLink = link
        
        if (initialLink == nil) {
            initialLink = link
        }
        
        guard let _eventSink = eventSink, latestLink != nil else {
            return
        }
        
        _eventSink(latestLink)
    }
}
