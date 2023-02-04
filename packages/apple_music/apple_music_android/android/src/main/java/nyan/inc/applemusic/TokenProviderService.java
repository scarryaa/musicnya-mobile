package nyan.inc.applemusic;

import android.content.Context;
import android.content.SharedPreferences;
import android.security.keystore.KeyGenParameterSpec;

import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;

import com.apple.android.sdk.authentication.TokenProvider;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.KeyStore;

public class TokenProviderService implements TokenProvider {

    KeyStore.ProtectionParameter protParam;
    KeyGenParameterSpec spec;
    KeyStore keyStore;
    protected Context context;
    MasterKey masterKey;
    SharedPreferences sharedPreferences;

    TokenProviderService(Context context) throws GeneralSecurityException, IOException {
        masterKey = new MasterKey.Builder(context)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build();

        sharedPreferences = EncryptedSharedPreferences.create(
                context,
                "secret_shared_prefs",
                masterKey,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM);
    }

    public void storeToken(String key, String value) {
        sharedPreferences.edit().putString(key, value).apply();
    }

    @Override
    public String getDeveloperToken() {
        KeyStore.PrivateKeyEntry devToken = null;
        return sharedPreferences.getString("devToken", "");
    }

    @Override
    public String getUserToken() {
        KeyStore.PrivateKeyEntry devToken = null;
        return sharedPreferences.getString("userToken", "");
    }
}
