import 'models/thread_part.dart';

class ThreadsRepository {
  static const int maxPartLength = 280;

  Thread createThread(String content) {
    final parts = _splitContent(content);
    return Thread(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parts: parts,
      createdAt: DateTime.now(),
    );
  }

  List<ThreadPart> _splitContent(String content) {
    final parts = <ThreadPart>[];
    final words = content.split(' ');

    String currentPart = '';
    int partIndex = 0;

    for (final word in words) {
      final testPart = currentPart.isEmpty ? word : '$currentPart $word';

      // Check if adding this word exceeds the limit (accounting for thread number)
      final threadNumber = '${partIndex + 1}/';
      final availableLength = maxPartLength - threadNumber.length - 3; // Reserve space for number

      if (testPart.length > availableLength && currentPart.isNotEmpty) {
        // Save current part and start new one
        parts.add(ThreadPart(
          index: partIndex,
          content: currentPart.trim(),
        ));
        partIndex++;
        currentPart = word;
      } else {
        currentPart = testPart;
      }
    }

    // Add the last part
    if (currentPart.isNotEmpty) {
      parts.add(ThreadPart(
        index: partIndex,
        content: currentPart.trim(),
      ));
    }

    // Update with total count
    final totalParts = parts.length;
    return parts.asMap().entries.map((entry) {
      return entry.value.copyWith(
        content: '${entry.key + 1}/$totalParts\n\n${entry.value.content}',
      );
    }).toList();
  }

  Thread updatePart(Thread thread, int index, String newContent) {
    final updatedParts = thread.parts.map((part) {
      if (part.index == index) {
        return part.copyWith(content: newContent, isEdited: true);
      }
      return part;
    }).toList();

    return Thread(
      id: thread.id,
      parts: updatedParts,
      createdAt: thread.createdAt,
    );
  }

  String formatThreadForCopy(Thread thread) {
    return thread.parts.map((part) => part.content).join('\n\n---\n\n');
  }
}
