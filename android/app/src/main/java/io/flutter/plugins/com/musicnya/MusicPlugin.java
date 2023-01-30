package io.flutter.plugins.com.musicnya;

import android.provider.MediaStore;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import kotlin.NotImplementedError;

public class MusicPlugin implements MethodChannel.MethodCallHandler {
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "songs":
                throw new NotImplementedError();
        }
    }
}
