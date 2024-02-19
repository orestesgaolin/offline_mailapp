import 'package:mailapp/model.dart';

/// Storage of T where T is subtype of Model
abstract class Storage {
  Future<T> create<T extends Model>(T value);

  Future<T> save<T extends Model>(int id, T value);

  Future<T?> read<T extends Model>(int id);

  Future<T?> find<T extends Model>({required String where});

  Stream<List<T>> watchAll<T extends Model>();

  Stream<T?> watch<T extends Model>(int id);

  Future<void> clear();
}
