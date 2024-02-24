package com.app.ohm_pad.BluetoothSupport

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresPermission
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.registerReceiver
import io.flutter.plugin.common.EventChannel
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import java.util.concurrent.TimeUnit


const val BLUETOOTH_NOT_AVAILABLE = "bluetooth_not_available"
const val BLUETOOTH_NOT_ENABLED = "bluetooth_not_enabled"
const val BLUETOOTH_INITIATED = "Bluetooth Initiated"
const val SCANNING_STARTED = "scan_started"

sealed class Result(val result:String){
    class BluetoothNotAvailable:Result(BLUETOOTH_NOT_AVAILABLE)
    class BluetoothNotEnabled:Result(BLUETOOTH_NOT_ENABLED)

    class BluetoothInitiated:Result(BLUETOOTH_INITIATED)

    class Scanning:Result(SCANNING_STARTED)
}


data class BluetoothDevices(
    val name:String,
    val address:String
)


class TypedStreamHandler <T> (val onStreamCancel:(args:Any?)->Unit = {},val getData:()->T): EventChannel.StreamHandler{

    // Handle event in main thread.
    private var timerSubscription: Disposable? = null
s
    // Declare our eventSink later it will be initialized
    private var eventSink: EventChannel.EventSink? = null
    fun EOS(){
        eventSink?.endOfStream()
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d("stream_handler", "onListen: ")
        eventSink = events
        timerSubscription = Observable
        .interval(0, 1, TimeUnit.SECONDS)
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(
            { timer: Long? ->
                //Log.e(TAG, "getDiscovering : "+mBTAdapter.isDiscovering)
                eventSink?.success(getData())
            },
            { error: Throwable ->
                eventSink?.error(
                    "STREAM",
                    "Error in processing observable",
                    error.message
                )
            }
        ) { Log.w("stream_handler", "closing the timer observable") }
    }

    override fun onCancel(arguments: Any?) {
        Log.d("stream_handler", "onCancel : $arguments")
        eventSink = null
        onStreamCancel(arguments)
        timerSubscription?.dispose()
    }

}



class BluetoothEngine(val context: Context)  {


    val bluetoothManager: BluetoothManager = context.getSystemService(BluetoothManager::class.java)
    val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.getAdapter()

    val pairedDevices = mutableMapOf<String,BluetoothDevices>()
    val discoveredDevices =  mutableMapOf<String,BluetoothDevices>()


    val pairedDevicesStream = TypedStreamHandler<List<String>> (
        getData = {
            pairedDevices.values.map { devices ->
                "${devices.name} \n ${devices.address}"
            }
        }
    )
    val discoveredDevicesStream = TypedStreamHandler<List<String>> ({ args ->
        stopScanning()
    }, {
        Log.d("stream_handler", ": $discoveredDevices")
        discoveredDevices.values.map { dv ->
            "${dv.name} \n ${dv.address}"
        }
    })


    private val deviceDiscoverReceiver = object  : BroadcastReceiver(){
        @SuppressLint("MissingPermission")
        override fun onReceive(context: Context?, intent: Intent?) {
            val action: String? = intent?.action
            Log.d("stream_handler", "broadcast : $action")
            when(action) {
                BluetoothDevice.ACTION_FOUND -> {
                    // Discovery has found a device. Get the BluetoothDevice
                    // object and its info from the Intent.
                    val device: BluetoothDevice? =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    device?.apply {
                        val deviceName = name
                        val deviceHardwareAddress = address // MAC address
                        val devices = BluetoothDevices(deviceName,deviceHardwareAddress)
                        discoveredDevices[deviceHardwareAddress] = devices
                        Log.d("stream_handler", "broadcast : $discoveredDevices")
                    }

                }
            }
        }

    }



    fun checkBluetooth():Result{
        if(bluetoothAdapter == null){
            return Result.BluetoothNotAvailable()
        }

        if (!bluetoothAdapter.isEnabled) {
            return Result.BluetoothNotEnabled()
        }


        return Result.BluetoothInitiated()

    }



    @SuppressLint("MissingPermission")
    fun scan():Result{
        val bluetoothStatus = checkBluetooth()
        if(bluetoothStatus !is Result.BluetoothInitiated){
            return bluetoothStatus
        }
        val _pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
        _pairedDevices?.forEach { device ->
            val deviceName = device.name
            val deviceHardwareAddress = device.address // MAC address
            val devices = BluetoothDevices(deviceName,deviceHardwareAddress)
            pairedDevices[deviceHardwareAddress] = devices
        }

        Log.d("stream_handler", "broadcast : $pairedDevices")


        // Register for broadcasts when a device is discovered.
        val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
        context.registerReceiver(deviceDiscoverReceiver, filter)

        return Result.Scanning()
    }


    fun terminate(){
        stopScanning()
        pairedDevicesStream.EOS()
        discoveredDevicesStream.EOS()
    }

    fun stopScanning(){
        context.unregisterReceiver(deviceDiscoverReceiver)
    }




}