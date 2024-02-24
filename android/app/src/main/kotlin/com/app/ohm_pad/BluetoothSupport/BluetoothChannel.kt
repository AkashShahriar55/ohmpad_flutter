package com.app.ohm_pad.BluetoothSupport

import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.OnLifecycleEvent
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import com.app.ohm_pad.BluetoothSupport.BluetoothEngine
import android.content.Context
import android.widget.Toast
import io.flutter.plugin.common.EventChannel
import androidx.annotation.RequiresPermission

const val BlUETOOTH_CHANNEL = "com.ohmPad/bluetooth_channel"
const val METHOD_DISCOVERY = "Discovery"
const val METHOD_CHECK_CONNECTED = "CheckConnected"
const val METHOD_STOP_DISCOVERY = "StopDiscovery"
const val METHOD_CONNECT_DEVICE = "ConnectToDevice"


const val STREAM_PAIRED_DEVICE = "com.ohmPad/paired_device_stream_request"
const val STREAM_DISCOVERED_DEVICE = "com.ohmPad/discovered_device_stream_request"
class BluetoothChannel private constructor(val executor:DartExecutor,context:Context):LifecycleObserver {




    val bluetoothEngine:BluetoothEngine = BluetoothEngine(context)


    init {
        MethodChannel(executor, BlUETOOTH_CHANNEL).setMethodCallHandler { call, result ->
            when(call.method){
                METHOD_DISCOVERY ->{
                    val status = bluetoothEngine.scan()
                    Toast.makeText(context, status.result,Toast.LENGTH_LONG).show()
                    when(status){
                        is Result.Scanning -> result.success(status.result)
                        is Result.BluetoothNotEnabled -> result.error("bluetooth_not_available","Bluetooth not available",null)
                        is Result.BluetoothNotAvailable -> result.error("bluetooth_not_enabled","Bluetooth not enabled",null)
                        else -> {
                            result.error("unknown","unknown error",null)
                        }
                    }
                }
                METHOD_CHECK_CONNECTED -> {

                }
                METHOD_STOP_DISCOVERY ->{

                }
                METHOD_CONNECT_DEVICE ->{

                }
                METHOD_CHECK_CONNECTED ->{

                }
            }

        }

        EventChannel(
            executor.binaryMessenger,
            STREAM_PAIRED_DEVICE
        ).setStreamHandler(bluetoothEngine.pairedDevicesStream)

        EventChannel(
            executor.binaryMessenger,
            STREAM_DISCOVERED_DEVICE
        ).setStreamHandler(bluetoothEngine.discoveredDevicesStream)

    }


    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    fun onCreate() {
        // This method is called when the lifecycle owner is created
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onStart() {
        // This method is called when the lifecycle owner is started
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    fun onResume() {
        // This method is called when the lifecycle owner is resumed
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun onPause() {
        // This method is called when the lifecycle owner is paused
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onStop() {
        // This method is called when the lifecycle owner is stopped
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onDestroy() {
        bluetoothEngine.terminate()
    }

    companion object{
        @RequiresPermission("android.permission.BLUETOOTH_CONNECT")
        fun init(executor:DartExecutor,lifecycle: Lifecycle,context:Context){
            val instance = BluetoothChannel(executor,context)
            lifecycle.addObserver(instance)
        }
    }


}