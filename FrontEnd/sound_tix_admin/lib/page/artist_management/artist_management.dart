import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/entity/artist.dart';
import 'package:sound_tix_admin/page/artist_management/create_artist.dart';
import 'package:sound_tix_admin/page/artist_management/edit_artist.dart';

class ArtistManagementWidget extends StatefulWidget {
  const ArtistManagementWidget({super.key});

  @override
  State<ArtistManagementWidget> createState() => _ArtistManagementWidgetState();
}

class _ArtistManagementWidgetState extends State<ArtistManagementWidget> {
  late Future futureArtist;
  int currentPage = 0;
  List<Artist> artists = [];
  var findRequestArtist = {};
  bool _isLoadingData = true;
  String _selectedGenreFilter = '';
  String _selectedNationalityFilter = '';

  @override
  void initState() {
    super.initState();
    futureArtist = getInitPage();
  }

  getInitPage() async {
    await search();
    return 0;
  }

  search() {
    var searchRequest = {
      "genre": _selectedGenreFilter,
      "nationality": _selectedNationalityFilter,
    };
    findRequestArtist = searchRequest;
    getListArtists(currentPage, findRequestArtist);
  }

  getListArtists(page, findRequest) async {
    var rawData = await httpPost("http://localhost:8080/artist/search?page=$page&size=10", findRequest);

    setState(() {
      artists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
      _isLoadingData = false;
    });
    return 0;
  }

  deleteArtist(artistId) async {
    var response = await httpDelete("http://localhost:8080/artist/delete/$artistId");
    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa nghệ sĩ thành công!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa nghệ sĩ thất bại!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> listGenres = ['Ballad', 'Rap', 'R&B', 'Pop', 'Indie', 'Opera', 'Rock'];
    List<String> listNationalities = ['Việt Nam', 'Mỹ', 'Anh', 'Pháp', 'Thái Lan', 'Trung Quốc', 'Đức', 'Thụy Sĩ'];
    return FutureBuilder(
      future: futureArtist,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Artist management", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("Manage your artists effectively.", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              _selectedGenreFilter = "";
                              _selectedNationalityFilter = "";
                              search();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            decoration: BoxDecoration(
                                color: (_selectedGenreFilter != "" || _selectedNationalityFilter != "")
                                    ? const Color.fromARGB(255, 231, 229, 229)
                                    : Colors.blue[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text("All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              color: _selectedGenreFilter == "" ? const Color.fromARGB(255, 231, 229, 229) : Colors.blue[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: PopupMenuButton<String>(
                            tooltip: "",
                            onSelected: (String genre) {
                              setState(() {
                                _selectedGenreFilter = genre;
                                search();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return listGenres.map((String genre) {
                                return PopupMenuItem<String>(
                                  value: genre,
                                  child: Text(genre),
                                );
                              }).toList();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _selectedGenreFilter == '' ? "Genre" : _selectedGenreFilter,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.keyboard_arrow_down, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              color: _selectedNationalityFilter == "" ? const Color.fromARGB(255, 231, 229, 229) : Colors.blue[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: PopupMenuButton<String>(
                            tooltip: "",
                            onSelected: (String nationality) {
                              setState(() {
                                _selectedNationalityFilter = nationality;
                                search();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return listNationalities.map((String nationality) {
                                return PopupMenuItem<String>(
                                  value: nationality,
                                  child: Text(nationality),
                                );
                              }).toList();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _selectedNationalityFilter == '' ? "Nationality" : _selectedNationalityFilter,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.keyboard_arrow_down, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _isLoadingData
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Wrap(
                                spacing: 25,
                                runSpacing: 25,
                                children: [
                                  for (var artist in artists)
                                    Stack(
                                      children: [
                                        SizedBox(
                                          width: 180,
                                          height: 235,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset("images/${artist.avatar}", fit: BoxFit.cover, width: 180, height: 180),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(artist.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 3),
                                              Text(artist.genre, style: const TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 3,
                                          child: PopupMenuButton(
                                            offset: const Offset(5, 45),
                                            tooltip: '',
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: ListTile(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return EditArtistWidget(artistId: artist.artistId);
                                                        });
                                                  },
                                                  hoverColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  title: const Row(
                                                    children: [
                                                      Icon(Icons.edit, size: 20),
                                                      SizedBox(width: 15),
                                                      Text("Edit", style: TextStyle(fontSize: 15)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: SizedBox(
                                                  width: 80,
                                                  child: ListTile(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: SingleChildScrollView(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20),
                                                                    child: Column(
                                                                      children: [
                                                                        RichText(
                                                                          text: TextSpan(
                                                                            children: [
                                                                              const TextSpan(
                                                                                  text: "Are you sure you want to delete artist \"",
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black)),
                                                                              TextSpan(
                                                                                  text: artist.name,
                                                                                  style: const TextStyle(
                                                                                      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red)),
                                                                              const TextSpan(
                                                                                  text: "\"?",
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 30),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            InkWell(
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              splashColor: Colors.transparent,
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                width: 80,
                                                                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: const Text("Không",
                                                                                    style: TextStyle(
                                                                                        color: Color.fromARGB(255, 37, 138, 221),
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w500)),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 30),
                                                                            InkWell(
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              splashColor: Colors.transparent,
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  deleteArtist(artist.artistId);
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                width: 80,
                                                                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromARGB(255, 37, 138, 221),
                                                                                  border: Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: const Text("Có",
                                                                                    style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w500)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    hoverColor: Colors.transparent,
                                                    splashColor: Colors.transparent,
                                                    title: const Row(
                                                      children: [
                                                        Icon(Icons.delete, size: 20),
                                                        SizedBox(width: 15),
                                                        Text("Delete", style: TextStyle(fontSize: 15)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            child: const Icon(Icons.more_vert, size: 22, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return const CreateArtistWidget();
                                                });
                                          },
                                          child: DottedBorder(
                                            color: Colors.blue,
                                            strokeWidth: 2,
                                            dashPattern: const [5, 5],
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(8),
                                            child: const SizedBox(
                                              width: 178,
                                              height: 178,
                                              child: Icon(Icons.add, size: 35, color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text("New artist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue)),
                                        const SizedBox(height: 3),
                                        const Text("Add a new artist", style: TextStyle(fontSize: 12, color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
