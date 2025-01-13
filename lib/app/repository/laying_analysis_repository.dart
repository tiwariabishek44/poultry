import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EggAnalysisRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final _firestore = FirebaseFirestore.instance;

  // Get egg collection data grouped by category and size
  Stream<Map<String, dynamic>> getEggCollectionAnalysis({
    required String batchId,
    required String yearMonth,
  }) {
    return _firestore
        .collection(FirebasePath.eggCollections)
        .where('batchId', isEqualTo: batchId)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> analysis = {
        'categories': {
          'normal': 0,
          'cracked': 0,
          'waste': 0,
        },
        'sizes': {
          'small': 0,
          'medium': 0,
          'large': 0,
          'xlarge': 0,
        },
        'dailyCollections': <String, int>{},
        'totalEggs': 0,
        'averageDaily': 0.0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['eggCategory'] as String? ?? 'normal';
        final size = data['eggSize'] as String? ?? 'medium';
        final crates = (data['totalCrates'] as num?)?.toInt() ?? 0;
        final remaining = (data['remainingEggs'] as num?)?.toInt() ?? 0;
        final collectionDate = data['collectionDate'] as String? ?? '';

        final totalEggs = (crates * 30) + remaining;

        // Update category counts
        analysis['categories'][category] =
            (analysis['categories'][category] as int) + totalEggs;

        // Update size counts if it's normal category
        if (category == 'normal') {
          analysis['sizes'][size] =
              (analysis['sizes'][size] as int) + totalEggs;
        }

        // Update daily collections
        analysis['dailyCollections'][collectionDate] =
            (analysis['dailyCollections'][collectionDate] ?? 0) + totalEggs;

        // Update total eggs
        analysis['totalEggs'] = (analysis['totalEggs'] as int) + totalEggs;
      }

      // Calculate average daily collection
      if (analysis['dailyCollections'].isNotEmpty) {
        analysis['averageDaily'] = (analysis['totalEggs'] as int) /
            analysis['dailyCollections'].length;
      }
      log('Analsis ${analysis['averageDaily']}');

      return analysis;
    });
  }

  // Get mortality rate for the period
  Stream<Map<String, dynamic>> getMortalityAnalysis({
    required String batchId,
    required String yearMonth,
  }) {
    return _firestore
        .collection(FirebasePath.flockDeaths)
        .where('batchId', isEqualTo: batchId)
        .where('yearMonth', isEqualTo: yearMonth)
        .snapshots()
        .map((snapshot) {
      int totalDeaths = 0;
      Map<String, int> dailyMortality = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final deaths = (data['deathCount'] as num?)?.toInt() ?? 0;
        final date = data['deathDate'] as String? ?? '';

        totalDeaths += deaths;
        dailyMortality[date] = (dailyMortality[date] ?? 0) + deaths;
      }

      return {
        'totalDeaths': totalDeaths,
        'dailyMortality': dailyMortality,
      };
    });
  }
}
