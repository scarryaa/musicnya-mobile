package nyan.inc.applemusic;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import java.io.IOException;
import java.security.GeneralSecurityException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * AppleMusicPlugin
 */
public class AppleMusicPlugin implements FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {

    private class LifeCycleObserver
            implements Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {
        private final Activity thisActivity;

        LifeCycleObserver(Activity activity) {
            this.thisActivity = activity;
        }

        @Override
        public void onCreate(@NonNull LifecycleOwner owner) {}

        @Override
        public void onStart(@NonNull LifecycleOwner owner) {}

        @Override
        public void onResume(@NonNull LifecycleOwner owner) {}

        @Override
        public void onPause(@NonNull LifecycleOwner owner) {}

        @Override
        public void onStop(@NonNull LifecycleOwner owner) {
            onActivityStopped(thisActivity);
        }

        @Override
        public void onDestroy(@NonNull LifecycleOwner owner) {
            onActivityDestroyed(thisActivity);
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {}

        @Override
        public void onActivityStarted(Activity activity) {}

        @Override
        public void onActivityResumed(Activity activity) {}

        @Override
        public void onActivityPaused(Activity activity) {}

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}

        @Override
        public void onActivityDestroyed(Activity activity) {
            if (thisActivity == activity && activity.getApplicationContext() != null) {
                ((Application) activity.getApplicationContext())
                        .unregisterActivityLifecycleCallbacks(
                                this); // Use getApplicationContext() to avoid casting failures
            }
        }

        @Override
        public void onActivityStopped(Activity activity) {}
    }

        private class ActivityState {
        private Application application;
        private Activity activity;
        private AppleMusicDelegate delegate;
        private MethodChannel channel;
        private LifeCycleObserver observer;
        private ActivityPluginBinding activityBinding;

        private Lifecycle lifecycle;

        // Default constructor
        ActivityState(
                final Application application,
                final Activity activity,
                final BinaryMessenger messenger,
                final MethodChannel.MethodCallHandler handler,
                final ActivityPluginBinding activityBinding) throws GeneralSecurityException, IOException {
            this.application = application;
            this.activity = activity;
            this.activityBinding = activityBinding;

            delegate = constructDelegate(activity);
            channel = new MethodChannel(messenger, CHANNEL);
            channel.setMethodCallHandler(handler);
            observer = new LifeCycleObserver(activity);

            // V2 embedding setup for activity listeners.
            activityBinding.addActivityResultListener(delegate);
            lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(activityBinding);
            lifecycle.addObserver(observer);
            }

        // Needed for testing
        ActivityState(final AppleMusicDelegate delegate, final Activity activity) {
            this.activity = activity;
            this.delegate = delegate;
        }

        void release() {
            if (activityBinding != null) {
                activityBinding.removeActivityResultListener(delegate);
                activityBinding = null;
            }

            if (lifecycle != null) {
                lifecycle.removeObserver(observer);
                lifecycle = null;
            }

            if (channel != null) {
                channel.setMethodCallHandler(null);
                channel = null;
            }

            if (application != null) {
                application.unregisterActivityLifecycleCallbacks(observer);
                application = null;
            }

            activity = null;
            observer = null;
            delegate = null;
        }

        Activity getActivity() {
            return activity;
        }

        AppleMusicDelegate getDelegate() {
            return delegate;
        }
    }

    static final String METHOD_CALL_USER_AUTH = "startUserAuthentication";
    static final String METHOD_CALL_INIT_MUSIC_PLAYER = "initializeMusicPlayer";
    static final String METHOD_CALL_PLAY_SONG = "playSong";
    private static final String CHANNEL = "nyan.inc.plugins/apple_music";

    private FlutterPluginBinding pluginBinding;
    private ActivityState activityState;

    @VisibleForTesting
    final ActivityState getActivityState() {
        return activityState;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        pluginBinding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        pluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
        try {
            setup(
                    pluginBinding.getBinaryMessenger(),
                    (Application) pluginBinding.getApplicationContext(),
                    activityPluginBinding.getActivity(),
                    activityPluginBinding);
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDetachedFromActivity() {
        tearDown();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(
            @NonNull ActivityPluginBinding activityPluginBinding) {
        onAttachedToActivity(activityPluginBinding);
    }

    private void setup(
            final BinaryMessenger messenger,
            final Application application,
            final Activity activity,
            final ActivityPluginBinding activityBinding) throws GeneralSecurityException, IOException {
        activityState =
                new ActivityState(application, activity, messenger, this, activityBinding);
    }

    private void tearDown() {
        if (activityState != null) {
            activityState.release();
            activityState = null;
        }
    }

    @VisibleForTesting
    final AppleMusicDelegate constructDelegate(final Activity setupActivity) throws GeneralSecurityException, IOException {
        return new AppleMusicDelegate(setupActivity);
    }

    private static class MethodResultWrapper implements MethodChannel.Result {
        private MethodChannel.Result methodResult;
        private Handler handler;

        MethodResultWrapper(MethodChannel.Result result) {
            methodResult = result;
            handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.success(result);
                        }
                    });
        }

        @Override
        public void error(
                final String errorCode, final String errorMessage, final Object errorDetails) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.error(errorCode, errorMessage, errorDetails);
                        }
                    });
        }

        @Override
        public void notImplemented() {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.notImplemented();
                        }
                    });
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result rawResult) {
        if (activityState == null || activityState.getActivity() == null) {
            rawResult.error("no_activity", "apple_music plugin requires a foreground activity.", null);
            return;
        }

        MethodChannel.Result result = new MethodResultWrapper(rawResult);
        AppleMusicDelegate delegate = activityState.getDelegate();
        switch (call.method) {
            case METHOD_CALL_USER_AUTH:
                delegate.startUserAuthentication(call, result);
                break;
            case METHOD_CALL_INIT_MUSIC_PLAYER:
                delegate.initializeMusicPlayer(call, result);
                break;
            case METHOD_CALL_PLAY_SONG:
                delegate.playSong(call, result);
                break;
            default:
                throw new IllegalArgumentException("Unknown method " + call.method);
        }
    }
}