package nyan.inc.applemusic;

import static android.app.Activity.RESULT_CANCELED;
import static android.app.Activity.RESULT_OK;
import static android.content.Context.BIND_AUTO_CREATE;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.widget.Toast;

import androidx.annotation.VisibleForTesting;

import java.io.IOException;
import java.security.GeneralSecurityException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class AppleMusicDelegate implements PluginRegistry.ActivityResultListener {
    public final static int REQUEST_CODE_AUTHENTICATE_USER = 704;
    public final static int REQUEST_CODE_INITIALIZE_PLAYER = 804;

    private final Activity activity;
    MusicPlayerService musicPlayerService;
    TokenProviderService tokenProviderService;
    boolean mBounded;

    private MethodChannel.Result pendingResult;
    private MethodCall methodCall;

    public AppleMusicDelegate(final Activity activity) throws GeneralSecurityException, IOException {
        this(
                activity,
                null,
                null,
                new MusicPlayerService(),
                new TokenProviderService(activity.getApplicationContext())
        );
    }

    @VisibleForTesting
    AppleMusicDelegate(
            final Activity activity,
            final MethodChannel.Result result,
            final MethodCall methodCall,
            final MusicPlayerService musicPlayerService,
            final TokenProviderService tokenProviderService) {
        this.activity = activity;
        this.pendingResult = result;
        this.methodCall = methodCall;
        this.musicPlayerService = musicPlayerService;
        this.tokenProviderService = tokenProviderService;
    }

    private boolean setPendingMethodCallAndResult(
            MethodCall methodCall, MethodChannel.Result result) {
        if (pendingResult != null) {
            return false;
        }

        this.methodCall = methodCall;
        pendingResult = result;

        return true;
    }

    public void startUserAuthentication(MethodCall methodCall, MethodChannel.Result result) {
        if (!setPendingMethodCallAndResult(methodCall, result)) {
            finishWithAlreadyActiveError(result);
            return;
        }

        launchStartUserAuthenticationIntent();
    }

    private void launchStartUserAuthenticationIntent() {
        Intent authIntent = new Intent(activity.getApplicationContext(), SignInActivity.class);
        authIntent.putExtra("devToken", (String) this.methodCall.argument("devToken"));
        activity.startActivityForResult(authIntent, REQUEST_CODE_AUTHENTICATE_USER);
    }

    ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Toast.makeText(activity.getApplicationContext(), "Music player service connected", Toast.LENGTH_SHORT).show();
            mBounded = true;
            MusicPlayerService.LocalBinder mLocalBinder = (MusicPlayerService.LocalBinder) service;
            musicPlayerService = mLocalBinder.getMusicPlayerInstance();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Toast.makeText(activity.getApplicationContext(), "Music player service disconnected", Toast.LENGTH_SHORT).show();
            mBounded = false;
            musicPlayerService = null;
        }
    };

    public void initializeMusicPlayer(MethodCall methodCall, MethodChannel.Result result) {
        launchInitializeMusicPlayer();
    }

    private void launchInitializeMusicPlayer() {
        Thread t = new Thread() {
            public void run() {
                Intent mediaPlayerIntent = new Intent(activity.getApplicationContext(), MusicPlayerService.class);
                activity.bindService(mediaPlayerIntent, mConnection, BIND_AUTO_CREATE);
            }
        };

        t.start();
    }

    public void playSong(MethodCall methodCall, MethodChannel.Result result) {
        launchPlaySong();
    }

    private void launchPlaySong() {
        try {
            musicPlayerService.playSong();
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case REQUEST_CODE_AUTHENTICATE_USER:
                switch (resultCode) {
                    case RESULT_OK:
                        tokenProviderService.storeToken("userToken", data.getExtras().get("tokenResult").toString());
                        pendingResult.success(data.getExtras().get("tokenResult"));
                        clearMethodCallAndResult();
                        break;
                    case RESULT_CANCELED:
                        pendingResult.success(RESULT_CANCELED);
                        break;
                    default:
                        return false;
                }
        }
        return true;
    }

    private void clearMethodCallAndResult() {
        methodCall = null;
        pendingResult = null;
    }

    private void finishWithAlreadyActiveError(MethodChannel.Result result) {
        result.error("already_active", "Authentication is already active", null);
    }
}
