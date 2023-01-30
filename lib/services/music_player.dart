import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/enums/category_filter.dart';
import 'package:musicnya/models/album.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/services/apple_music_api.dart';

import '../models/song.dart';
import '../models/station.dart';

class MusicPlayer extends ChangeNotifier {
  static final MusicPlayer _instance = MusicPlayer._internal();
  final locator = GetIt.instance;
  int currentSongIndex = 0;
  List<Song> songQueue = [];
  static const String testStation = r'''{
    "data": [
        {
            "id": "ra.978194965",
            "type": "stations",
            "href": "/v1/catalog/us/stations/ra.978194965",
            "attributes": {
                "isLive": true,
                "url": "https://music.apple.com/us/station/apple-music-1/ra.978194965",
                "editorialNotes": {
                    "name": "Apple Music 1",
                    "short": "The new music that matters.",
                    "tagline": "The new music that matters."
                },
                "playParams": {
                    "id": "ra.978194965",
                    "kind": "radioStation",
                    "format": "stream",
                    "stationHash": "CgkIBRoFlaS40gMQBA",
                    "hasDrm": true,
                    "mediaType": 0
                },
                "artwork": {
                    "width": 4320,
                    "height": 1080,
                    "url": "https://is2-ssl.mzstatic.com/image/thumb/Features114/v4/bd/c4/aa/bdc4aa17-bbe4-ccb0-c005-1514160727d2/U0MtTVMtV1ctQU1fMS5wbmc.png/{w}x{h}sr.jpg",
                    "bgColor": "f4f4f4",
                    "textColor1": "000000",
                    "textColor2": "120509",
                    "textColor3": "332628",
                    "textColor4": "33272a"
                },
                "supportedDrms": [
                    "fairplay",
                    "playready",
                    "widevine"
                ],
                "name": "Apple Music 1",
                "mediaKind": "audio"
            }
        },
        {
            "id": "ra.1498155548",
            "type": "stations",
            "href": "/v1/catalog/us/stations/ra.1498155548",
            "attributes": {
                "isLive": true,
                "url": "https://music.apple.com/us/station/apple-music-hits/ra.1498155548",
                "editorialNotes": {
                    "name": "Apple Music Hits",
                    "short": "Songs you know and love.",
                    "tagline": "Songs you know and love."
                },
                "playParams": {
                    "id": "ra.1498155548",
                    "kind": "radioStation",
                    "format": "stream",
                    "stationHash": "CgkIBRoFnJSwygUQBA",
                    "hasDrm": true,
                    "mediaType": 0
                },
                "artwork": {
                    "width": 4320,
                    "height": 1080,
                    "url": "https://is4-ssl.mzstatic.com/image/thumb/Features114/v4/af/5f/6c/af5f6c79-5784-e57c-5202-531ece00e73b/U0MtTVMtV1ctQU1fSGl0cy5wbmc.png/{w}x{h}sr.jpg",
                    "bgColor": "f4f4f4",
                    "textColor1": "000000",
                    "textColor2": "10185f",
                    "textColor3": "292b34",
                    "textColor4": "323b7a"
                },
                "supportedDrms": [
                    "fairplay",
                    "playready",
                    "widevine"
                ],
                "name": "Apple Music Hits",
                "mediaKind": "audio"
            }
        },
        {
            "id": "ra.1498157166",
            "type": "stations",
            "href": "/v1/catalog/us/stations/ra.1498157166",
            "attributes": {
                "isLive": true,
                "url": "https://music.apple.com/us/station/apple-music-country/ra.1498157166",
                "editorialNotes": {
                    "name": "Apple Music Country",
                    "short": "Where it sounds like home.",
                    "tagline": "Where it sounds like home."
                },
                "playParams": {
                    "id": "ra.1498157166",
                    "kind": "radioStation",
                    "format": "stream",
                    "stationHash": "CgkIBRoF7qCwygUQBA",
                    "hasDrm": true,
                    "mediaType": 0
                },
                "artwork": {
                    "width": 4320,
                    "height": 1080,
                    "url": "https://is5-ssl.mzstatic.com/image/thumb/Features114/v4/89/e2/66/89e266ee-454e-87e7-e108-dea53c54da6a/U0MtTVMtV1ctQU1fQ291bnRyeS5wbmc.png/{w}x{h}sr.jpg",
                    "bgColor": "f4f4f4",
                    "textColor1": "000000",
                    "textColor2": "142234",
                    "textColor3": "3a412d",
                    "textColor4": "364354"
                },
                "supportedDrms": [
                    "fairplay",
                    "playready",
                    "widevine"
                ],
                "name": "Apple Music Country",
                "mediaKind": "audio"
            }
        }
    ],
    "meta": {
        "filters": {
            "featured": {
                "apple-music-live-radio": [
                    {
                        "id": "ra.978194965",
                        "type": "stations",
                        "href": "/v1/catalog/us/stations/ra.978194965"
                    },
                    {
                        "id": "ra.1498155548",
                        "type": "stations",
                        "href": "/v1/catalog/us/stations/ra.1498155548"
                    },
                    {
                        "id": "ra.1498157166",
                        "type": "stations",
                        "href": "/v1/catalog/us/stations/ra.1498157166"
                    }
                ]
            }
        }
    }
}''';

  static const String testPlaylist = r'''{
  "data": [
    {
      "id": "pl.f4d106fed2bd41149aaacabb233eb5eb",
      "type": "playlists",
      "href": "/v1/catalog/us/playlists/pl.f4d106fed2bd41149aaacabb233eb5eb",
      "attributes": {
        "artwork": {
          "width": 1080,
          "height": 1080,
          "url": "https://is1-ssl.mzstatic.com/image/thumb/Features122/v4/cf/a6/0b/cfa60b1a-2801-d01f-43ca-32cf75b3bd52/7d2ff641-e31b-48ae-9ba8-1d95435405cf.png/{w}x{h}SC.DN01.jpg?l=en-US",
          "bgColor": "f4f4f4",
          "textColor1": "000000",
          "textColor2": "232121",
          "textColor3": "473e3b",
          "textColor4": "444243"
        },
        "isChart": false,
        "url": "https://music.apple.com/us/playlist/todays-hits/pl.f4d106fed2bd41149aaacabb233eb5eb",
        "lastModifiedDate": "2022-04-13T19:01:51Z",
        "name": "Today’s Hits",
        "playlistType": "editorial",
        "curatorName": "Apple Music Hits",
        "playParams": {
          "id": "pl.f4d106fed2bd41149aaacabb233eb5eb",
          "kind": "playlist",
          "versionHash": "993793b38a53ec95717db443e32a4f9f984ee4c7b8ca88494fa33f126a8ca317"
        },
        "description": {
          "standard": "The first taste of Harry Styles’ forthcoming third album, <I>Harry’s House</I>, has arrived. On “As It Was,” a brisk, daydreamy ballad co-written with Kid Harpoon and Tyler Johnson, the boy-band icon turned bona fide rock star laments one of life’s painful dichotomies: the temptation to look back while being forced to move on ahead. “You know it’s not the same as it was,” he sings on the hook. “In this world, it’s just us.” Add Today’s Hits to your library to stay up on the biggest songs in pop, hip-hop, R&B, and more.",
          "short": "“As It Was,” the daydreamy first single from Harry’s new album, has arrived—in Spatial."
        }
      },
      "relationships": {
        "tracks": {
          "href": "/v1/catalog/us/playlists/pl.f4d106fed2bd41149aaacabb233eb5eb/tracks",
          "data": [
            {
              "id": "1615585008",
              "type": "songs",
              "href": "/v1/catalog/us/songs/1615585008",
              "attributes": {
                "previews": [
                  {
                    "url": "https://audio-ssl.itunes.apple.com/itunes-itms8-assets/AudioPreview112/v4/ed/6b/40/ed6b4050-43a0-7f4d-759a-1575c1ab5022/mzaf_4656295327266779662.plus.aac.p.m4a"
                  }
                ],
                "artwork": {
                  "width": 3000,
                  "height": 3000,
                  "url": "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/2a/19/fb/2a19fb85-2f70-9e44-f2a9-82abe679b88e/886449990061.jpg/{w}x{h}bb.jpg",
                  "bgColor": "d2c8ad",
                  "textColor1": "090f12",
                  "textColor2": "3d2b16",
                  "textColor3": "313431",
                  "textColor4": "5b4a34"
                },
                "artistName": "Harry Styles",
                "url": "https://music.apple.com/us/album/as-it-was/1615584999?i=1615585008",
                "discNumber": 1,
                "genreNames": [
                  "Pop",
                  "Music"
                ],
                "durationInMillis": 167303,
                "releaseDate": "2022-03-31",
                "isAppleDigitalMaster": false,
                "name": "As It Was",
                "isrc": "USSM12200612",
                "hasLyrics": true,
                "albumName": "Harry's House",
                "playParams": {
                  "id": "1615585008",
                  "kind": "song"
                },
                "trackNumber": 4,
                "composerName": "Harry Styles, Kid Harpoon & Tyler Johnson"
              }
              }
          ]
        }
      }
    }
  ]
}''';

  static const String testSong = r'''
              {
    "data": [
        {
            "id": "1613600188",
            "type": "songs",
            "href": "/v1/catalog/us/songs/1613600188",
            "attributes": {
                "albumName": "Emotional Creature",
                "genreNames": [
                    "Alternative",
                    "Music"
                ],
                "trackNumber": 1,
                "durationInMillis": 221000,
                "releaseDate": "2022-06-09",
                "isrc": "USQE92100257",
                "artwork": {
                    "width": 3000,
                    "height": 3000,
                    "url": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/df/4e/68/df4e6833-9828-51d7-cdeb-71ecf6d3a23d/810090090962.png/{w}x{h}bb.jpg",
                    "bgColor": "202020",
                    "textColor1": "aea6f6",
                    "textColor2": "b68ef6",
                    "textColor3": "918bcb",
                    "textColor4": "9878cb"
                },
                "composerName": "Anthony Vaccaro, Jon Alvarado, Lili Trifilio & Matt Henkels",
                "playParams": {
                    "id": "1613600188",
                    "kind": "song"
                },
                "url": "https://music.apple.com/us/album/entropy/1613600183?i=1613600188",
                "discNumber": 1,
                "hasLyrics": true,
                "isAppleDigitalMaster": true,
                "name": "Entropy",
                "previews": [
                    {
                        "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/72/a3/ab/72a3ab79-0066-f773-6618-7a53adc250b3/mzaf_17921540907592750976.plus.aac.p.m4a"
                    }
                ],
                "artistName": "Beach Bunny"
            },
            "relationships": {
                "artists": {
                    "href": "/v1/catalog/us/songs/1613600188/artists",
                    "data": [
                        {
                            "id": "1147783278",
                            "type": "artists",
                            "href": "/v1/catalog/us/artists/1147783278"
                        }
                    ]
                },
                "albums": {
                    "href": "/v1/catalog/us/songs/1613600188/albums",
                    "data": [
                        {
                            "id": "1613600183",
                            "type": "albums",
                            "href": "/v1/catalog/us/albums/1613600183"
                        }
                    ]
                }
            }
        }
    ]
}''';

  static const String testAlbum = r'''
              {"data":[{"id":"1616728060","type":"albums","href":"/v1/catalog/us/albums/1616728060","attributes":{"copyright":"A 10 Summers/Interscope Records Release; ℗ 2022 10 Summers Records, LLC","genreNames":["R&B/Soul","Music"],"releaseDate":"2022-05-06","isMasteredForItunes":true,"upc":"00602445790951","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"playParams":{"id":"1616728060","kind":"album"},"url":"https://music.apple.com/us/album/heart-on-my-sleeve/1616728060","recordLabel":"10 Summers/Interscope Records","isCompilation":false,"trackCount":15,"isSingle":false,"name":"Heart On My Sleeve","contentRating":"explicit","artistName":"Ella Mai","editorialNotes":{"standard":"Ella Mai knows her way around a love song. We've known that for years—certainly since her 2017 single “Boo'd Up” proved a breakout sensation—but her second album cements her as one of R&B's preeminent heart healers. <i>Heart on My Sleeve</i> is filled with the kind of desperate pleas and resolute statements of adoration that could soften even the hardest of hearts. With a voice made of satin and honey, she sings of love in the way so many wish to feel it—vulnerable and terrified yet thoroughly convinced it's worth it.\n\nThe lead singles, “DFMU” (which stands for “don't fuck me up”) and “Leave You Alone” (“I can't leave you alone,” goes the staccato and Auto-Tune hook), were the perfect appetizers for what proves to be a buffet of tender devotion intertwined with blind infatuation. On the gorgeous “Break My Heart,” Mai welcomes the heartache if it means feeling the rush for even a second: “Face my fears, ’cause if I had to choose who could break my heart, baby, it would be you,” she confesses on the hook. “Fallen Angel” literally invokes the heavens with a cameo from a Kirk Franklin-led choir that slides seamlessly into the lament of “How,” which, despite its grievances, still manages an optimistic bent. Elsewhere, tracks like “Pieces” and “A Mess” are about leaning into a person and the feelings they stir up, even when it doesn't necessarily make sense.\n\nThe songs here aren't naive to the problems or immune to the pain, but instead reflect someone choosing love again and again. It's far too easy to keep our walls up—and in a voice note at the end of “Sink or Swim,” Mary J. Blige in fact implores us to “guard that heart” from those who don't deserve us—but <i>Heart on My Sleeve</i> also reminds us of the potential rewards that await on the other side.","short":"The singer dazzles with her second LP, a collection of lush, heartfelt R&B."},"isComplete":true},"relationships":{"artists":{"href":"/v1/catalog/us/albums/1616728060/artists","data":[{"id":"1160482144","type":"artists","href":"/v1/catalog/us/artists/1160482144"}]},"tracks":{"href":"/v1/catalog/us/albums/1616728060/tracks","data":[{"id":"1616728064","type":"songs","href":"/v1/catalog/us/songs/1616728064","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":1,"durationInMillis":197314,"releaseDate":"2022-05-06","isrc":"USUM72203653","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Charles Hinshaw Jr, Dijon McFarlane, Ella Mai Howell, NICHOLAS MATTHEW BALDING, Peter Johnson & Shah Rukh Zaman Khan","url":"https://music.apple.com/us/album/trying/1616728060?i=1616728064","playParams":{"id":"1616728064","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Trying","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/c8/99/a7/c899a79c-e0b1-68ff-ac5e-37cb41c8bc6a/mzaf_613689503757681664.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728065","type":"songs","href":"/v1/catalog/us/songs/1616728065","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":2,"durationInMillis":255013,"releaseDate":"2022-04-02","isrc":"USUM72203647","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Jahaan Sweet, Matthew Samuels, Khristopher Riddick-Tynes, Leon Thomas III, Ella Mai Howell & Varren Wade","url":"https://music.apple.com/us/album/not-another-love-song/1616728060?i=1616728065","playParams":{"id":"1616728065","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Not Another Love Song","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/c2/01/ad/c201ad8c-9597-9eae-1013-0694c393be2e/mzaf_10993214544239266867.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728066","type":"songs","href":"/v1/catalog/us/songs/1616728066","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":3,"durationInMillis":245650,"releaseDate":"2022-05-06","isrc":"USUM72203642","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"alyssa michelle stephens, Dijon McFarlane, Ella Mai Howell, Shah Rukh Zaman Khan & Varren Wade","url":"https://music.apple.com/us/album/didnt-say-feat-latto/1616728060?i=1616728066","playParams":{"id":"1616728066","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Didn't Say (feat. Latto)","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/65/46/30/65463007-33de-a809-4bcd-ea345c87a561/mzaf_15582090794019773151.plus.aac.p.m4a"}],"contentRating":"explicit","artistName":"Ella Mai"}},{"id":"1616728067","type":"songs","href":"/v1/catalog/us/songs/1616728067","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":4,"releaseDate":"2022-05-06","durationInMillis":194826,"isrc":"USUM72203644","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Charles Hinshaw Jr, Dernst Emile II & Ella Mai Howell","url":"https://music.apple.com/us/album/break-my-heart/1616728060?i=1616728067","playParams":{"id":"1616728067","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Break My Heart","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/c6/db/b2/c6dbb255-5ff5-7dcf-f2c3-4abd9cfab447/mzaf_4817315313113526902.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728068","type":"songs","href":"/v1/catalog/us/songs/1616728068","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":5,"releaseDate":"2022-05-06","durationInMillis":261811,"isrc":"USUM72203646","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Ari Irosogie, Ella Mai Howell, Gaeten, Jahaan Akil Sweet, Jvck James, Kirk Franklin, Marco, Richard Olowaranti Mbu Isong & Wolftyla","url":"https://music.apple.com/us/album/fallen-angel/1616728060?i=1616728068","playParams":{"id":"1616728068","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Fallen Angel","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/10/09/3d/10093d6b-3371-0878-2abe-2a174be8db7c/mzaf_11447589703428563008.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728069","type":"songs","href":"/v1/catalog/us/songs/1616728069","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":6,"releaseDate":"2022-05-06","durationInMillis":218317,"isrc":"USUM72203645","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Bass Charity, Dijon McFarlane, Ella Mai Howell, FELICIANO ECAR, Floyd Eugene Bentley Iii, Harissis Tsakmaklis, Jorge Augusto, Luzian Tuetsch, NICHOLAS MATTHEW BALDING, Rodrick Wayne Moore & Varren Wade","url":"https://music.apple.com/us/album/how-feat-roddy-ricch/1616728060?i=1616728069","playParams":{"id":"1616728069","kind":"song"},"discNumber":1,"isAppleDigitalMaster":true,"hasLyrics":true,"name":"How (feat. Roddy Ricch)","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/d2/58/d2/d258d278-819b-3522-a1b9-2d6e8b3af57a/mzaf_8765703002683868492.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728070","type":"songs","href":"/v1/catalog/us/songs/1616728070","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":7,"releaseDate":"2022-05-06","durationInMillis":198795,"isrc":"USUM72203650","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Danny Schofield, Ella Mai Howell, Sir Nolan & Varren Wade","url":"https://music.apple.com/us/album/pieces/1616728060?i=1616728070","playParams":{"id":"1616728070","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Pieces","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/25/70/e4/2570e403-e886-6663-5507-61edb075afe7/mzaf_15697244584423975937.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728071","type":"songs","href":"/v1/catalog/us/songs/1616728071","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":8,"releaseDate":"2022-01-28","durationInMillis":197517,"isrc":"USUM72123679","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Ella Mai Howell, Charles Hinshaw Jr, Dijon McFarlane, Daemon Landrum, Jonathan Sanders, Tyus Strickland, Donell Jones & Kyle West","url":"https://music.apple.com/us/album/dfmu/1616728060?i=1616728071","playParams":{"id":"1616728071","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"DFMU","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/87/2b/a2/872ba250-ba86-aadc-e97e-bf840f9956cf/mzaf_5160210617366591062.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728074","type":"songs","href":"/v1/catalog/us/songs/1616728074","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":9,"durationInMillis":208119,"releaseDate":"2022-05-06","isrc":"USUM72203649","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Charles Hinshaw Jr, Dijon McFarlane, Ella Mai Howell & Wolftyla","url":"https://music.apple.com/us/album/hide/1616728060?i=1616728074","playParams":{"id":"1616728074","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Hide","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/3f/f2/50/3ff25066-b511-e1f9-a035-7bc2f554117a/mzaf_5200904665505669763.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728075","type":"songs","href":"/v1/catalog/us/songs/1616728075","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":10,"releaseDate":"2022-05-06","durationInMillis":213885,"isrc":"USUM72203652","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Cam Griffin, Dijon McFarlane, Ella Mai Howell, Jason Pounds & Varren Wade","url":"https://music.apple.com/us/album/power-of-a-woman/1616728060?i=1616728075","playParams":{"id":"1616728075","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Power Of A Woman","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/4c/2e/49/4c2e49d8-4cbe-7fb1-1d06-43e601b096a8/mzaf_1661246820128533834.plus.aac.p.m4a"}],"artistName":"Ella Mai"}},{"id":"1616728080","type":"songs","href":"/v1/catalog/us/songs/1616728080","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":11,"releaseDate":"2022-05-06","durationInMillis":233794,"isrc":"USUM72203640","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Cameron Joseph, David Brown, Ella Mai Howell, Matthew Samuels, Michael Samuels Jr., Mike McGregor & Peter Iskander","url":"https://music.apple.com/us/album/a-mess-feat-lucky-daye/1616728060?i=1616728080","playParams":{"id":"1616728080","kind":"song"},"discNumber":1,"isAppleDigitalMaster":true,"hasLyrics":true,"name":"A Mess (feat. Lucky Daye)","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/d4/65/93/d46593a6-4b74-d40a-a5c9-1ff0e836e5d4/mzaf_15047800783622526169.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728297","type":"songs","href":"/v1/catalog/us/songs/1616728297","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":12,"releaseDate":"2022-05-06","durationInMillis":199909,"isrc":"USUM72203648","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Chloe George, Ella Mai Howell, Jorgen Odegard & Stephanie Nicole Jones","url":"https://music.apple.com/us/album/feels-like/1616728060?i=1616728297","playParams":{"id":"1616728297","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Feels Like","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/f6/4d/74/f64d7407-86f1-d037-6b87-014128226145/mzaf_12176941177166656131.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728300","type":"songs","href":"/v1/catalog/us/songs/1616728300","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":13,"releaseDate":"2022-04-02","durationInMillis":209136,"isrc":"USUM72203641","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Ella Mai Howell, Varren Wade, Harmony Samuels & Edgar Etienne","url":"https://music.apple.com/us/album/leave-you-alone/1616728060?i=1616728300","playParams":{"id":"1616728300","kind":"song"},"discNumber":1,"isAppleDigitalMaster":true,"hasLyrics":true,"name":"Leave You Alone","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/4e/99/03/4e9903bc-c099-2b91-f725-5f4034930e55/mzaf_12018132630264518586.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728301","type":"songs","href":"/v1/catalog/us/songs/1616728301","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":14,"releaseDate":"2022-05-06","durationInMillis":234613,"isrc":"USUM72203651","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Charles Hinshaw Jr, Dernst Emile II, Ella Mai Howell & Mary J. Blige","url":"https://music.apple.com/us/album/sink-or-swim/1616728060?i=1616728301","playParams":{"id":"1616728301","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Sink or Swim","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/85/63/1d/85631d29-7bc9-5815-5f32-b8fa02789d23/mzaf_2125550395281668690.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}},{"id":"1616728302","type":"songs","href":"/v1/catalog/us/songs/1616728302","attributes":{"albumName":"Heart On My Sleeve","genreNames":["R&B/Soul","Music"],"trackNumber":15,"releaseDate":"2022-05-06","durationInMillis":214882,"isrc":"USUM72203639","artwork":{"width":3000,"height":3000,"url":"https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/{w}x{h}bb.jpg","bgColor":"0b1b18","textColor1":"fc977a","textColor2":"ef5429","textColor3":"cc7e66","textColor4":"c14925"},"composerName":"Ella Mai Howell, Jahaan Akil Sweet & Varren Wade","url":"https://music.apple.com/us/album/fading-out/1616728060?i=1616728302","playParams":{"id":"1616728302","kind":"song"},"discNumber":1,"hasLyrics":true,"isAppleDigitalMaster":true,"name":"Fading Out","previews":[{"url":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/1d/23/8f/1d238f3b-f1d0-ef0a-aec6-a1cfda070e6c/mzaf_16442520982162034651.plus.aac.p.m4a"}],"artistName":"Ella Mai","contentRating":"explicit"}}]}}}]}''';

  factory MusicPlayer() {
    return _instance;
  }

  MusicPlayer._internal() {
    getSongQueue().then((value) => songQueue = value);
  }

  final _authChannel = const MethodChannel('auth');
  final _musicChannel = const MethodChannel('music');

  //platform-agnostic methods

  Future<List<Station>> getStations() async {
    try {
      //List<Station> stations = await AppleMusicApi().getStations();
      List<Station> stations = [];
      for (Object o in json.decode(testStation)['data']) {
        stations.add(Station.from(o));
      }
      return stations;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> getUserHeavyRotation() async {
    try {
      final List<dynamic> results =
          await AppleMusicApi().getUserHeavyRotation();
      return results;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<Song>> getRecentlyPlayedSongs() async {
    try {
      Song result = Song.from(json.decode(testSong)['data'][0]);
      //await AppleMusicApi().getRecentlyPlayed();
      final List<Song> recentlyPlayedList = [result, result, result];
      return recentlyPlayedList;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> getRecentlyPlayedContent() async {
    try {
      final List<dynamic> recentlyPlayedList =
          await AppleMusicApi().getRecentlyPlayedContent();
      return recentlyPlayedList;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<Playlist>> getUserRecentPlaylists() async {
    try {
      final List<dynamic> recentPlaylists =
          await AppleMusicApi().getUserRecentPlaylists();

      List<Playlist> results = [];

      for (var element in recentPlaylists) {
        if (element['type'] == 'playlists') {
          results.add(Playlist.from(element));
        }
      }
      return results;
    } catch (_) {
      return Future.error(_);
    }
  }

  // Future<void> play() async {
  //   try {
  //     Song result = Song.from(AppleMusicApi().getSong());

  //     if (MusicPlayer.player.state == PlayerState.playing) {
  //       await MusicPlayer.player.pause();
  //     } else if (MusicPlayer.player.source != null) {
  //       await MusicPlayer.player.resume();
  //     } else {
  //       await MusicPlayer.player.play(result.);
  //     }
  //   } catch (_) {
  //     return Future.error(_);
  //   }
  // }

  Future<Playlist> getPlaylist(String id) async {
    try {
      final Playlist playlist = await AppleMusicApi().getPlaylist(id);
      return playlist;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Station> getStation(String id) async {
    try {
      final Station station = await AppleMusicApi().getStation(id);
      return station;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Album> getAlbum(String id) async {
    try {
      final Album album = await AppleMusicApi().getAlbum(id);
      return album;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Song> getSong() async {
    try {
      final Song song = Song.from(json.decode(testSong)['data'][0]);
      //final Song song = await AppleMusicApi().getSong();
      return song;
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<Song>> getSongQueue() async {
    try {
      final Album album = Album.from(json.decode(testAlbum)['data'][0]);
      //final Song song = await AppleMusicApi().getSong();
      var songQueue = [
        album.tracks![0],
        album.tracks![1],
        album.tracks![2],
        Song.from(json.decode(testSong)['data'][0])
      ];
      return songQueue;
    } catch (_) {
      return Future.error(_);
    }
  }

  int getCurrentSongIndex() {
    return currentSongIndex;
  }

  bool playSongAtIndex(int index) {
    if (songQueue.length - 1 >= index) {
      currentSongIndex = index;
      //play songQueue[currentSongIndex]
      notifyListeners();
      return true;
    } else {
      throw IndexError.withLength(index, songQueue as int);
    }
  }

  int playNextSong() {
    return currentSongIndex++;
  }

  Future<List> search(searchTerms, categories, local) async {
    String params;

    switch (categories) {
      case null:
        params = CategorySearchFilter.values
            .map((e) => e.name)
            .join(',')
            .toLowerCase();
        break;
      default:
        params = (CategorySearchFilter.values[categories]).name.toLowerCase();
        break;
    }

    try {
      final List results =
          await AppleMusicApi().search(searchTerms, params, local);
      return results;
    } catch (_) {
      return Future.error(_);
    }
  }
  //platform-specific methods

  void passJWT() async {
    await _authChannel.invokeMethod('authenticate');
  }

  void initPlayer() async {
    await _musicChannel.invokeMethod('mediaPlayer');
  }

  void playSong() async {
    await _musicChannel.invokeMethod("play");
  }

  Future<List<Song>> songs() async {
    final List<dynamic>? songs =
        await _musicChannel.invokeMethod<List<dynamic>>('getSongs');
    return songs?.cast<Map<String, Object?>>().map<Song>(Song.from).toList() ??
        <Song>[];
  }

  // Future<void> play(Song song, double volume) async {
  //   try {
  //     return _channel.invokeMethod(
  //         'play', <String, dynamic>{'song': song.id, 'volume': volume});
  //   } on PlatformException catch (e) {
  //     throw ArgumentError('Unable to play ${song.title}: ${e.message}');
  //   }
  // }
}
