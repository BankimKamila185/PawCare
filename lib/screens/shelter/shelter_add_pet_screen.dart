import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/enums.dart';
import '../../models/pet.dart';
import '../../models/vaccination.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../main_navigation_screen.dart';

class ShelterAddPetScreen extends StatefulWidget {
  const ShelterAddPetScreen({super.key});

  @override
  State<ShelterAddPetScreen> createState() => _ShelterAddPetScreenState();
}

class _ShelterAddPetScreenState extends State<ShelterAddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController(text: '1 Year');
  final _descriptionController = TextEditingController();
  final _shelterNameController = TextEditingController(text: 'CUPA Rescue Center');
  final _locationController = TextEditingController(text: 'Bengaluru, KA');

  PetGender _selectedGender = PetGender.male;
  PetCategory _selectedCategory = PetCategory.dogs;
  int _selectedImageIndex = 0;
  bool _includeInitialVaccine = true;
  bool _isLoading = false;

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _shelterNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final now = DateTime.now();
    final petId = const Uuid().v4();

    final List<Vaccination> initialVaccines = [];
    if (_includeInitialVaccine) {
      initialVaccines.add(
        Vaccination(
          id: const Uuid().v4(),
          vaccineName: _selectedCategory == PetCategory.cats
              ? 'FVRCP Initial Dose'
              : 'Rabies Core Shot',
          dateGiven: now.subtract(const Duration(days: 30)),
          nextDueDate: now.add(const Duration(days: 335)),
          category: 'Core',
          notes: 'Shelter intake health checkup and vaccination administered.',
        ),
      );
    }

    final newPet = Pet(
      id: petId,
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      age: _ageController.text.trim(),
      gender: _selectedGender,
      category: _selectedCategory,
      image: _sampleImages[_selectedImageIndex],
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : '${_nameController.text.trim()} is a healthy, affectionate ${_breedController.text.trim()} looking for a caring forever family.',
      shelterName: _shelterNameController.text.trim(),
      location: _locationController.text.trim(),
      distance: '2.5 km',
      adoptionStatus: AdoptionStatus.available,
      tags: const ['Shelter Rescued', 'Friendly', 'Healthy'],
      vaccinations: initialVaccines,
    );

    final petService = PetServiceHolder.of(context);
    await petService.addPet(newPet);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newPet.name} has been added to Available Pets!'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Shelter Pet Intake'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.home_work_rounded, color: AppColors.primary, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shelter Intake & Listing',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onPrimaryFixed,
                              ),
                            ),
                            Text(
                              'List rescued animals for public adoption and initialize their clinical logs.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onPrimaryFixedVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Select Pet Photo Preset
                const Text(
                  'Select Photo Avatar *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sampleImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedImageIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(
                              _sampleImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Pet Name
                const Text(
                  'Pet Name *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Charlie',
                    prefixIcon: Icon(Icons.pets_rounded, size: 20),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Please enter pet name.' : null,
                ),
                const SizedBox(height: 16),

                // Category & Gender
                Row(
                  children: [
                    // Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Species / Category',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PetCategory>(
                                value: _selectedCategory,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                      value: PetCategory.dogs, child: Text('Dog')),
                                  DropdownMenuItem(
                                      value: PetCategory.cats, child: Text('Cat')),
                                  DropdownMenuItem(
                                      value: PetCategory.others, child: Text('Other')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCategory = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Gender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PetGender>(
                                value: _selectedGender,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                      value: PetGender.male, child: Text('Male')),
                                  DropdownMenuItem(
                                      value: PetGender.female, child: Text('Female')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedGender = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Breed & Age
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Breed *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _breedController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Beagle',
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Age *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 2 Years',
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  'About & Personality',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe their temperament, habits, and background...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Initial Vaccine Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _includeInitialVaccine,
                  activeColor: AppColors.primary,
                  title: const Text(
                    'Initialize Core Vaccination Record',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Automatically links initial vaccine health checkup',
                    style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _includeInitialVaccine = val ?? true;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Save Button
                PrimaryButton(
                  label: 'Add Pet to Available Listings',
                  leadingIcon: Icons.add_circle_outline_rounded,
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
