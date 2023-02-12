package com.huhx.deeplinks

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel.EventSink

class DeepLinksBroadcastReceiver(private val events: EventSink) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString
        if (dataString == null) {
            events.error("UNAVAILABLE", "Link unavailable", null);
        } else {
            events.success(dataString);
        }
    }
}