package com.dnieln7.flutter_kotlin

import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "com.dnieln7.native-functions/battery"
        ).setMethodCallHandler { call, result ->
            if (call.method.equals("getBatteryLevelK")) {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error(
                            "UNAVAILABLE",
                            "Could not fetch battery level",
                            null
                    )
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        var batteryLevel = -1

        val batteryManager: BatteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        return batteryLevel
    }
}
