import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tutionsapp/Service/Firebase/providers/signup.dart';
import 'package:tutionsapp/model/batch_model.dart';

import '../app_firebase.dart';

final batchcontrollerprovider =
    StateNotifierProvider<batchcontroller, AsyncValue<List<batch>>>((ref) {
      return batchcontroller(ref.read(authrepositoryprovider));
    });

class batchcontroller extends StateNotifier<AsyncValue<List<batch>>> {
  final AuthRepository _repo;
  batchcontroller(this._repo) : super(AsyncValue.loading()) {
    loadbatch();
  }
  Future<void> loadbatch() async {
    try {
      final data = await _repo.getbatch();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> createbatch(batch b) async {
    await _repo.createBatch(b);
    await loadbatch();
  }

  Future<void> updatebatches(batch b) async {
    await _repo.updateBatch(b);
    await loadbatch();
  }

  Future<void> deletebatches(String id) async {
    await _repo.deletebatch(id);
    await loadbatch();
  }
}
