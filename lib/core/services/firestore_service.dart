import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taskschedular/models/api_response.dart';

class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> addDocument({
    required String collection,
    required Map<String, dynamic> data,
    String documentId = '',
    bool returnId = false,
  }) async {
    try {
      if (documentId.isNotEmpty) {
        // Update existing document
        await _db.collection(collection).doc(documentId).set(data);
        return documentId;
      } else {
        // Add new document and return its ID if requested
        final docRef = await _db.collection(collection).add(data);
        return returnId ? docRef.id : null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding document: $e');
      }
      rethrow; // Throw error for handling in UI or upper layers
    }
  }

  Future<ApiResponse<T>> getDocumentBasedOnId<T, P>({
    required String collection,
    required String documentId,
    String dataKey = '',
    bool isList = false,
    required Function(Map<String, dynamic>) tFromJson,
  }) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection(collection).doc(documentId).get();

      if (snapshot.exists) {
        // Prepare data according to whether it's a list or a single document
        List<dynamic> apiData = [];
        Map<String, dynamic> jsonData = {};

        if (isList) {
          if (dataKey.isNotEmpty) {
            // Assuming the document contains a list under a specific key (dataKey)
            final dataList = List<Map<String, dynamic>>.from(
              (snapshot.data() as Map<String, dynamic>)[dataKey],
            );

            apiData = dataList.map((item) {
              return {
                ...item,
                'id': documentId, // Add document ID to each item if needed
              };
            }).toList();
          } else {
            // Assuming the snapshot is a QuerySnapshot containing multiple documents
            final querySnapshot = snapshot as QuerySnapshot;

            apiData = querySnapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id; // Add document ID to each document's data
              return data;
            }).toList();
          }
        } else {
          // Handle the case where the snapshot is a single document (DocumentSnapshot)
          jsonData = snapshot.data() as Map<String, dynamic>;
          jsonData['id'] = snapshot.id; // Add document ID to the data map
        }

        // Wrap the data in a map with the key 'data' for consistent structure
        Map<String, dynamic> wrappedData = {
          'data': isList ? apiData : jsonData
        };

        return ApiResponse.fromJson<T, P>(
          wrappedData,
          tFromJson,
          isList: isList,
        );
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error: $e, Stack: $stack");
      }
      throw Exception('Error getting document: $e');
    }
  }

  Future<ApiResponse<T>> customQuery<T, P>({
    required Function(Map<String, dynamic>) tFromJson,
    required bool isList,
    String dataKey = '',
    required QuerySnapshot snapshot,
  }) async {
    try {
      List<dynamic> apiData = [];
      Map<String, dynamic> jsonData = {};

      if (isList) {
        if (dataKey.isNotEmpty) {
          // Handle case where a specific key within the document contains the data
          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;

            if (data.containsKey(dataKey)) {
              final dataList = List<Map<String, dynamic>>.from(data[dataKey]);
              apiData.addAll(
                dataList
                    .map((item) => {
                          ...item,
                          'id': doc.id, // Add document ID to each item
                        })
                    .toList(),
              );
            }
          }
        } else {
          // Handle case where each document in the collection is considered
          apiData = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Add document ID to the data
            return data;
          }).toList();
        }
      } else {
        if (dataKey.isNotEmpty) {
          // Handle case where a specific key within the first document contains the data
          final doc = snapshot.docs.first;
          final data = doc.data() as Map<String, dynamic>;

          if (data.containsKey(dataKey)) {
            jsonData = data[dataKey] as Map<String, dynamic>;
            jsonData['id'] = doc.id; // Add document ID to the data
          }
        } else {
          // Handle case where the first document in the snapshot is considered
          jsonData = snapshot.docs.first.data() as Map<String, dynamic>;
          jsonData['id'] =
              snapshot.docs.first.id; // Add document ID to the data
        }
      }

      // Wrap the data to pass into ApiResponse
      Map<String, dynamic> wrappedData = {'data': isList ? apiData : jsonData};

      // Return the ApiResponse using the provided tFromJson function and isList flag
      return ApiResponse.fromJson<T, P>(
        wrappedData,
        tFromJson,
        isList: isList,
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error: $e, Stack: $stack");
      }
      throw Exception('Error getting documents: $e');
    }
  }

  Future<ApiResponse<T>> getAllDocuments<T, P>({
    required String collection,
    required Function(Map<String, dynamic>) tFromJson,
    String dataKey = '',
    required bool isList,
  }) async {
    try {
      // Fetch all documents from the specified collection
      QuerySnapshot snapshot = await _db.collection(collection).get();

      List<dynamic> apiData = [];

      if (dataKey.isNotEmpty) {
        // Handle case where a specific key within the document contains the data
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          if (data.containsKey(dataKey)) {
            final dataList = List<Map<String, dynamic>>.from(data[dataKey]);
            apiData.addAll(
              dataList
                  .map((item) => {
                        ...item,
                        'id': doc.id, // Add document ID to each item
                      })
                  .toList(),
            );
          }
        }
      } else {
        // Handle case where each document in the collection is considered
        apiData = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID to the data
          return data;
        }).toList();
      }

      // Wrap the data to pass into ApiResponse
      Map<String, dynamic> wrappedData = {'data': apiData};

      // Return the ApiResponse using the provided tFromJson function and isList flag
      return ApiResponse.fromJson<T, P>(
        wrappedData,
        tFromJson,
        isList: isList,
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error: $e, Stack: $stack");
      }
      throw Exception('Error getting documents: $e');
    }
  }

  Future<int> getDocumentCount(String collection) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.size;
  }

  Future<bool> documentExists({
    required String collection,
    required String documentId,
  }) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .get();
      return docSnapshot.exists;
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error: $e, Stack: $stack");
      }
      rethrow; // Throw error for handling in UI or upper layers
    }
  }
}
