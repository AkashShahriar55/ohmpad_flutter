/*
 * This file is auto-generated.  DO NOT MODIFY.
 */
package com.app.ohm_pad.bluetooth_headset_connectivity;
public interface IBluetoothA2dp extends android.os.IInterface
{
  /** Default implementation for IBluetoothA2dp. */
  public static class Default implements IBluetoothA2dp
  {
    /**
         * System private API for Bluetooth A2DP service
         */
    @Override
    public boolean connectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // Pre API 11 only

    @Override
    public boolean disconnectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // Pre API 11 only

    @Override
    public boolean connect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // API 11 and up only

    @Override
    public boolean disconnect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // API 11 and up only

    @Override
    public boolean suspendSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // all

    @Override
    public boolean resumeSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    // all

    @Override
    public android.bluetooth.BluetoothDevice[] getConnectedSinks() throws android.os.RemoteException
    {
      return null;
    }
    // change to Set<> once AIDL supports, pre API 11 only

    @Override
    public android.bluetooth.BluetoothDevice[] getNonDisconnectedSinks() throws android.os.RemoteException
    {
      return null;
    }
    // change to Set<> once AIDL supports,

    @Override
    public int getSinkState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return 0;
    }
    // pre API 11 only

    @Override
    public int getConnectionState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return 0;
    }
    // API 11 and up

    @Override
    public boolean setSinkPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException
    {
      return false;
    }
    // Pre API 11 only

    @Override
    public boolean setPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException
    {
      return false;
    }
    // API 11 and up only

    @Override
    public int getPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return 0;
    }
    // API 11 and up only

    @Override
    public int getSinkPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return 0;
    }
    // Pre API 11 only

    @Override
    public boolean isA2dpPlaying(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
    {
      return false;
    }
    @Override
    public android.os.IBinder asBinder() {
      return null;
    }
  }
  /** Local-side IPC implementation stub class. */
  public static abstract class Stub extends android.os.Binder implements IBluetoothA2dp
  {
    private static final String DESCRIPTOR = "IBluetoothA2dp";
    /** Construct the stub at attach it to the interface. */
    public Stub()
    {
      this.attachInterface(this, DESCRIPTOR);
    }
    /**
     * Cast an IBinder object into an IBluetoothA2dp interface,
     * generating a proxy if needed.
     */
    public static IBluetoothA2dp asInterface(android.os.IBinder obj)
    {
      if ((obj==null)) {
        return null;
      }
      android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
      if (((iin!=null)&&(iin instanceof IBluetoothA2dp))) {
        return ((IBluetoothA2dp)iin);
      }
      return new Proxy(obj);
    }
    @Override
    public android.os.IBinder asBinder()
    {
      return this;
    }
    @Override
    public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
    {
      String descriptor = DESCRIPTOR;
      switch (code)
      {
        case INTERFACE_TRANSACTION:
        {
          reply.writeString(descriptor);
          return true;
        }
        case TRANSACTION_connectSink:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.connectSink(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_disconnectSink:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.disconnectSink(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_connect:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.connect(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_disconnect:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.disconnect(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_suspendSink:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.suspendSink(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_resumeSink:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.resumeSink(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_getConnectedSinks:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice[] _result = this.getConnectedSinks();
          reply.writeNoException();
          reply.writeTypedArray(_result, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
          return true;
        }
        case TRANSACTION_getNonDisconnectedSinks:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice[] _result = this.getNonDisconnectedSinks();
          reply.writeNoException();
          reply.writeTypedArray(_result, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
          return true;
        }
        case TRANSACTION_getSinkState:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _result = this.getSinkState(_arg0);
          reply.writeNoException();
          reply.writeInt(_result);
          return true;
        }
        case TRANSACTION_getConnectionState:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _result = this.getConnectionState(_arg0);
          reply.writeNoException();
          reply.writeInt(_result);
          return true;
        }
        case TRANSACTION_setSinkPriority:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _arg1;
          _arg1 = data.readInt();
          boolean _result = this.setSinkPriority(_arg0, _arg1);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_setPriority:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _arg1;
          _arg1 = data.readInt();
          boolean _result = this.setPriority(_arg0, _arg1);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        case TRANSACTION_getPriority:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _result = this.getPriority(_arg0);
          reply.writeNoException();
          reply.writeInt(_result);
          return true;
        }
        case TRANSACTION_getSinkPriority:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          int _result = this.getSinkPriority(_arg0);
          reply.writeNoException();
          reply.writeInt(_result);
          return true;
        }
        case TRANSACTION_isA2dpPlaying:
        {
          data.enforceInterface(descriptor);
          android.bluetooth.BluetoothDevice _arg0;
          if ((0!=data.readInt())) {
            _arg0 = android.bluetooth.BluetoothDevice.CREATOR.createFromParcel(data);
          }
          else {
            _arg0 = null;
          }
          boolean _result = this.isA2dpPlaying(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          return true;
        }
        default:
        {
          return super.onTransact(code, data, reply, flags);
        }
      }
    }
    private static class Proxy implements IBluetoothA2dp
    {
      private android.os.IBinder mRemote;
      Proxy(android.os.IBinder remote)
      {
        mRemote = remote;
      }
      @Override
      public android.os.IBinder asBinder()
      {
        return mRemote;
      }
      public String getInterfaceDescriptor()
      {
        return DESCRIPTOR;
      }
      /**
           * System private API for Bluetooth A2DP service
           */
      @Override
      public boolean connectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_connectSink, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().connectSink(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // Pre API 11 only

      @Override
      public boolean disconnectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_disconnectSink, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().disconnectSink(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // Pre API 11 only

      @Override
      public boolean connect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_connect, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().connect(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // API 11 and up only

      @Override
      public boolean disconnect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_disconnect, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().disconnect(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // API 11 and up only

      @Override
      public boolean suspendSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_suspendSink, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().suspendSink(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // all

      @Override
      public boolean resumeSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_resumeSink, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().resumeSink(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // all

      @Override
      public android.bluetooth.BluetoothDevice[] getConnectedSinks() throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        android.bluetooth.BluetoothDevice[] _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          boolean _status = mRemote.transact(Stub.TRANSACTION_getConnectedSinks, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getConnectedSinks();
          }
          _reply.readException();
          _result = _reply.createTypedArray(android.bluetooth.BluetoothDevice.CREATOR);
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // change to Set<> once AIDL supports, pre API 11 only

      @Override
      public android.bluetooth.BluetoothDevice[] getNonDisconnectedSinks() throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        android.bluetooth.BluetoothDevice[] _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          boolean _status = mRemote.transact(Stub.TRANSACTION_getNonDisconnectedSinks, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getNonDisconnectedSinks();
          }
          _reply.readException();
          _result = _reply.createTypedArray(android.bluetooth.BluetoothDevice.CREATOR);
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // change to Set<> once AIDL supports,

      @Override
      public int getSinkState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_getSinkState, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getSinkState(device);
          }
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // pre API 11 only

      @Override
      public int getConnectionState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_getConnectionState, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getConnectionState(device);
          }
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // API 11 and up

      @Override
      public boolean setSinkPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          _data.writeInt(priority);
          boolean _status = mRemote.transact(Stub.TRANSACTION_setSinkPriority, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().setSinkPriority(device, priority);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // Pre API 11 only

      @Override
      public boolean setPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          _data.writeInt(priority);
          boolean _status = mRemote.transact(Stub.TRANSACTION_setPriority, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().setPriority(device, priority);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // API 11 and up only

      @Override
      public int getPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_getPriority, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getPriority(device);
          }
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // API 11 and up only

      @Override
      public int getSinkPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_getSinkPriority, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getSinkPriority(device);
          }
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      // Pre API 11 only

      @Override
      public boolean isA2dpPlaying(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          if ((device!=null)) {
            _data.writeInt(1);
            device.writeToParcel(_data, 0);
          }
          else {
            _data.writeInt(0);
          }
          boolean _status = mRemote.transact(Stub.TRANSACTION_isA2dpPlaying, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().isA2dpPlaying(device);
          }
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      public static IBluetoothA2dp sDefaultImpl;
    }
    static final int TRANSACTION_connectSink = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
    static final int TRANSACTION_disconnectSink = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
    static final int TRANSACTION_connect = (android.os.IBinder.FIRST_CALL_TRANSACTION + 2);
    static final int TRANSACTION_disconnect = (android.os.IBinder.FIRST_CALL_TRANSACTION + 3);
    static final int TRANSACTION_suspendSink = (android.os.IBinder.FIRST_CALL_TRANSACTION + 4);
    static final int TRANSACTION_resumeSink = (android.os.IBinder.FIRST_CALL_TRANSACTION + 5);
    static final int TRANSACTION_getConnectedSinks = (android.os.IBinder.FIRST_CALL_TRANSACTION + 6);
    static final int TRANSACTION_getNonDisconnectedSinks = (android.os.IBinder.FIRST_CALL_TRANSACTION + 7);
    static final int TRANSACTION_getSinkState = (android.os.IBinder.FIRST_CALL_TRANSACTION + 8);
    static final int TRANSACTION_getConnectionState = (android.os.IBinder.FIRST_CALL_TRANSACTION + 9);
    static final int TRANSACTION_setSinkPriority = (android.os.IBinder.FIRST_CALL_TRANSACTION + 10);
    static final int TRANSACTION_setPriority = (android.os.IBinder.FIRST_CALL_TRANSACTION + 11);
    static final int TRANSACTION_getPriority = (android.os.IBinder.FIRST_CALL_TRANSACTION + 12);
    static final int TRANSACTION_getSinkPriority = (android.os.IBinder.FIRST_CALL_TRANSACTION + 13);
    static final int TRANSACTION_isA2dpPlaying = (android.os.IBinder.FIRST_CALL_TRANSACTION + 14);
    public static boolean setDefaultImpl(IBluetoothA2dp impl) {
      if (Proxy.sDefaultImpl == null && impl != null) {
        Proxy.sDefaultImpl = impl;
        return true;
      }
      return false;
    }
    public static IBluetoothA2dp getDefaultImpl() {
      return Proxy.sDefaultImpl;
    }
  }
  /**
       * System private API for Bluetooth A2DP service
       */
  public boolean connectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // Pre API 11 only

  public boolean disconnectSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // Pre API 11 only

  public boolean connect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // API 11 and up only

  public boolean disconnect(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // API 11 and up only

  public boolean suspendSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // all

  public boolean resumeSink(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // all

  public android.bluetooth.BluetoothDevice[] getConnectedSinks() throws android.os.RemoteException;
  // change to Set<> once AIDL supports, pre API 11 only

  public android.bluetooth.BluetoothDevice[] getNonDisconnectedSinks() throws android.os.RemoteException;
  // change to Set<> once AIDL supports,

  public int getSinkState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // pre API 11 only

  public int getConnectionState(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // API 11 and up

  public boolean setSinkPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException;
  // Pre API 11 only

  public boolean setPriority(android.bluetooth.BluetoothDevice device, int priority) throws android.os.RemoteException;
  // API 11 and up only

  public int getPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // API 11 and up only

  public int getSinkPriority(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
  // Pre API 11 only

  public boolean isA2dpPlaying(android.bluetooth.BluetoothDevice device) throws android.os.RemoteException;
}
