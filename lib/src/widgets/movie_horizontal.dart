import 'package:flutter/material.dart';

import 'package:peliculas/src/models/Pelicula_model.dart';

class MovieHorzontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final _pageController = new PageController(initialPage: 1, viewportFraction: 0.3);
  final Function sigPagina;

  MovieHorzontal({@required this.peliculas, @required this.sigPagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    this._pageController.addListener(() {
      if (this._pageController.position.pixels >= this._pageController.position.maxScrollExtent - 200) {
        this.sigPagina();
      }
    });

    return Container(
      height: _screenSize.height * .25,
      child: PageView.builder(
        //children: _tarjetas(context),
        controller: _pageController,
        pageSnapping: false,
        itemCount: this.peliculas.length,
        itemBuilder: (BuildContext context, int i) {
          return this._tarjeta(this.peliculas[i], context);
        },
      ),
    );
  }

  Widget _tarjeta(Pelicula pelicula, BuildContext context) {
    pelicula.uniqueId = '${pelicula.id}-poster';

    final peliculaTarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          Text(
            pelicula.title,
            style: TextStyle(fontSize: 6.0),
            overflow: TextOverflow.ellipsis
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: peliculaTarjeta,
    );
  }

  /*List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }*/
}
