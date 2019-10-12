package com.mysoft.flutter_file_helper;

import android.os.Environment;
import android.os.StatFs;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.util.PathUtils;

/**
 * FlutterFileHelperPlugin
 */
public class FlutterFileHelperPlugin implements MethodChannel.MethodCallHandler {
    private final Registrar mRegistrar;

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.mysoft/file_helper");
        FlutterFileHelperPlugin instance = new FlutterFileHelperPlugin(registrar);
        channel.setMethodCallHandler(instance);
    }

    private FlutterFileHelperPlugin(Registrar registrar) {
        this.mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getTemporaryDirectory":
                result.success(getPathProviderTemporaryDirectory());
                break;
            case "getApplicationDocumentsDirectory":
                result.success(getPathProviderApplicationDocumentsDirectory());
                break;
            case "getStorageDirectory":
                result.success(getPathProviderStorageDirectory());
                break;
            case "mkdirs":
                result.success(mkdirs((String) call.arguments));
                break;
            case "getAvailableSize":
                result.success(getAvailableSize());
                break;
            case "getTotalSize":
                result.success(getTotalSize());
                break;
            default:
                result.notImplemented();
        }
    }

    private String getPathProviderTemporaryDirectory() {
        return mRegistrar.context().getCacheDir().getPath();
    }

    private String getPathProviderApplicationDocumentsDirectory() {
        return PathUtils.getDataDirectory(mRegistrar.context());
    }

    private String getPathProviderStorageDirectory() {
        return Environment.getExternalStorageDirectory().getAbsolutePath();
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    private boolean mkdirs(String path) {
        File dir = new File(path);
        if (dir.exists() && dir.isFile()) {
            dir.delete();
        }
        return dir.exists() || dir.mkdirs();
    }

    private double getTotalSize() {
        StatFs statFs = new StatFs(Environment.getExternalStorageDirectory().getPath());
        long blockSize = statFs.getBlockSize();
        long blockCount = statFs.getBlockCount();
        return blockSize * blockCount;
    }

    private double getAvailableSize() {
        StatFs statFs = new StatFs(Environment.getExternalStorageDirectory().getPath());
        long blockSize = statFs.getBlockSize();
        long availableCount = statFs.getAvailableBlocks();
        return blockSize * availableCount;
    }
}