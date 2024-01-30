import UIKit
import Flutter
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate ,FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError?
    {
        self.eventSink1 = events
//        if self.connectnow != ""
//        {

            if self.connectedPeripharal != nil
            {
                events(true)
                print("connected \(self.connectedPeripharal.identifier.uuidString)")
                isConnecting = false
            }
        
            if !self.isConnecting
            {
                
                    events(self.peripheralsToSend)
                
            }
        return nil
        
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("On Listen Call")
//        isConnecting = false
        isScanning = true
        connectedPeripharal = nil
        return nil
    }
    
    
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var peripheralsToSend : [[String:String]] = []
    let scanningDelay = 1.0
    var METHOD_CHANNEL : FlutterMethodChannel!
    var EVENT_CHANNEL : FlutterEventChannel!
    var EVENT_CHANNEL_CONNECT : FlutterEventChannel!
    var connectedPeripharal : CBPeripheral!
    var isConnecting = false
    var isScanning = true
    private var eventSink1: FlutterEventSink?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool
  {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    METHOD_CHANNEL = FlutterMethodChannel.init(name: "flutter/ohmPadiOS", binaryMessenger: controller.binaryMessenger);
    EVENT_CHANNEL = FlutterEventChannel(name: "com.ohmPadiOS/stream", binaryMessenger: controller.binaryMessenger);
    
    EVENT_CHANNEL_CONNECT = FlutterEventChannel(name: "com.ohmPadiOS/stream_connect_request", binaryMessenger: controller.binaryMessenger);
    EVENT_CHANNEL.setStreamHandler(self)
    EVENT_CHANNEL_CONNECT.setStreamHandler(self)
    METHOD_CHANNEL.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // if ("demoFunction" == call.method) { // INFO: method check
            //     let arguments = call.arguments as! NSDictionary // INFO: get arguments
            //     demoFunction(result: result, data: arguments["data"] as! String) // INFO: method call, every method call should pass result parameter
            // } else
            if ("Discovery" == call.method) {
                print("Scan it ")
                self.startScanning()
            }
            else if ("StopDiscovery" == call.method) {
//                self.EVENT_CHANNEL.setStreamHandler(self)
                // Connect to a network with provided SSID & Password
                // This will not work, because we have no permission. So always return an error message.
                self.stopScanning()
                
            }
            else if ("ConnectToDevice" == call.method) {
                
                self.isConnecting = true
                
                if let args = call.arguments as? Dictionary<String, Any>,
                    let uuidSt = args["uuid"] as? String{
                    if let uuid = UUID(uuidString:uuidSt) {
                        if let cb = self.centralManager?.retrievePeripherals(withIdentifiers: [uuid]) {
                            if cb.count > 0 {
                                self.connectToBLE(pheripheral: cb[0])
                            }
                        }
                    }
                  } else {
                    result(FlutterError.init(code: "bad args", message: nil, details: nil))
                  }
                    
                

//                self.connectToBLE(pheripheral: CBPeripheral())
                
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        })
    centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
extension AppDelegate: CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        print("Connectionstate \(central.state)")
    }
    func startScanning() {
        connectedPeripharal = nil
        if (self.centralManager?.state == .poweredOn)
        {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    func stopScanning(){
        
        self.centralManager?.stopScan()
        
        if let eventSink = eventSink1
        {
            if !self.isConnecting {
                print("Scanning stopped now")
                eventSink(self.peripheralsToSend)
            }
            
            eventSink("Stop Scanning")
        }
        self.isScanning = false
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print(RSSI.intValue)
        
        if let ind = self.peripherals.firstIndex(where: {$0.identifier.uuidString == peripheral.identifier.uuidString}) {
            self.peripherals[ind] = peripheral
            peripheralsToSend[ind] = ["name" : peripheral.name ?? "",
                                      "id":peripheral.identifier.uuidString]
            
        }else{
            self.peripherals.append(peripheral)
            peripheralsToSend.append(["name" : peripheral.name ?? "",
                                      "id":peripheral.identifier.uuidString])
        }
        EVENT_CHANNEL.setStreamHandler(self)
    }
    func connectToBLE(pheripheral : CBPeripheral){
        self.centralManager?.connect(pheripheral, options: nil)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
                 
        connectedPeripharal = peripheral
        print("On Connected sent data to flutter ")
        if let eventSink = eventSink1 {
            eventSink(true)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
            
            didReadPeripheral(peripheral, rssi: RSSI)
            
            delay(scanningDelay){
                peripheral.readRSSI()
            }
        }
    func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber){
            if let name = peripheral.name{
                print(name)
                print(rssi)
            }
        }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
