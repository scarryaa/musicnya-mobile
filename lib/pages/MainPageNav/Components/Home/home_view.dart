import 'package:flutter/material.dart';
import 'package:musicnya/pages/MainPageNav/Components/Home/Components/recently_played_component.dart';
import 'package:musicnya/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  //TODO combine recently played and your playlists component structure into 1 since they use the same structure

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      final binding = WidgetsFlutterBinding.ensureInitialized();

      // Run any sync or awaited async function you want to wait for before showing your UI
      Future.wait([
        model.futureUserRecentlyPlayedContent,
        model.futureRecentlyPlayedContentImages,
        // model.futurePlaylists,
        // model.futurePlaylistsImages,
        // model.futureUserHeavyRotation,
        // model.futureUserHeavyRotationImages
      ]);

      return Column(
        children: const [
          RecentlyPlayedComponent(),
          // YourPlaylistsComponent(onFutureComplete: () => null)
        ],
      );
    });
  }
}
