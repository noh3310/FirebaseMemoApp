import 'package:firebase_memo_app/Enum/edit_memo_type.dart';
import 'package:firebase_memo_app/enum/share_state.dart';
import 'package:firebase_memo_app/repository/memo.dart';
import 'package:firebase_memo_app/database/database_manager.dart';
import 'package:firebase_memo_app/view_model/memo_data_bloc.dart';
import 'package:rxdart/rxdart.dart';

class EditMemoBloc {
  static final _instance = EditMemoBloc._internal();

  EditMemoBloc._internal();

  factory EditMemoBloc() => _instance;

  final memoData = MemoDataBloc();
  final _database = DatabaseManager();
  BehaviorSubject<String> memoText = BehaviorSubject<String>.seeded('');
  BehaviorSubject<Memo?> memo = BehaviorSubject<Memo?>.seeded(null);
}

extension MemoDataUpdate on EditMemoBloc {
  void setMemo(Memo? newMemo) {
    if (newMemo != null) {
      memo.sink.add(newMemo);
      updateText(newMemo.text);
    }
  }

  void updateText(String text) {
    memoText.sink.add(text);
  }
}

extension EditMemoActions on EditMemoBloc {
  Future<void> editMemoButtonClicked(EditMemoType memoType) async {
    switch (memoType) {
      case EditMemoType.add:
        return await addDatabase();
      case EditMemoType.edit:
        return await updateMemoData();
      case EditMemoType.shareData:
        return await updateFriendMemoData();
    }
  }

  Future<void> addDatabase() async {
    await _database.addData(memoText.value);
  }

  Future<void> updateMemoData() async {
    if (memo.value == null) {
      return;
    }
    final changeMemo = memo.value!;
    changeMemo.text = memoText.value;

    await _database.updateMemoData(changeMemo);
  }

  Future<void> updateFriendMemoData() async {
    if (memo.value == null) {
      return;
    }
    await _database.updateFriendMemoData(memo.value!);
  }

  Future<void> enterMemo(EditMemoType memoType) async {
    if (memo.value == null) {
      return;
    }
    await _database.enterMemo(memo.value!, memoType);
  }

  Future<void> shareMemoUser(String uid) async {
    if (memo.value == null) {
      return;
    }
    await _database.requestMemo(memo.value!, uid);
  }

  Future<bool> requestMemoData(String uid) async {
    if (memo.value == null) {
      return false;
    }
    final result = await _database.requestMemo(memo.value!, uid);

    if (result) {
      setShareState(ShareState.request);
      return true;
    }
    return false;
  }

  Future<bool> initRequestMemo() async {
    final result = await _database.initRequestMemo(memo.value!);

    if (result) {
      setShareState(ShareState.none);
      return true;
    }
    return false;
  }

  void setShareState(ShareState state) {
    final newMemo = memo.value;
    newMemo?.shareState = state;
    memo.sink.add(newMemo);
  }
}
