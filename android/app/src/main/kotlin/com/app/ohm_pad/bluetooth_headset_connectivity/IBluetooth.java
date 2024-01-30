/*
 * This file is auto-generated.  DO NOT MODIFY.
 */
package com.app.ohm_pad.bluetooth_headset_connectivity;
public interface IBluetooth extends android.os.IInterface
{
  /** Default implementation for IBluetooth. */
  public static class Default implements IBluetooth
  {
    /**
         * System private API for Bluetooth service
         */
    @Override
    public String getRemoteAlias(String address) throws android.os.RemoteException
    {
      return null;
    }
    @Override
    public boolean setRemoteAlias(String address, String name) throws android.os.RemoteException
    {
      return false;
    }
    @Override
    public android.os.IBinder asBinder() {
      return null;
    }
  }
  /** Local-side IPC implementation stub class. */
  public static abstract class Stub extends android.os.Binder implements IBluetooth
  {
    private static final String DESCRIPTOR = "com.example.bluetoothheadsetconnectivity.IBluetooth";
    /** Construct the stub at attach it to the interface. */
    public Stub()
    {
      this.attachInterface(this, DESCRIPTOR);
    }
    /**
     * Cast an IBinder object into an com.example.bluetoothheadsetconnectivity.IBluetooth interface,
     * generating a proxy if needed.
     */
    public static IBluetooth asInterface(android.os.IBinder obj)
    {
      if ((obj==null)) {
        return null;
      }
      android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
      if (((iin!=null)&&(iin instanceof IBluetooth))) {
        return ((IBluetooth)iin);
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
        case TRANSACTION_getRemoteAlias:
        {
          data.enforceInterface(descriptor);
          String _arg0;
          _arg0 = data.readString();
          String _result = this.getRemoteAlias(_arg0);
          reply.writeNoException();
          reply.writeString(_result);
          return true;
        }
        case TRANSACTION_setRemoteAlias:
        {
          data.enforceInterface(descriptor);
          String _arg0;
          _arg0 = data.readString();
          String _arg1;
          _arg1 = data.readString();
          boolean _result = this.setRemoteAlias(_arg0, _arg1);
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
    private static class Proxy implements IBluetooth
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
           * System private API for Bluetooth service
           */
      @Override
      public String getRemoteAlias(String address) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        String _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeString(address);
          boolean _status = mRemote.transact(Stub.TRANSACTION_getRemoteAlias, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().getRemoteAlias(address);
          }
          _reply.readException();
          _result = _reply.readString();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      @Override
      public boolean setRemoteAlias(String address, String name) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeString(address);
          _data.writeString(name);
          boolean _status = mRemote.transact(Stub.TRANSACTION_setRemoteAlias, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().setRemoteAlias(address, name);
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
      public static IBluetooth sDefaultImpl;
    }
    static final int TRANSACTION_getRemoteAlias = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
    static final int TRANSACTION_setRemoteAlias = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
    public static boolean setDefaultImpl(IBluetooth impl) {
      if (Proxy.sDefaultImpl == null && impl != null) {
        Proxy.sDefaultImpl = impl;
        return true;
      }
      return false;
    }
    public static IBluetooth getDefaultImpl() {
      return Proxy.sDefaultImpl;
    }
  }
  /**
       * System private API for Bluetooth service
       */
  public String getRemoteAlias(String address) throws android.os.RemoteException;
  public boolean setRemoteAlias(String address, String name) throws android.os.RemoteException;
}
