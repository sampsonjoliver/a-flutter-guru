import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:transparent_image/transparent_image.dart';

class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> {
  Future<CourseData> data;

  @override
  void initState() {
    super.initState();
    data = getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: FutureBuilder<CourseData>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.hits.map((course) {
                    return GridTile(
                        child: Stack(
                      children: <Widget>[
                        new FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: course.backgroundPosterUrl,
                            fit: BoxFit.cover),
                        Center(
                            child: Text(
                          course.title,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.center,
                        ))
                      ],
                      fit: StackFit.expand,
                    ));
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Future<CourseData> getCourses() async {
    final contents = await rootBundle.loadString('assets/courses.json');
    final json = JSON.json.decode(contents);
    debugPrint(json['hits'][0]['title']);
    final courseData = CourseData.fromJson(json);
    return courseData;
  }
}

class CourseData {
  final List<Course> hits;

  CourseData({this.hits});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> hits = json['hits'];
    final List<Course> courses =
        hits.map((hit) => Course.fromJson(hit)).toList();
    return CourseData(hits: courses);
  }
}

class Course {
  final String title;
  final bool isActive;
  final bool isFeatured;
  final num duration;
  final String description;
  final String shortSummary;
  final dynamic topics;
  final dynamic skillLevels;
  final dynamic roles;
  final dynamic authors;
  final String url;
  final String primaryTopic;
  final bool isOrganisationOnly;
  final String artworkUrl;
  final String backgroundPosterUrl;

  Course(
      {this.title,
      this.isActive,
      this.isFeatured,
      this.duration,
      this.description,
      this.shortSummary,
      this.topics,
      this.skillLevels,
      this.roles,
      this.authors,
      this.url,
      this.primaryTopic,
      this.isOrganisationOnly,
      this.artworkUrl,
      this.backgroundPosterUrl});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title'],
      isActive: json['isActive'],
      isFeatured: json['isFeatured'],
      duration: json['duration'],
      description: json['description'],
      shortSummary: json['shortSummary'],
      topics: json['topics'],
      skillLevels: json['skillLevels'],
      roles: json['roles'],
      authors: json['authors'],
      url: json['url'],
      primaryTopic: json['primaryTopic'],
      isOrganisationOnly: json['isOrganisationOnly'],
      artworkUrl: json['artworkUrl'],
      backgroundPosterUrl: json['backgroundPosterUrl'],
    );
  }
}
