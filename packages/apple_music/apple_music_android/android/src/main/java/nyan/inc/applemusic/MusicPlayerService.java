package nyan.inc.applemusic;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.apple.android.music.playback.controller.MediaPlayerController;
import com.apple.android.music.playback.controller.MediaPlayerControllerFactory;
import com.apple.android.music.playback.model.MediaItemType;
import com.apple.android.music.playback.model.MediaPlayerException;
import com.apple.android.music.playback.model.PlayerQueueItem;
import com.apple.android.music.playback.queue.CatalogPlaybackQueueItemProvider;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

public class MusicPlayerService extends Service implements MediaPlayerController.Listener {

    MediaPlayerController mediaPlayerController;
    CatalogPlaybackQueueItemProvider.Builder queueProvider;
    IBinder mBinder = new LocalBinder();

    @Override
    public IBinder onBind(Intent intent) {

        try {
            System.loadLibrary("c++_shared");
            System.loadLibrary("appleMusicSDK");

            mediaPlayerController = MediaPlayerControllerFactory.createLocalController(this, new TokenProviderService(this));
            queueProvider = new CatalogPlaybackQueueItemProvider.Builder();
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        return mBinder;
    }

    @Override
    public void onPlayerStateRestored(@NonNull MediaPlayerController mediaPlayerController) {

    }

    @Override
    public void onPlaybackStateChanged(@NonNull MediaPlayerController mediaPlayerController, int i, int i1) {

    }

    @Override
    public void onPlaybackStateUpdated(@NonNull MediaPlayerController mediaPlayerController) {

    }

    @Override
    public void onBufferingStateChanged(@NonNull MediaPlayerController mediaPlayerController, boolean b) {

    }

    @Override
    public void onCurrentItemChanged(@NonNull MediaPlayerController mediaPlayerController, @Nullable PlayerQueueItem playerQueueItem, @Nullable PlayerQueueItem playerQueueItem1) {

    }

    @Override
    public void onItemEnded(@NonNull MediaPlayerController mediaPlayerController, @NonNull PlayerQueueItem playerQueueItem, long l) {

    }

    @Override
    public void onMetadataUpdated(@NonNull MediaPlayerController mediaPlayerController, @NonNull PlayerQueueItem playerQueueItem) {

    }

    @Override
    public void onPlaybackQueueChanged(@NonNull MediaPlayerController mediaPlayerController, @NonNull List<PlayerQueueItem> list) {

    }

    @Override
    public void onPlaybackQueueItemsAdded(@NonNull MediaPlayerController mediaPlayerController, int i, int i1, int i2) {

    }

    @Override
    public void onPlaybackError(@NonNull MediaPlayerController mediaPlayerController, @NonNull MediaPlayerException e) {

    }

    @Override
    public void onPlaybackRepeatModeChanged(@NonNull MediaPlayerController mediaPlayerController, int i) {

    }

    @Override
    public void onPlaybackShuffleModeChanged(@NonNull MediaPlayerController mediaPlayerController, int i) {

    }

    public class LocalBinder extends Binder {
        public MusicPlayerService getMusicPlayerInstance() {
            return MusicPlayerService.this;
        }
    }

    public void playSong() throws GeneralSecurityException, IOException {
        queueProvider.items(MediaItemType.SONG, "1440783625");
        queueProvider.startItemIndex(0);
        mediaPlayerController.prepare(queueProvider.build(), true);
        mediaPlayerController.play();
    }




}
