import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/Actor_model.dart';
import 'package:peliculas/src/models/Pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '012e552a33aa7ab027efdf8b3b53c0f6',
      _url = 'api.themoviedb.org',
      _languaje = 'es-Es';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  // Stream
  final _popularesStreamController =
      new StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _proces(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = Peliculas.formJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEncines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _languaje});

    return await this._proces(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (this._cargando) return [];

    this._cargando = true;
    this._popularesPage++;

    final url = Uri.https(this._url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _languaje,
      'page': this._popularesPage.toString()
    });

    final resp = await this._proces(url);
    this._populares.addAll(resp);
    this.popularesSink(this._populares);

    this._cargando = false;

    return resp;
  }

  Future<List<Actor>> getActores(String peliId) async {
    final url = Uri.https(this._url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'language': _languaje,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _languaje, 'query': query});

    return await this._proces(url);
  }
}
