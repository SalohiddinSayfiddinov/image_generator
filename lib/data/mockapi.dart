import 'dart:math';

class Mockapi {
  Future<String> generateImage(String prompt) async {
    await Future.delayed(Duration(seconds: 2));
    if (Random().nextInt(10) > 5) {
      throw Exception("Generation failed");
    }
    return "https://picsum.photos/400/300?random=${Random().nextInt(1000)}";
  }
}
