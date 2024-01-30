import 'package:args/command_runner.dart';

class TestCommand extends Command {
  @override
  final name = "test";
  @override
  final description = "test";

  @override
  Future<void> run() async {}
}
