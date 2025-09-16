import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:gamenova2_mad1/views/widgets/text_field.dart';

class ManageGame extends StatefulWidget {
  final Product? game;
  const ManageGame({super.key, this.game});

  @override
  State<ManageGame> createState() => _ManageGameState();
}

class _ManageGameState extends State<ManageGame> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController durationController;
  late final TextEditingController sizeController;
  late final TextEditingController ageRatingController;
  late final TextEditingController companyController;
  late final TextEditingController priceController;
  late final TextEditingController releasedController;

  final List<String> types = ["Physical", "Digital"];
  final List<String> platforms = ["PC", "XBOX", "PS4", "PS5"];
  final List<String> genres = ["Shooter", "RPG", "Racing"];

  String? _selectedType;
  String? _selectedPlatform;
  String? _selectedGenre;

  // released and genre

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.game?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.game?.description ?? '',
    );

    durationController = TextEditingController(
      text: widget.game?.duration ?? '',
    );
    sizeController = TextEditingController(text: widget.game?.size ?? '');
    ageRatingController = TextEditingController(
      text: widget.game?.ageRating ?? '',
    );
    companyController = TextEditingController(text: widget.game?.company ?? '');
    priceController = TextEditingController(
      text: widget.game?.price.toString() ?? '',
    );
    releasedController = TextEditingController(
      text: widget.game?.releasedAt ?? '',
    );
  }

  Future<void> create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    if (_selectedGenre!.isEmpty ||
        _selectedType!.isEmpty ||
        _selectedPlatform!.isEmpty) {
      await showNoticeDialog(
        context: context,
        title: 'Missing Inputs',
        message: 'Please fill all the details.',
        type: NoticeType.error,
      );
      return;
    }

    final price = double.tryParse(priceController.text.trim()) ?? 0;
    final age = int.tryParse(ageRatingController.text.trim()) ?? 0;
    final data = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'duration': durationController.text.trim(),
      'size': sizeController.text.trim(),
      'age_rating': age,
      'company': companyController.text.trim(),
      'price': price,
      'type': (_selectedType ?? '').toLowerCase(),
      'platform': _selectedPlatform,
      'genre': _selectedGenre,
      'released_date': releasedController.text,
    };
    try {
      await ProductService.createProduct(data: data);
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Created',
        message: 'Game created successfully.',
        type: NoticeType.success,
      );
      Navigator.pop(context, true);
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Creating Game failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final price = double.tryParse(priceController.text.trim()) ?? 0;
    final age = int.tryParse(ageRatingController.text.trim()) ?? 0;
    final data = {
      'id': widget.game!.id,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'duration': durationController.text.trim(),
      'size': sizeController.text.trim(),
      'age_rating': age,
      'company': companyController.text.trim(),
      'price': price,
      'type': widget.game!.type.toLowerCase(),
      'platform': widget.game!.platform,
      'genre': widget.game!.genre,
      'released_date': releasedController.text,
    };

    try {
      await ProductService.updateProduct(data: data, id: widget.game!.id);
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Updated',
        message: 'Game Updated successfully.',
        type: NoticeType.success,
      );
      Navigator.pop(context, true);
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Updating game failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove Game?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remove'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      await ProductService.deleteProduct();
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Deleted',
        message: 'Game Deleted successfully.',
        type: NoticeType.success,
      );
    } on TimeoutException {
      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Network timeout',
        message: 'Please check your connection and try again.',
        type: NoticeType.warning,
      );
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Deleting game failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Widget readOnlyField(String label, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: const Icon(Icons.lock),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget buildDate(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        context,
        releasedController,
        "Released Date",
        prefixIcon: Icons.calendar_month,
        readOnly: true,
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(now.year - 18, now.month, now.day),
            firstDate: DateTime(1900),
            lastDate: DateTime(now.year, now.month, now.day),
          );
          if (picked != null) {
            releasedController.text = picked.toIso8601String().split('T').first;
          }
        },
        validator: (value) => ProductValidation.validReleasedDate(value),
      ),
    );
  }

  Widget buildTypes(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedType,
        items: types
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedType = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Edition",
        ),
        validator: (value) => ProductValidation.validType(value),
      ),
    );
  }

  Widget buildGenre(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedGenre,
        items: genres
            .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGenre = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Genre",
        ),
        validator: (value) => ProductValidation.validGenre(value),
      ),
    );
  }

  Widget buildPlatform(context, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedPlatform,
        items: platforms
            .map(
              (platform) =>
                  DropdownMenuItem(value: platform, child: Text(platform)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedPlatform = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Select Platforms",
        ),
        validator: (value) => ProductValidation.validPlatform(value),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    sizeController.dispose();
    ageRatingController.dispose();
    companyController.dispose();
    priceController.dispose();
    releasedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 30)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          widget.game == null
                              ? Text("Create a new Game")
                              : Text("Update game: ${widget.game!.title}"),
                          Padding(padding: EdgeInsets.only(bottom: 10)),

                          MyTextField(
                            context,
                            titleController,
                            "Title",
                            prefixIcon: Icons.title,
                            validator: (value) =>
                                ProductValidation.validTitle(value),
                          ),

                          MyTextField(
                            context,
                            descriptionController,
                            "Description",
                            prefixIcon: Icons.description,
                            validator: (value) =>
                                ProductValidation.validDescription(value),
                          ),

                          MyTextField(
                            context,
                            durationController,
                            "Duration",
                            prefixIcon: Icons.timelapse_outlined,
                            validator: (value) =>
                                ProductValidation.validDuration(value),
                          ),

                          MyTextField(
                            context,
                            sizeController,
                            "Size",
                            // prefixIcon: Icons.,
                            validator: (value) =>
                                ProductValidation.validSize(value),
                          ),

                          MyTextField(
                            context,
                            ageRatingController,
                            "Age Rating",
                            // prefixIcon: Icons.age,
                            validator: (value) =>
                                ProductValidation.validAgeRating(value),
                          ),

                          MyTextField(
                            context,
                            companyController,
                            "Company",
                            prefixIcon: Icons.business,
                            validator: (value) =>
                                ProductValidation.validCompany(value),
                          ),

                          MyTextField(
                            context,
                            priceController,
                            "Price",
                            prefixIcon: Icons.attach_money_rounded,
                            validator: (value) =>
                                ProductValidation.validPrice(value),
                          ),

                          buildDate(context),
                        ],
                      ),
                    ),

                    if (widget.game == null)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildGenre(
                                  context,
                                  MediaQuery.of(context).size.width * 0.3,
                                ),
                                SizedBox(width: 20),

                                buildTypes(
                                  context,
                                  MediaQuery.of(context).size.width * 0.3,
                                ),
                                SizedBox(width: 20),

                                buildPlatform(
                                  context,
                                  MediaQuery.of(context).size.width * 0.3,
                                ),
                                SizedBox(width: 20),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                buildGenre(
                                  context,
                                  MediaQuery.of(context).size.width * 0.9,
                                ),
                                SizedBox(height: 20),

                                buildPlatform(
                                  context,
                                  MediaQuery.of(context).size.width * 0.9,
                                ),
                                SizedBox(height: 20),

                                buildTypes(
                                  context,
                                  MediaQuery.of(context).size.width * 0.9,
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          }
                        },
                      ),

                    if (widget.game != null) ...[
                      SizedBox(height: 15),
                      readOnlyField('Type', (widget.game!.type.toUpperCase())),
                      SizedBox(height: 15),
                      readOnlyField('Genre', widget.game!.genre),
                      SizedBox(height: 15),
                      readOnlyField('Platform', widget.game!.platform),
                      SizedBox(height: 20),
                    ],

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : widget.game == null
                            ? create
                            : update,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : widget.game == null
                            ? Icon(Icons.add)
                            : Icon(Icons.edit),
                        label: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    if (widget.game != null &&
                        widget.game!.sellerId.toString() == '')
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : delete,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.delete),
                          label: const Text(
                            'DELETE',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
