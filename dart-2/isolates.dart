/*
Распарсить JSON в отдельном isolate, вернуть список объектов.

https://jsonplaceholder.typicode.com/users

User {
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}
*/

import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;

class Geo {
  final double lat;
  final double lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Json json) {
    return Geo(lat: double.parse(json['lat']), lng: double.parse(json['lng']));
  }

  @override
  String toString() => 'Geo(lat: $lat, lng: $lng)';
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Json json) {
    return Address(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      geo: Geo.fromJson(json['geo'] as Json),
    );
  }

  @override
  String toString() {
    return '$street, $suite, $city ($zipcode) [$geo]';
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});

  factory Company.fromJson(Json json) {
    return Company(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }

  @override
  String toString() {
    return '$name ("$catchPhrase" | bs: $bs)';
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  final Address address;
  final Company company;

  final String phone;
  final String website;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Json json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Json),
      phone: json['phone'] as String,
      website: json['website'] as String,
      company: Company.fromJson(json['company'] as Json),
    );
  }

  @override
  String toString() {
    return '''
User #$id: $name (@$username)
  ├ Email: $email
  ├ Phone: $phone
  ├ Website: $website
  ├ Address: $address
  └ Company: $company
''';
  }
}

void main() async {
  final List<User> users = await Isolate.run(() async {
    final http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    final List<dynamic> rawList = jsonDecode(response.body) as List<dynamic>;

    return rawList.map((userJson) => User.fromJson(userJson)).toList();
  });

  print(users);
}
