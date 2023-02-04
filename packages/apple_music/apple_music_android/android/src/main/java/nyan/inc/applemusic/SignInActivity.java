package nyan.inc.applemusic;

import static android.content.ContentValues.TAG;
import static androidx.activity.result.ActivityResultCallerKt.registerForActivityResult;

import static com.apple.android.sdk.authentication.TokenError.USER_CANCELLED;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;

import com.apple.android.sdk.authentication.AuthIntentBuilder;
import com.apple.android.sdk.authentication.AuthenticationFactory;
import com.apple.android.sdk.authentication.AuthenticationManager;
import com.apple.android.sdk.authentication.TokenError;
import com.apple.android.sdk.authentication.TokenResult;
import com.google.android.material.snackbar.Snackbar;

import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;

import android.os.ResultReceiver;
import android.view.View;

import androidx.navigation.NavController;
import androidx.navigation.Navigation;

import io.flutter.Log;

public class SignInActivity extends Activity {
    private AuthenticationManager authenticationManager = AuthenticationFactory.createAuthenticationManager(this);
    public final static int REQUEST_CODE_AUTHENTICATE_USER = 704;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        signIn();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Intent resultIntent = new Intent();

        if (requestCode == REQUEST_CODE_AUTHENTICATE_USER) {
            PackageManager pm = this.getPackageManager();
            isPackageInstalled("com.apple.android.music", pm);
            TokenResult result = authenticationManager.handleTokenResult(data);

            if (result.isError()) {
                TokenError error = result.getError();
                resultIntent.putExtra("tokenResult", error);
                if (error == USER_CANCELLED) setResult(RESULT_CANCELED);
                else setResult(RESULT_OK, resultIntent);
            } else {
                String resultToken = result.getMusicUserToken();
                resultIntent.putExtra("tokenResult", resultToken);
                setResult(RESULT_OK, resultIntent);
            }
            finish();
        } else {
            super.onActivityResult(0, 0, null);
        }
    }

    private boolean isPackageInstalled(String packageName, PackageManager packageManager) {
        try {
            packageManager.getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private void signIn() {
        String token = getIntent().getStringExtra("devToken");
        Intent intent = authenticationManager.createIntentBuilder(token).build();
        startActivityForResult(intent, REQUEST_CODE_AUTHENTICATE_USER);
    }
}