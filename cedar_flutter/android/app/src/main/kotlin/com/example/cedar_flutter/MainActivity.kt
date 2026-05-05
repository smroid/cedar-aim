package com.example.cedar_flutter

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val networkChannel = "cedar/network"

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, networkChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "bindToWifi" -> {
                        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                        val wifiNetwork = cm.allNetworks.firstOrNull { network ->
                            val caps = cm.getNetworkCapabilities(network)
                            caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                        }
                        cm.bindProcessToNetwork(wifiNetwork)
                        result.success(wifiNetwork != null)
                    }
                    "unbindNetwork" -> {
                        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                        cm.bindProcessToNetwork(null)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
