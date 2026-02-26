import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsfeedWidget(title: 'News Feed'),
    );
  }
}

class News {
  final DateTime dt;
  final String title;
  final String text;

  News(this.dt, this.title, this.text);
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                "https://www.bbc.co.uk/news/special/2015/newsspec_10857/bbc_news_logo.png?cb=1",
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(
                  "${news.dt.month}/${news.dt.day}/${news.dt.year}",
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                news.text,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 14.0),
              ),
              Row(
                children: [
                  TextButton(onPressed: () {}, child: const Text("Share")),
                  TextButton(onPressed: () {}, child: const Text("Bookmark")),
                  TextButton(onPressed: () {}, child: const Text("Link")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsfeedWidget extends StatelessWidget {
  final String title;

  NewsfeedWidget({super.key, required this.title});

  final List<News> _newsList = [
    News(
      DateTime(2018, 12, 1),
      "Mass shooting in Atlanta",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet tortor pretium, interdum magna sed.",
    ),
    News(
      DateTime(2019, 1, 12),
      "Carnival clown found drunk in Mississippi",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet tortor pretium, interdum magna sed.",
    ),
    News(
      DateTime(2019, 2, 12),
      "Walrus found in family pool in Florida",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet tortor pretium, interdum magna sed.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> newsCards = _newsList
        .map((news) => NewsCard(news))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(20.0), children: newsCards),
    );
  }
}
