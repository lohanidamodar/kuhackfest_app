import 'dart:convert';
import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

Client client = Client();

void main() async {
  client
      .setEndpoint("https://demo.appwrite.io/v1")
      .setProject("flutter_quiz")
      .setKey("2ebab431ee9d29aaf8e700873ba2471110fdaa92acd2522c06b51bcd5e6014c622def1198d5fb82ddce26aaee99b324e825ff16b63db78760476d6ccaccc538b3af9e6a057c14b0d18ae2a512f689415ec2785355c8c9eb3d3f858acd5348bf8d807e03787a6638a8a69fe2b3d95a380e2fb0d21eef13359a6cf6591bc08cad6");
  File json = File('./quiz_app_questions.json');
  final questions = jsonDecode(json.readAsStringSync());

  Databases db = Databases(client, databaseId: 'quizDB');

  // await db.create(name: 'QuizDB');

  const collectionId = 'questions';
  // await db.createCollection(
  //     collectionId: collectionId,
  //     name: "Quiz Questions",
  //     permission: 'collection',
  //     read: ["role:all"],
  //     write: ["role:member"]);

  await db.createStringAttribute(
    collectionId: collectionId,
    key: 'question',
    size: 255,
    xrequired: true,
  );

  await db.createStringAttribute(
    collectionId: collectionId,
    key: 'options',
    size: 255,
    xrequired: false,
    array: true,
  );

  await db.createStringAttribute(
    collectionId: collectionId,
    key: 'answer',
    size: 255,
    xrequired: true,
  );

  await Future.delayed(const Duration(seconds: 2));

  for (final question in questions) {
    await db.createDocument(
      documentId: "unique()",
      collectionId: collectionId,
      data: question,
      read: ['role:all'],
      write: ['role:member'],
    );
    
    print(question);
  }

  print("CollectionID: $collectionId");
}
