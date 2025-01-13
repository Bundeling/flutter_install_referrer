package com.bundeling.flutter_install_referrer

import android.content.Context
import androidx.annotation.NonNull
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener
import com.android.installreferrer.api.ReferrerDetails

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterInstallReferrerPlugin */
class FlutterInstallReferrerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var installReferrerClient: InstallReferrerClient

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_install_referrer")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getInstallReferrer") {
            getInstallReferrer(result)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getInstallReferrer(result: Result) {
        installReferrerClient = InstallReferrerClient.newBuilder(context).build()
        installReferrerClient.startConnection(object : InstallReferrerStateListener {
            override fun onInstallReferrerSetupFinished(responseCode: Int) {
                when (responseCode) {
                    InstallReferrerClient.InstallReferrerResponse.OK -> {
                        try {
                            val response: ReferrerDetails = installReferrerClient.installReferrer
                            val referrerUrl = response.installReferrer
                            val clickTimestamp = response.referrerClickTimestampSeconds
                            val installTimestamp = response.installBeginTimestampSeconds
                            val googlePlayInstantParam = response.googlePlayInstantParam

                            installReferrerClient.endConnection()
                            result.success(
                                mapOf(
                                    "installReferrer" to referrerUrl,
                                    "referrerClickTimestamp" to clickTimestamp,
                                    "installBeginTimestamp" to installTimestamp,
                                    "googlePlayInstantParam" to googlePlayInstantParam,
                                )
                            )
                        } catch (e: Exception) {
                            result.error("REFERRER_ERROR", e.message, null)
                        }
                    }
                    InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED ->
                        result.error("FEATURE_NOT_SUPPORTED", "Install Referrer API not supported", null)
                    InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE ->
                        result.error("SERVICE_UNAVAILABLE", "Unable to connect to the service", null)
                    else -> result.error("UNKNOWN_ERROR", "Unknown error occurred", null)
                }
            }

            override fun onInstallReferrerServiceDisconnected() {
                // Handle service disconnection if necessary
            }
        })
    }
}
