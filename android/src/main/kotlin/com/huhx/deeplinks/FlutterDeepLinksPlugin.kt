package com.huhx.deeplinks

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class FlutterDeepLinksPlugin : FlutterPlugin, MethodCallHandler, StreamHandler, ActivityAware, PluginRegistry.NewIntentListener {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private var changeReceiver: BroadcastReceiver? = null

    private var initialLink: String? = null
    private var latestLink: String? = null
    private var context: Context? = null
    private var isInitialIntent = true

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.context = flutterPluginBinding.applicationContext

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

    private fun handleIntent(context: Context, intent: Intent) {
        val action = intent.action
        val dataString = intent.dataString

        if (action.equals(Intent.ACTION_VIEW)) {
            if (isInitialIntent) {
                initialLink = dataString
                isInitialIntent = false
            }
            latestLink = dataString
            changeReceiver?.onReceive(context, intent)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(this)
        this.handleIntent(this.context!!, binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(this)
        this.handleIntent(this.context!!, binding.activity.intent)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onNewIntent(intent: Intent): Boolean {
        this.handleIntent(context!!, intent)
        return false
    }
}
