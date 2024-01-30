package com.app.ohm_pad

import android.bluetooth.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.*
import android.util.Log
import android.widget.Toast
import com.app.ohm_pad.bluetooth_headset_connectivity.IBluetoothA2dp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import java.io.UnsupportedEncodingException
import java.lang.reflect.Method
import java.util.*
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {

    private val BT_MODULE_UUID =
        UUID.fromString("00001101-0000-1000-8000-00805F9B34FB") // "random" unique identifier


    // #defines for identifying shared types between calling functions
    private val REQUEST_ENABLE_BT = 1 // used to identify adding bluetooth names

    val MESSAGE_READ = 2 // used in bluetooth handler to identify message update

    private val CONNECTING_STATUS = 3 // used in bluetooth handler to identify message status


    val TAG = "TAG"
    val STREAM = "com.ohmPad/stream"
    val STREAM_CONNECT_REQUEST = "com.ohmPad/stream_connect_request"
    val CHANNEL = "com.ohmPad/OhmPadChannel"
    private var timerSubscription: Disposable? = null
    private var timerSubscription1: Disposable? = null


    private val mBTAdapter =
        BluetoothAdapter.getDefaultAdapter() // get a handle on the bluetooth radio

    private var detectedDevices = mutableListOf<BluetoothDevice>()
    private val discoveryDeviceList = HashSet<String>()
    private val temp = ArrayList<String>()

    private var mHandler // Our main handler that will receive callback notifications
            : Handler? = null
    private var mConnectedThread // bluetooth background worker thread to send and receive data
            : ConnectedThread? = null
    private var mBTSocket: BluetoothSocket? = null // bi-directional client-to-client data path


    private var mIsA2dpReady = false
    private var b: IBinder? = null
    private lateinit var a2dp: BluetoothA2dp  //class to connect to an A2dp device
    private lateinit var ia2dp: IBluetoothA2dp
    private var isDeviceConnect: Boolean? = null
    var selectedBleDevice: BluetoothDevice? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.e(TAG, "onCreate")
        /*mHandler = object : Handler(Looper.getMainLooper()) {
            override fun handleMessage(msg: Message) {
                if (msg.what == MESSAGE_READ) {
                    var readMessage: String? = null
                    try {
                        readMessage = String((msg.obj as ByteArray))
                        //readMessage = String((msg.obj as ByteArray),"UTF-8")
                    } catch (e: UnsupportedEncodingException) {
                        e.printStackTrace()
                    }
                    //mReadBuffer.setText(readMessage);
                }
                if (msg.what == CONNECTING_STATUS) {
                    if (msg.arg1 == 1) Log.e(TAG, "Connected to Device: " + msg.obj) else Log.e(TAG, "Connection Failed")
                }
            }
        }*/
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            STREAM_CONNECT_REQUEST
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {

                Log.e(TAG, "EventChannel started $STREAM_CONNECT_REQUEST")

                timerSubscription1 = Observable
                    .interval(0, 1, TimeUnit.SECONDS)
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(
                        { timer: Long? ->
                            //Log.e(TAG, "getDiscovering : "+mBTAdapter.isDiscovering)
                            if (isDeviceConnect != null)
                                events?.success(isDeviceConnect)
                        },
                        { error: Throwable ->
                            events?.error(
                                "STREAM",
                                "Error in processing observable",
                                error.message
                            )
                        }
                    ) { Log.w(TAG, "closing the timer observable") }

            }

            override fun onCancel(arguments: Any?) {
                if (timerSubscription1 != null) {
                    timerSubscription1!!.dispose()
                    timerSubscription1 = null
                }
            }

        })

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink) {

                    Log.e(TAG, "EventChannel started")

                    timerSubscription = Observable
                        .interval(0, 1, TimeUnit.SECONDS)
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(
                            { timer: Long? ->
                                //Log.e(TAG, "getDiscovering : "+mBTAdapter.isDiscovering)
                                if (!mBTAdapter.isDiscovering) {
                                    events.success("Stop Scanning")
                                    return@subscribe
                                }

                                temp.clear()
                                temp.addAll(discoveryDeviceList)
                                events.success(temp)
                            },
                            { error: Throwable ->
                                events.error(
                                    "STREAM",
                                    "Error in processing observable",
                                    error.message
                                )
                            }
                        ) { Log.w(TAG, "closing the timer observable") }
                }

                override fun onCancel(arguments: Any?) {
                    Log.e(TAG, "EventChannel stop")
                    if (timerSubscription != null) {
                        timerSubscription!!.dispose()
                        timerSubscription = null
                    }
                }
            }
        )


        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method.equals("Discovery", ignoreCase = true)) {
                Log.e(TAG, "discovery started")
                discoveryDeviceList.clear()
                detectedDevices.clear()
                discover()
                result.success("discovery started")
            } else if (call.method.equals("CheckConnected", ignoreCase = true)) {
                var connected: Boolean = isBluetoothHeadsetConnected()
                result.success(connected)
            } else if (call.method.equals("StopDiscovery", ignoreCase = true)) {
                stopDiscovery()
            } else if (call.method.equals("ConnectToDevice", ignoreCase = true)) {
                Log.e(TAG, "Connect " + call.argument<Any>("text"))
                connectToDevice(call.argument<Any>("text") as String)
                result.success("Connecting")
            }
        }
    }

    private fun stopDiscovery() {
        Log.e(TAG, "stopDiscovery()")
        discoveryDeviceList.clear()
        detectedDevices.clear()
        if (mBTAdapter.isDiscovering) {
            mBTAdapter.cancelDiscovery()
        }
    }

    private fun getDiscovering(): Boolean {
        if (mBTAdapter != null)
            return mBTAdapter.isDiscovering
        return true
    }


    val blReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (BluetoothDevice.ACTION_FOUND == action) {
                val device =
                    intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                // add the name to the list
                Log.e(TAG, """Device : ${device!!.name}$ {device.address}""".trimIndent())
                discoveryDeviceList.add("${device.name} \n ${device.address}")
                detectedDevices.add(device)
            }
        }
    }

    private fun discover() {
        // Check if the device is already discovering
        if (mBTAdapter.isDiscovering) {
            mBTAdapter.cancelDiscovery()
            Log.e(TAG, "Discovery stopped")
            Toast.makeText(applicationContext, "Discovery stopped", Toast.LENGTH_SHORT).show()
        } else {
            if (mBTAdapter.isEnabled) {
                mBTAdapter.startDiscovery()
                Log.e(TAG, "Discovery started")
                Toast.makeText(applicationContext, "Discovery started", Toast.LENGTH_SHORT).show()
                registerReceiver(blReceiver, IntentFilter(BluetoothDevice.ACTION_FOUND))
            } else {
                Log.e(TAG, "Bluetooth not on")
                Toast.makeText(applicationContext, "Bluetooth not on", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun connectToDevice(info: String) {
        isDeviceConnect = null
        if (!mBTAdapter.isEnabled) {
            Toast.makeText(baseContext, "Bluetooth not on", Toast.LENGTH_SHORT).show()
            return
        }

        // Get the device MAC address, which is the last 17 chars in the View
        val address = info.substring(info.length - 17)
        val name = info.substring(0, info.length - 17)

        //find ble device
        for (item in detectedDevices) {
            if (item.address == address) {
                selectedBleDevice = item
                break
            }
        }

        if(selectedBleDevice?.bondState == BluetoothDevice.BOND_BONDED) {
            connectUsingBluetoothA2dp(selectedBleDevice)
        } else {
            createBond(btDevice = selectedBleDevice)
        }
        /*try {
            Log.e("Log", "The bond is : " + (selectedBleDevice?.createBond() )) //work in ios
        } catch (e: java.lang.Exception) {
            Log.e("Log", "The bond is Exception: " + e.cause)
        }*/

        // Spawn a new thread to avoid blocking the GUI one
        /*object : Thread() {
            override fun run() {
                var fail = false
                val device = mBTAdapter.getRemoteDevice(address)
                try {
                    mBTSocket = createBluetoothSocket(device)
                } catch (e: IOException) {
                    fail = true
                    Toast.makeText(baseContext, "Socket creation failed", Toast.LENGTH_SHORT).show()
                }
                // Establish the Bluetooth socket connection.
                try {
                    mBTSocket!!.connect()
                } catch (e: IOException) {
                    try {
                        fail = true
                        mBTSocket!!.close()
                        mHandler!!.obtainMessage(CONNECTING_STATUS, -1, -1)
                                .sendToTarget()
                    } catch (e2: IOException) {
                        //insert code to deal with this
                        Toast.makeText(baseContext, "Socket creation failed", Toast.LENGTH_SHORT).show()
                    }
                }
                if (!fail) {
                    mConnectedThread = ConnectedThread(mBTSocket, mHandler)
                    mConnectedThread!!.start()
                    mHandler!!.obtainMessage(CONNECTING_STATUS, 1, -1, name).sendToTarget()
                }

                connectUsingBluetoothA2dp(device)
            }
        }.start()*/
    }


    private fun createBluetoothSocket(device: BluetoothDevice): BluetoothSocket? {
        try {
            val m = device.javaClass.getMethod(
                "createInsecureRfcommSocketToServiceRecord",
                UUID::class.java
            )
            return m.invoke(device, BT_MODULE_UUID) as BluetoothSocket
        } catch (e: Exception) {
            Log.e(TAG, "Could not create Insecure RFComm Connection", e)
        }
        return device.createRfcommSocketToServiceRecord(BT_MODULE_UUID)
    }

    fun connectUsingBluetoothA2dp(
        deviceToConnect: BluetoothDevice?
    ) {
        try {
            val c2 = Class.forName("android.os.ServiceManager")
            val m2: Method = c2.getDeclaredMethod("getService", String::class.java)
            b = m2.invoke(c2.newInstance(), "bluetooth_a2dp") as IBinder?
            if (b == null) {
                // For Android 4.2 Above Devices
                val device: BluetoothDevice = deviceToConnect!!
                //establish a connection to the profile proxy object associated with the profile
                BluetoothAdapter.getDefaultAdapter().getProfileProxy(
                    this,
                    // listener notifies BluetoothProfile clients when they have been connected to or disconnected from the service
                    object : BluetoothProfile.ServiceListener {
                        override fun onServiceDisconnected(profile: Int) {
                            isDeviceConnect = false
                            setIsA2dpReady(false)
                            disConnectUsingBluetoothA2dp(device)
                        }

                        override fun onServiceConnected(
                            profile: Int,
                            proxy: BluetoothProfile
                        ) {
                            isDeviceConnect = true
                            a2dp = proxy as BluetoothA2dp
                            try {
                                //establishing bluetooth connection with A2DP devices
                                a2dp.javaClass.getMethod("connect", BluetoothDevice::class.java)
                                    .invoke(a2dp, deviceToConnect)
                            } catch (e: Exception) {
                                e.printStackTrace()
                            }
                            setIsA2dpReady(true)
                        }
                    }, BluetoothProfile.A2DP
                )
            } else {
                val c3 =
                    Class.forName("android.bluetooth.IBluetoothA2dp")
                val s2 = c3.declaredClasses
                val c = s2[0]
                val m: Method = c.getDeclaredMethod("asInterface", IBinder::class.java)
                m.isAccessible = true
                ia2dp = m.invoke(null, b) as IBluetoothA2dp
                ia2dp!!.connect(deviceToConnect)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun setIsA2dpReady(ready: Boolean) {
        mIsA2dpReady = ready
    }

    fun disConnectUsingBluetoothA2dp(
        deviceToConnect: BluetoothDevice?
    ) {
        try {
            // For Android 4.2 Above Devices
            if (b == null) {
                try {
                    //disconnecting bluetooth device
                    a2dp.javaClass.getMethod(
                        "disconnect",
                        BluetoothDevice::class.java
                    ).invoke(a2dp, deviceToConnect)
                    BluetoothAdapter.getDefaultAdapter()
                        .closeProfileProxy(BluetoothProfile.A2DP, a2dp)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else {
                ia2dp.disconnect(deviceToConnect)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun createBond(btDevice: BluetoothDevice?) {
        try {
            val class1 = Class.forName("android.bluetooth.BluetoothDevice")
            val createBondMethod = class1.getMethod("createBond")
            val returnValue = createBondMethod.invoke(btDevice) as Boolean
            Log.e("TAG", "createBond $returnValue")
        } catch (e: java.lang.Exception) {
            Log.e("TAG", "Exception createBond " + e.localizedMessage)
        }
    }

    fun isBluetoothHeadsetConnected(): Boolean {
        val mBluetoothAdapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        return (mBluetoothAdapter != null && mBluetoothAdapter.isEnabled()
                && mBluetoothAdapter.getProfileConnectionState(BluetoothHeadset.HEADSET) === BluetoothHeadset.STATE_CONNECTED)
    }

    private val mPairReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            try {
                val action = intent.action
                if (BluetoothDevice.ACTION_BOND_STATE_CHANGED == action) {
                    val state =
                        intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothDevice.ERROR)
                    val prevState = intent.getIntExtra(
                        BluetoothDevice.EXTRA_PREVIOUS_BOND_STATE,
                        BluetoothDevice.ERROR
                    )
                    Log.e("Log", "state $state")
                    if (state == BluetoothDevice.BOND_BONDED && prevState == BluetoothDevice.BOND_BONDING) {
                        Log.e("Log", "Paired")
                        connectUsingBluetoothA2dp(selectedBleDevice)
                    } else if (state == BluetoothDevice.BOND_NONE && prevState == BluetoothDevice.BOND_BONDED) {
                        Log.e("Log", "Unpaired")
                    }
                }
            } catch (e: java.lang.Exception) {
                Log.e("Log", "Error : ${e.localizedMessage}")
            }
        }
    }

    override fun onStart() {
        super.onStart()
        val intent = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        registerReceiver(mPairReceiver, intent)
    }

    override fun onDestroy() {
        try {
            disConnectUsingBluetoothA2dp(selectedBleDevice)
            unregisterReceiver(mPairReceiver)
            unregisterReceiver(blReceiver)
        } catch (e: Exception) {
            Log.d("Error",e.message.toString())
        }
        super.onDestroy()
    }
}
