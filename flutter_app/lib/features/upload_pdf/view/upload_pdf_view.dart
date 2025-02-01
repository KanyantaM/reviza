import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/utilities/generator.dart';
import 'package:reviza/widgets/range_slider.dart';
import 'package:reviza/misc/course_info.dart';
import 'package:reviza/utilities/cloud.dart';
import 'package:reviza/utilities/dialogues/cannot_share_empty_not_dialog.dart';
import 'package:student_api/student_api.dart';

class UploadPdfView extends StatefulWidget {
  final String id;
  final Types type;
  const UploadPdfView({super.key, required this.type, required this.id});

  @override
  State<UploadPdfView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<UploadPdfView>
    with SingleTickerProviderStateMixin {
  bool _uploading = false;
  Student? _student;
  List<String> _myCourses = [];
  File? _file;
  // ImagePicker image = ImagePicker();
  final TextEditingController _url = TextEditingController();
  var name = "";
  PlatformFile? _platformFile;
  late AnimationController loadingController;
  bool isuploaded = false;

//test
  TextEditingController yearController = TextEditingController();
  String _courseName = '';
  String _category = 'TEST';
  // bool _agreeToTerms = false;
  bool _isRangeSelected = false;
  int _startingYear = DateTime.now().year - 1;
  int _endingYear = DateTime.now().year - 1;

  //notes
  TextEditingController titleController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  double startingUnit = 1.0;
  double endingUnit = 1.0;
  double? singleUnit;
  TextEditingController linkController = TextEditingController();

  void getStudent() async {
    _student = await fetchCurrentStudentOnline(widget.id);
    setState(() {
      _myCourses = _student!.myCourses;
    });
  }

  @override
  void initState() {
    _uploading = false;
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    getStudent();
    super.initState();
  }

  @override
  void dispose() {
    yearController.dispose();
    titleController.dispose();
    authorNameController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widgetSelector(
          pp: const Text('Upload Past Paper'),
          notes: const Text('Upload Notes'),
          ass: const Text('Upload Ass'),
          book: const Text('Upload Book'),
          lab: const Text('Upload Lab'),
          link: const Text('Add Link'),
        ),
      ),
      body: BlocConsumer<UploadPdfBloc, UploadPdfState>(
        builder: ((context, state) {
          if (state is UploadingPdfState) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildSearchableDropdown('Course', _myCourses, (selected) {
                  _courseName = selected;
                }),
                const Spacer(
                  flex: 1,
                ),
                _platformFile == null && widget.type != Types.links
                    ? GestureDetector(
                        onTap: getfile,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: Colors.blue.shade400,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  // color: Colors.blue.shade50.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.folder_open,
                                    // color: Colors.blue,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select your file',
                                    style: TextStyle(
                                      fontSize: 15,
                                      // color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : widgetSelector(
                        pp: Column(
                          children: [
                            _buildRadioButtons(),
                            if (_isRangeSelected) _buildYearRangeDropdowns(),
                            if (!_isRangeSelected) _buildSingleYearDropdown(),
                            const SizedBox(height: 16),
                            _buildCategoryChips(),
                            const SizedBox(height: 16),
                          ],
                        ),
                        notes: _documentUpload(),
                        ass: _documentUpload(),
                        book: _documentUpload(),
                        lab: _documentUpload(),
                        link: Column(children: [
                          // const SizedBox(height: 16),
                          // _buildTextFieldWithTitle(
                          //   title: 'Title',
                          //   controller: titleController,
                          // ),
                          const SizedBox(height: 16),
                          _buildTextFieldWithTitle(
                            title: 'Description',
                            controller: titleController,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'URL',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'enter url';
                                  } else if (value?.startsWith('https://') ??
                                      false) {
                                    return null;
                                  } else {
                                    return 'enter a valid url';
                                  }
                                },
                                controller: _url,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ]),
                      ),
                (_platformFile != null && widget.type != Types.links)
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected File:',
                              style: TextStyle(
                                fontSize: 15,
                                // color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      // color: Colors.grey.shade200,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _platformFile!.name,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${(_platformFile!.size / 1024).ceil()} KB',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 5,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blue.shade50,
                                          ),
                                          child: BlocBuilder(
                                            bloc: uploadProgressCubit,
                                            builder: (context, state) {
                                              return LinearProgressIndicator(
                                                value:
                                                    uploadProgressCubit.state,
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
                                                onPressed: () {
                                                  setState(() {
                                                    _file = null;
                                                    _platformFile = null;
                                                    _uploading = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.cancel_outlined))
                                            : const Wrap();
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const Spacer(
                  flex: 2,
                ),
                SizedBox(
                    height: (29.7),
                    width: (170.7),
                    child: (_uploading)
                        ? const Center(
                            child: Text(
                            'UPloading....',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ))
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Theme.of(context).hoverColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular((20.86)),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _uploading = true;
                              });
                              await uploadFile(context, state);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: (9.86),
                                ),
                                Text(
                                  "Upload Material",
                                  style: GoogleFonts.poppins(
                                    // color: Colors.white,
                                    fontSize: (12.51),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                const SizedBox(
                  height: 12,
                )
              ],
            ),
          );
        }),
        listener: (context, state) {
          if (state is UploadedPdfState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomSnackBar(
                errorText: 'File Uploaded',
                headingText: 'Success',
                color: const Color.fromARGB(255, 29, 164, 31),
                image: Image.asset(
                  'assets/icon/error_solid_green.png',
                  height: 35,
                  width: 35,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ));

            // add duration
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context);
            });
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnackBar(
                  errorText: state.message,
                  headingText: 'Oh Snap!',
                  color: const Color(0xFFF75469),
                  image: Image.asset('assets/icon/error_solid.png'),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          }
        },
      ),
    );
  }

  Column _documentUpload() {
    return Column(children: [
      const SizedBox(height: 16),
      _buildTextFieldWithTitle(
        title: 'Title',
        controller: titleController,
      ),
      const SizedBox(height: 16),
      _buildTextFieldWithTitle(
        title: 'Author Name',
        controller: authorNameController,
      ),
      const SizedBox(height: 16),
      _buildSliderWithTitle(
        title: 'Enter Lecture Range',
        value: startingUnit,
        onChanged: (value) {
          setState(() {
            startingUnit = value;
          });
        },
      ),
      const SizedBox(height: 16),
    ]);
  }

  Widget widgetSelector(
      {required Widget pp,
      required Widget notes,
      required Widget ass,
      required Widget book,
      required Widget lab,
      required Widget link}) {
    return widget.type == Types.papers
        ? pp
        : widget.type == Types.notes
            ? notes
            : widget.type == Types.assignment
                ? ass
                : widget.type == Types.books
                    ? book
                    : widget.type == Types.lab
                        ? lab
                        : widget.type == Types.links
                            ? link
                            : const Wrap();
  }

  getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _platformFile = result.files.first;
      });
    }

    setState(() {});

    uploadProgressCubit.updateProgress(0);
  }

  uploadFile(BuildContext context, UploadPdfState state) async {
    if (_file != null &&
        (_courseName.isNotEmpty || widget.type == Types.links)) {
      isuploaded = true;
      String type = '';
      String desc = '';

      switch (widget.type) {
        case Types.papers:
          type = 'PAST_PAPERS';
          if (_isRangeSelected) {
            desc = 'from $_startingYear to $_endingYear $_category papers';
          } else {
            desc = '$_startingYear $_category papers';
          }
          break;
        case Types.notes:
          type = 'NOTES';
          if (startingUnit != endingUnit) {
            desc =
                'from $startingUnit to $endingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          } else {
            desc =
                '$startingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          }
          break;
        case Types.links:
          type = 'LINKS';
          desc = _url.text;
        case Types.lab:
          type = 'LAB';
          if (startingUnit != endingUnit) {
            desc =
                'from $startingUnit to $endingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          } else {
            desc =
                '$startingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          }
          break;
        case Types.books:
          type = 'BOOKS';
          if (startingUnit != endingUnit) {
            desc =
                'from $startingUnit to $endingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          } else {
            desc =
                '$startingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          }
          break;
        case Types.assignment:
          type = 'ASSIGNMENT';
          if (startingUnit != endingUnit) {
            desc =
                'from $startingUnit to $endingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          } else {
            desc =
                '$startingUnit ${(authorNameController.text.isNotEmpty) ? 'by ${authorNameController.text}' : ''}';
          }
          break;
      }
      context.read<UploadPdfBloc>().add(
            UploadPdf(
              subjectName: _courseName,
              type: type,
              id: generateRandomString((DateTime.now().hour) % 5 + 5),
              title: (titleController.text.isNotEmpty)
                  ? titleController.text
                  : _file!.path.split('/').last,
              description: desc,
              pdfFile: _file!,
            ),
          );
    } else if (_courseName.isEmpty) {
      await showCannotShareEmptyNoteDialog(context);
    } else {
      isuploaded = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBar(
            errorText: 'No file selected',
            headingText: 'Oh Snap!',
            color: const Color(0xFFF75469),
            image: Image.asset('assets/icon/error_solid.png'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  Widget _buildSearchableDropdown(
      String label, List<String> options, Function(String selected) onChanged) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((option) =>
            option
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()) ||
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: onChanged,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onEditingComplete) {
        return TextFormField(
          decoration: InputDecoration(labelText: label),
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
        );
      },
    );
  }

  Widget _buildTextFieldWithTitle(
      {required String title, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildSliderWithTitle(
      {required String title,
      required double value,
      required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RangeSliderWidget(
          onRangeChanged: (values) {
            if (values.start != values.end) {
              startingUnit = values.start;
              endingUnit = values.end;
            } else {
              singleUnit = values.start;
            }
          },
        ),
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Year Range:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: _isRangeSelected,
              onChanged: (value) {
                setState(() {
                  _isRangeSelected = false;
                });
              },
            ),
            const Text('Single Year'),
            const SizedBox(width: 16),
            Radio(
              value: true,
              groupValue: _isRangeSelected,
              onChanged: (value) {
                setState(() {
                  _isRangeSelected = true;
                });
              },
            ),
            const Text('Year Range'),
          ],
        ),
      ],
    );
  }

  Widget _buildYearRangeDropdowns() {
    return Row(
      children: [
        _buildYearDropdown(
          label: 'Starting Year',
          value: _startingYear,
          onChanged: (value) {
            setState(() {
              _startingYear = value ?? 2023;
            });
          },
        ),
        const SizedBox(width: 16),
        _buildYearDropdown(
          label: 'Ending Year',
          value: _endingYear,
          onChanged: (value) {
            setState(() {
              _endingYear = value ?? 2023;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSingleYearDropdown() {
    return _buildYearDropdown(
      label: 'Year',
      value: _startingYear,
      onChanged: (value) {
        setState(() {
          _startingYear = value ?? 2023;
        });
      },
    );
  }

  Widget _buildYearDropdown(
      {required String label,
      required int value,
      required ValueChanged<int?> onChanged}) {
    return SizedBox(
      width: 150, // Set a fixed width for the dropdown container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: value,
            onChanged: onChanged,
            items: List.generate(
              10,
              (index) => DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Category:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Expanded(
            child: Wrap(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              children: [
                for (String categoryOption in [
                  'TEST',
                  'EXAM',
                  'SUP',
                  'MAKE-UP',
                  'OTHER'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(categoryOption),
                      selected: _category == categoryOption,
                      onSelected: (bool selected) {
                        setState(() {
                          _category = selected ? categoryOption : '';
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.errorText,
    required this.headingText,
    required this.color,
    required this.image,
  });

  final String errorText, headingText;
  final Color? color;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          height: 90,
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headingText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      errorText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icon/test.svg',
                  height: 48,
                  width: 40,
                  // ignore: deprecated_member_use
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: image!.image,
                height: 35,
                width: 35,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  'assets/icon/vhat.svg',
                  height: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
