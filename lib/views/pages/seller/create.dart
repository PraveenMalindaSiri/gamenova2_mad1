import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';

class CreateGame extends StatefulWidget {
  final Product? game;
  const CreateGame({super.key, this.game});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController durationController;
  late final TextEditingController sizeController;
  late final TextEditingController ageRatingController;
  late final TextEditingController companyController;
  late final TextEditingController priceController;

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

    if (widget.game != null) {
      _selectedType = widget.game!.type;
      _selectedGenre = widget.game!.genre;
      _selectedPlatform = widget.game!.platform;
    }
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
    };
    try {
      // create
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

    if (_selectedPlatform!.isEmpty) {
      await showNoticeDialog(
        context: context,
        title: 'Missing Inputs',
        message: 'Please fill all the details.',
        type: NoticeType.error,
      );
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
    };

    try {
      // update
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
