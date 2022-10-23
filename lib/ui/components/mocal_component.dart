import 'package:adoteme/ui/components/texts/detail_text_component.dart';
import 'package:adoteme/ui/components/texts/label_text_component.dart';
import 'package:flutter/material.dart';

class ModalComponent {
  static Future showModal({
    required BuildContext context,
    required Function() action1,
    required String text1,
    required String message,
    Function()? action2,
    String? text2,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 200,
          child: Wrap(
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: <Widget>[
              DetailTextComponent(text: message),
              Wrap(
                spacing: 16,
                children: [
                  if (text2 != null)
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: action2,
                      child: LabelTextComponent(text: text2),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: action1,
                    child: LabelTextComponent(text: text1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
