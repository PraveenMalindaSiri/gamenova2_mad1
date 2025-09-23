import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/provider/auth_provider.dart';
import 'package:gamenova2_mad1/core/service/seller_service.dart';
import 'package:gamenova2_mad1/views/pages/main_nav.dart';
import 'package:gamenova2_mad1/views/widgets/dialog_helper.dart';
import 'package:gamenova2_mad1/views/widgets/image_container.dart';
import 'package:gamenova2_mad1/views/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ManageGame extends StatefulWidget {
  final Product? game;
  final String token;
  const ManageGame({super.key, this.game, required this.token});

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

  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  Uint8List? _photoBytes;

  bool _isSaving = false;
  String seller = '';

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
    sizeController = TextEditingController(
      text: widget.game?.size.toString() ?? '',
    );
    ageRatingController = TextEditingController(
      text: widget.game?.ageRating.toString() ?? '',
    );
    companyController = TextEditingController(text: widget.game?.company ?? '');
    priceController = TextEditingController(
      text: widget.game?.price.toString() ?? '',
    );
    releasedController = TextEditingController(
      text: widget.game?.releasedAt ?? '',
    );
    loadUser();
  }

  void redirect() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavScreen(selectPageIndex: 2),
      ),
      (route) => false,
    );
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _file = picked;
      _photoBytes = bytes;
    });
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _file = picked;
      _photoBytes = bytes;
    });
  }

  Future<void> create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    if ((_selectedGenre == null || _selectedGenre!.isEmpty) ||
        (_selectedType == null || _selectedType!.isEmpty) ||
        (_selectedPlatform == null || _selectedPlatform!.isEmpty)) {
      await showNoticeDialog(
        context: context,
        title: 'Missing Inputs',
        message: 'Please fill all the details.',
        type: NoticeType.error,
      );
      setState(() => _isSaving = false);
      return;
    }

    if (_file == null) {
      await showNoticeDialog(
        context: context,
        title: 'Product photo required',
        message: 'Please select an image for this product.',
        type: NoticeType.error,
      );
      setState(() => _isSaving = false);
      return;
    }

    final data = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'duration': durationController.text.trim(),
      'size': sizeController.text.trim(),
      'age_rating': ageRatingController.text.trim(),
      'company': companyController.text.trim(),
      'price': priceController.text.trim(),
      'type': (_selectedType ?? '').toLowerCase(),
      'platform': _selectedPlatform,
      'genre': _selectedGenre,
      'released_date': releasedController.text,
    };
    try {
      await SellerService.createProduct(
        data: data,
        token: widget.token,
        photo: _file!,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      await showNoticeDialog(
        context: context,
        title: 'Created',
        message: 'Game created successfully.',
        type: NoticeType.success,
      );
      if (!mounted) return;
      redirect();
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isSaving = false);
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
      await SellerService.updateProduct(
        data: data,
        id: widget.game!.id,
        token: widget.token,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      await showNoticeDialog(
        context: context,
        title: 'Updated',
        message: 'Game Updated successfully.',
        type: NoticeType.success,
      );
      redirect();
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
      await SellerService.deleteProduct(
        id: widget.game!.id,
        token: widget.token,
      );

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Deleted',
        message: 'Game Deleted successfully.',
        type: NoticeType.success,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      redirect();
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

  Future<void> restore() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Restore Game?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Restore'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      await SellerService.restoreProduct(
        id: widget.game!.id,
        token: widget.token,
      );

      if (!mounted) return;
      await showNoticeDialog(
        context: context,
        title: 'Restore',
        message: 'Game Restore successfully.',
        type: NoticeType.success,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      redirect();
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
        title: 'Restoring game failed',
        message: e.toString(),
        type: NoticeType.error,
      );
    }
  }

  Future<void> loadUser() async {
    final auth = context.read<AuthProvider>();
    final id = auth.userId ?? '';
    seller = id.toString();
  }

  Widget readOnlyField(String label, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
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
        icon: Icon(
          Icons.layers,
          color: Theme.of(context).inputDecorationTheme.iconColor,
        ),
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
        icon: Icon(
          Icons.library_books,
          color: Theme.of(context).inputDecorationTheme.iconColor,
        ),
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
        icon: Icon(
          Icons.desktop_windows,
          color: Theme.of(context).inputDecorationTheme.iconColor,
        ),
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
      appBar: AppBar(title: Text('Manage Games')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 60),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 30)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            widget.game == null
                                ? Text("Create a new Game")
                                : Text(
                                    "Update Game: ${widget.game!.title}",
                                    textAlign: TextAlign.center,
                                  ),
                            Padding(padding: EdgeInsets.only(bottom: 10)),

                            // img picker for creating products
                            if (widget.game == null) ...[
                              // img
                              const SizedBox(height: 8),
                              Container(
                                width: 200,
                                height: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                child: _photoBytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          _photoBytes!,
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        'No image selected',
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                              const SizedBox(height: 12),

                              // img picker
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: pickFromGallery,
                                      icon: const Icon(Icons.photo_library),
                                      label: const Text('Gallery'),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: pickFromCamera,
                                      icon: const Icon(Icons.photo_camera),
                                      label: const Text('Camera'),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // img showing when updating
                            if (widget.game != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(23),
                                child: productImage(widget.game!.imageUrl, 200),
                              ),
                              const SizedBox(height: 12),
                            ],

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
                              prefixIcon: Icons.storage,
                              validator: (value) =>
                                  ProductValidation.validSize(value),
                            ),

                            MyTextField(
                              context,
                              ageRatingController,
                              "Age Rating",
                              prefixIcon: Icons.shield,
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
                      SizedBox(width: 10),

                      // selecting genre/type/platforms when creating (L and P)
                      if (widget.game == null)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 800) {
                              return Column(
                                children: [
                                  SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildGenre(
                                        context,
                                        MediaQuery.of(context).size.width *
                                            0.28,
                                      ),
                                      SizedBox(width: 20),

                                      buildTypes(
                                        context,
                                        MediaQuery.of(context).size.width *
                                            0.28,
                                      ),
                                      SizedBox(width: 20),

                                      buildPlatform(
                                        context,
                                        MediaQuery.of(context).size.width *
                                            0.28,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                  buildGenre(
                                    context,
                                    MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  SizedBox(height: 20),

                                  buildPlatform(
                                    context,
                                    MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  SizedBox(height: 20),

                                  buildTypes(
                                    context,
                                    MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            }
                          },
                        ),

                      // showing genre/type/platforms when creating readonly
                      if (widget.game != null) ...[
                        SizedBox(height: 10),
                        readOnlyField(
                          'Type',
                          (widget.game!.type.toUpperCase()),
                        ),
                        SizedBox(height: 20),
                        readOnlyField('Genre', widget.game!.genre),
                        SizedBox(height: 20),
                        readOnlyField('Platform', widget.game!.platform),
                        SizedBox(height: 20),
                      ],

                      // manage if passing a game
                      if (widget.game != null &&
                          widget.game!.sellerId.toString() == seller) ...[
                        // updating
                        if (widget.game!.deletedAt == null)
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            child: ElevatedButton.icon(
                              onPressed: _isSaving ? null : update,
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.edit),
                              label: const Text(
                                'UPDATE',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                minimumSize: const Size.fromHeight(48),
                              ),
                            ),
                          ),

                        SizedBox(height: 20),

                        // deleting and restoring
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving
                                ? null
                                : (widget.game!.isTrashed ? restore : delete),
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    widget.game!.isTrashed
                                        ? Icons.restore
                                        : Icons.delete,
                                  ),
                            label: Text(
                              widget.game!.isTrashed ? 'RESTORE' : 'DELETE',
                              style: const TextStyle(
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

                      // creating if game is null
                      if (widget.game == null)
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : create,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(Icons.save_alt),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
