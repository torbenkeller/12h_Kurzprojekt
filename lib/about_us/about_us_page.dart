import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Über Uns',
              style: Theme.of(context).textTheme.display1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Kurz & Lins UG (haftungsbeschränkt)',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Text('Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed'
                ' diam nonumy eirmod tempor invidunt ut labore et dolore'
                ' magna aliquyam erat, sed diam voluptua. At vero eos et'
                ' accusam et justo duo dolores et ea rebum. Stet clita kasd'
                ' gubergren, no sea takimata sanctus est Lorem ipsum dolor'
                ' sit amet. Lorem ipsum dolor sit amet, consetetur'
                ' sadipscing elitr, sed diam nonumy eirmod tempor invidunt'
                ' ut labore et dolore magna aliquyam erat, sed diam'
                ' voluptua. At vero eos et accusam et justo duo dolores et'
                ' ea rebum. Stet clita kasd gubergren, no sea takimata'
                ' sanctus est Lorem ipsum dolor sit amet.'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Mitarbeiter',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Lars Lins (Geschäftsführer)'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Benedict Kurz (Vize-Geschäftsführer)'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Niels Heidbrink (IT-Abteilungsleiter)'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'App-Entwickler',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Torben Keller (Freier Entwickler)'),
            ),
          ],
        ),
      ),
    );
  }
}
