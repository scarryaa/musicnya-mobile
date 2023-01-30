package com.musicnya;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.MediaPlayer;
import android.os.IBinder;
import android.widget.Toast;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

public class MainActivity extends FlutterActivity {
    public final static int REQ_CODE_CHILD = 1;

    private static final String MUSIC_CHANNEL = "music";
    private static final String AUTH_CHANNEL = "auth";
    private MethodChannel.Result _result;

    boolean mBounded;
    MusicPlayerService musicPlayerService;
    TokenProviderService tokenProvider;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        try {
            tokenProvider = new TokenProviderService(this);
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }

        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), AUTH_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("authenticate")) {
                                _result = result;
                                tokenProvider.storeToken("devToken", call.argument("token"));

                                authenticate(call.argument("token"));
                            }
                        }
                );

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MUSIC_CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("mediaPlayer")) {
                _result = result;
                mediaPlayerHandler();
            } else if (call.method.equals("play")) {
                try {
                    musicPlayerService.playSong();
                } catch (GeneralSecurityException | IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void mediaPlayerHandler() {
        Thread t = new Thread() {
            public void run() {
                Intent mediaPlayerIntent = new Intent(getApplicationContext(), MusicPlayerService.class);
                bindService(mediaPlayerIntent, mConnection, BIND_AUTO_CREATE);
            }
        };

        t.start();
    }

    ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Toast.makeText(MainActivity.this, "Music player service connected", Toast.LENGTH_SHORT).show();
            mBounded = true;
            MusicPlayerService.LocalBinder mLocalBinder = (MusicPlayerService.LocalBinder) service;
            musicPlayerService = mLocalBinder.getMusicPlayerInstance();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Toast.makeText(MainActivity.this, "Music player service disconnected", Toast.LENGTH_SHORT).show();
            mBounded = false;
            musicPlayerService = null;
        }
    };

    @Override
    protected void onStop() {
        super.onStop();
        if (mBounded) {
            unbindService(mConnection);
            mBounded = false;
        }
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_CODE_CHILD) {
            switch (resultCode) {
                case RESULT_OK:
                    tokenProvider.storeToken("userToken", data.getExtras().get("tokenResult").toString());
                    _result.success(data.getExtras().get("tokenResult"));
                    break;
                case RESULT_CANCELED:
                    _result.success(RESULT_CANCELED);
                    break;
                default:
                    break;
            }

        }
    }

    private void authenticate(String token) {
        Intent authIntent = new Intent(this, SignInActivity.class);
        authIntent.putExtra("token", token);
        startActivityForResult(authIntent, REQ_CODE_CHILD);
    }

    private void songs() {

    }

    private void play() {

    }
}