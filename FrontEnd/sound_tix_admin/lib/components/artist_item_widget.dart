import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/entity/artist.dart';

class ArtistItemWidget extends StatefulWidget {
  final String eventName;
  const ArtistItemWidget({super.key, required this.eventName});

  @override
  State<ArtistItemWidget> createState() => _ArtistItemWidgetState();
}

class _ArtistItemWidgetState extends State<ArtistItemWidget> {
  List<Artist> artists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getListArtists(widget.eventName);
  }

  getListArtists(eventName) async {
    var rawData = await httpPost(context, "http://localhost:8080/artist/search", {'event': eventName});

    setState(() {
      artists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (artists.isNotEmpty) {
      return _isLoading
          ? const CircularProgressIndicator()
          : Row(
              children: [
                for (var artist in artists)
                  Tooltip(
                    message: artist.name,
                    child: Container(
                      width: 23,
                      height: 23,
                      margin: const EdgeInsets.only(right: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: Image.asset("images/${artist.avatar}", fit: BoxFit.cover),
                      ),
                    ),
                  ),
              ],
            );
    }
    return Container();
  }
}
