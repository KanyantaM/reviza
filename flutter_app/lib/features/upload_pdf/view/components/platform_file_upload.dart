import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';

class SharingFileWidget extends StatelessWidget {
  final Function() onCancelShare;
  final PlatformFile platformFile;
  const SharingFileWidget(
      {super.key, required this.onCancelShare, required this.platformFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 2,
            )
          ]),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/pdf.png',
                width: 70,
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platformFile.name,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${(platformFile.size / 1024).ceil()} KB',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 5,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue.shade50,
                  ),
                  child: BlocBuilder(
                    bloc: uploadProgressCubit,
                    builder: (context, state) {
                      return LinearProgressIndicator(
                        value: uploadProgressCubit.state,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          BlocBuilder(
              bloc: uploadProgressCubit,
              builder: (context, state) {
                return (uploadProgressCubit.state < 0.1)
                    ? IconButton(
                        onPressed: onCancelShare,
                        icon: const Icon(Icons.cancel_outlined))
                    : const Wrap();
              }),
        ],
      ),
    );
  }
}
