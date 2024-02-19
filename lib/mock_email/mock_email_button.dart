import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/sender/sender.dart';
import 'package:mailapp/storage.dart';

class MockEmailButton extends StatelessWidget {
  const MockEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PushButton(
      controlSize: ControlSize.large,
      onPressed: () async {
        // first generate 10 random emails, use storage to save them
        // and then use EmailSenderCubit to send them

        final storage = context.read<Storage>();
        final senderCubit = context.read<EmailSenderCubit>();

        for (var i = 0; i < 10; i++) {
          final email = Email(
            id: 0,
            subject: randomSentences[i % randomSentences.length].$1,
            content: randomSentences[i % randomSentences.length].$2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            recipient: '',
            sender: 'dominik@roszkowski.dev',
            status: EmailStatus.draft,
            sentAt: null,
          );

          final saved = await storage.create<Email>(email);
          senderCubit.sendEmail(saved.id);
        }
      },
      child: const Text('Send 10 e-mails'),
    );
  }
}

final randomSentences = [
  (
    "Majestic Elephant",
    "A large, majestic **elephant** with a long trunk and big, floppy ears. It's known for its intelligence and strong family bonds."
  ),
  (
    "Fluffy Rabbit",
    "A small, fluffy **rabbit** with long ears and a short tail, hopping around meadows and gardens."
  ),
  (
    "Colorful Parrot",
    "A colorful **parrot** with a vibrant plumage of red, blue, and green, known for its ability to mimic human speech."
  ),
  (
    "Spotted Cheetah",
    "A sleek, spotted **cheetah**, the fastest land animal, capable of reaching speeds up to 75 mph in short bursts."
  ),
  (
    "Majestic Lion",
    "A majestic lion, known as the king of the jungle, with a powerful roar and a beautiful mane."
  ),
  (
    "Playful Dolphin",
    "A playful dolphin, intelligent and friendly, often seen jumping above the sea waves."
  ),
  (
    "Giant Panda",
    "A giant panda, adorable with its black and white fur, spending most of its time eating bamboo in the forest."
  ),
  (
    "Nimble Squirrel",
    "A nimble squirrel, quick and agile, gathering nuts with its bushy tail flicking."
  ),
  (
    "Towering Giraffe",
    "A towering giraffe, the tallest mammal, with a long neck used to reach leaves on tall trees."
  ),
  (
    "Industrious Beaver",
    "An industrious beaver, known for building dams and lodges, with strong teeth for cutting down trees."
  ),
  (
    "Mysterious Owl",
    "A mysterious owl, with large eyes and a silent flight, a nocturnal hunter of the night."
  ),
  (
    "Graceful Swan",
    "A graceful swan, with white feathers and a long neck, gliding elegantly on lakes."
  ),
  (
    "Robust Bison",
    "A robust bison, with a shaggy coat and large horns, roaming the grasslands in herds."
  ),
  (
    "Curious Meerkat",
    "A curious meerkat, standing on its hind legs, vigilant and social in the desert."
  ),
  (
    "Fierce Shark",
    "A fierce shark, a predator of the seas, with sharp teeth and a streamlined body for swift swimming."
  ),
];
