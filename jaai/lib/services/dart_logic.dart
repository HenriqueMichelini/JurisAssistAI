import 'dart:io';

class PythonToDart {
  static final PythonToDart instance = PythonToDart._constructor();
  PythonToDart._constructor();

  Future<String> runPythonScript(
      String inputString, List<String> keywords) async {
    final String pythonFile =
        'lib/services/logic.py'; // Make sure this path is correct
    final List<String> arguments = [inputString, ...keywords];

    // Run the Python script
    ProcessResult result =
        await Process.run('python', [pythonFile, ...arguments]);

    if (result.exitCode == 0) {
      return result.stdout.toString().trim(); // Return the output
    } else {
      print(
          'Python script failed with exit code ${result.exitCode}: ${result.stderr}');
      return ''; // Return an empty string or handle the error as needed
    }
  }
}
