import 'package:flutter/material.dart';

// Đưa cho tôi 1 List text + Maxline. Tôi sẽ canh xem trong maxLine đó, chỗ nào vượt thì thêm 3 chấm.
// Số lượng tối đa text phải nhiều hơn maxline 1. để biết xem trong bài đó có nhiều hơn maxline câu không?
class EllipsisText extends StatelessWidget {
  final List<String> text;
  final int maxLines;

  const EllipsisText(
    this.text, {
    super.key,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        String displayText = text.join('\n');

        // Biến tạm để lặp
        String currentTest = '';
        String preString = '';

        final tp = TextPainter(
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );

        for (int i = 0; i < text.length; i++) {
          // print(i);
          currentTest = text.sublist(0, i + 1).join('\n');
          final span = TextSpan(
            text: currentTest,
            style: Theme.of(context).textTheme.bodyMedium,
          );

          // Gán textSpan vào TextPainer để vẽ thử
          tp.text = span;

          // Vẽ thử
          tp.layout(maxWidth: constraints.maxWidth);

          // Nếu có vượt
          if (tp.didExceedMaxLines) {
            // Vẽ thử với trường hợp phía trước + \n. Xem thử vượt là do \n hay do câu đủ tới maxline r.
            final span = TextSpan(
              text: '$preString\n',
              style: Theme.of(context).textTheme.bodyMedium,
            );
            tp.text = span;
            tp.layout(maxWidth: constraints.maxWidth);

            // Lần này mà vượt là do \n. Còn không là tự lực câu đang xét vượt qua.
            if (tp.didExceedMaxLines) {
              displayText = ' $preString...';
            } else {
              displayText = currentTest;
            }
            // print(i);
            // print(displayText);
            // print("----------------");
            // print(preString);
            break;
          }

          preString = currentTest;
        }
        if (displayText.isEmpty) return const SizedBox();

        return RichText(
          textScaler: MediaQuery.textScalerOf(context),
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: displayText,
              ),
            ],
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
