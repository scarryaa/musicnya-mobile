async function configureMusicKit(devToken) {
    window.musicKit = await initMusicKit(devToken);
    return window.musicKit;
};

async function initMusicKit(devToken) {
    return await MusicKit.configure({
        developerToken: devToken,
        app: {
            name: "musicnya",
            build: "1.0.0",
        },
    });
}

async function startAuthentication() {
    return await MusicKit.getInstance().authorize();
}

async function checkIfUserIsAuthorized() {
    console.log(MusicKit.getInstance());
    return MusicKit.getInstance().isAuthorized;
}