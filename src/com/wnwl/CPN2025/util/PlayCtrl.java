package com.wnwl.CPN2025.util;

import com.sun.jna.Native;
import com.sun.jna.NativeLong;
import com.sun.jna.examples.win32.W32API;
import com.sun.jna.ptr.ByteByReference;
import com.sun.jna.ptr.NativeLongByReference;
import com.sun.jna.win32.StdCallLibrary;

/**
 * Created by peng on 2016/7/23.
 */ //播放库函数声明,PlayCtrl.dll
public interface PlayCtrl extends StdCallLibrary {
    PlayCtrl INSTANCE = (PlayCtrl) Native.loadLibrary("PlayCtrl",
            PlayCtrl.class);

    int STREAME_REALTIME = 0;
    int STREAME_FILE = 1;

    boolean PlayM4_GetPort(NativeLongByReference nPort);

    boolean PlayM4_OpenStream(NativeLong nPort, ByteByReference pFileHeadBuf, int nSize, int nBufPoolSize);

    boolean PlayM4_InputData(NativeLong nPort, ByteByReference pBuf, int nSize);

    boolean PlayM4_CloseStream(NativeLong nPort);

    boolean PlayM4_SetStreamOpenMode(NativeLong nPort, int nMode);

    boolean PlayM4_Play(NativeLong nPort, W32API.HWND hWnd);

    boolean PlayM4_Stop(NativeLong nPort);

    boolean PlayM4_SetSecretKey(NativeLong nPort, NativeLong lKeyType, String pSecretKey, NativeLong lKeyLen);
}
