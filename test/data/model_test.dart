
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test('Test parsing of data', () async {
        final subject = BehaviorSubject<int>();
    final stream = subject.stream;

    // final stream = databaseBloc.activeMealaStream;
    //await tester.tap(find.byType(ListTile));
    // databaseBloc.activateMeal(meal);
    subject.add(4);


    // await tester.pumpAndSettle();
    print("getting first iteM");
    final item = await stream.first;
    print("got first iteM: $item");
    subject.close();
  });
}