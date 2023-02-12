package com.huhx.deeplinks

import android.content.BroadcastReceiver
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class FlutterDeepLinksPlugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private var changeReceiver: BroadcastReceiver? = null

    private val initialLink: String? = null
    private val latestLink: String? = null
    private var context: Context? = null
    private val initialIntent = true

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.context = flutterPluginBinding.applicationContext;

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "deep_links/messages")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "deep_links/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getInitialLink" -> result.success(initialLink)
            "getLatestLink" -> result.success(latestLink)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        changeReceiver = DeepLinksBroadcastReceiver(events)
    }

    override fun onCancel(arguments: Any?) {
        changeReceiver = null
    }
}
