import 'package:flutter/material.dart';
import 'package:pokemon_project/components/error_message.dart';
import 'package:pokemon_project/components/pokemon_card.dart';
import 'package:pokemon_project/components/progress_hud.dart';
import 'package:pokemon_project/screens/pokemon_screen.dart';
import 'package:pokemon_project/services/network_handler.dart';
import 'package:pokemon_project/util/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _listOfPokemons = [];
  late bool _isFinal = false;
  String _error = "";
  bool _fetchingPokemon = false;

  @override
  void initState() {
    _setListOfPokemons();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !_fetchingPokemon &&
          !_isFinal) {
        setState(() {
          _fetchingPokemon = true;
        });
        _setListOfPokemons();
      }
    });
    super.initState();
  }

  void _setListOfPokemons() async {
    List<Map<String, dynamic>> data = [];
    bool isFinal = false;
    try {
      NetworkHandler networkHandler = NetworkHandler(path: "/api/v2/pokemon");
      var result = await networkHandler.getRequest(
          params: {"offset": _listOfPokemons.length.toString(), "limit": "18"});
      if (result["next"] == null) {
        isFinal = true;
      }
      var names =
          result["results"].map((map) => map["name"] as String).toList();
      data = await Util.getPokemonsByName(names);
    } catch (e) {
      setState(() {
        _error = "Ops, algo deu errado\n$e";
        _fetchingPokemon = false;
      });
    } finally {
      setState(() {
        _listOfPokemons.addAll(data);
        _fetchingPokemon = false;
        _isFinal = isFinal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Image.asset(
            "images/logo.png",
            height: 25,
          ),
          const SizedBox(
            width: 5,
          ),
          const Text("Pokedex Maneira!"),
        ],
      )),
      body: ProgressHud(
        loading: _listOfPokemons.isEmpty && _error.isEmpty,
        color: Theme.of(context).colorScheme.primary,
        child: _error.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: _listOfPokemons.length,
                        (context, index) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonScreen(
                                  simpleInfo: _listOfPokemons[index]),
                            ),
                          ),
                          child: PokemonCard(
                            id: _listOfPokemons[index]["id"],
                            name: _listOfPokemons[index]["name"],
                            types: _listOfPokemons[index]["types"],
                            imageUrl: _listOfPokemons[index]["image"],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: !_isFinal
                            ? SizedBox(
                                height: 130,
                                child: Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ))
                            : SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    "Você chegou ao fim :D",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              )
            : ErrorMessage(
                error: _error,
                onPressed: () {
                  setState(() {
                    _error = "";
                    _fetchingPokemon = true;
                  });
                  _setListOfPokemons();
                },
              ),
      ),
    );
  }
}
