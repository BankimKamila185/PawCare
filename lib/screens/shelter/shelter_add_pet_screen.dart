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
  final _shelterNameController = TextEditingController(text: 'Happy Tails Shelter');
  final _locationController = TextEditingController(text: 'Austin, TX');

  PetGender _selectedGender = PetGender.male;
  PetCategory _selectedCategory = PetCategory.dogs;
  int _selectedImageIndex = 0;
  bool _includeInitialVaccine = true;
  bool _isLoading = false;

  final List<String> _sampleImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAZaNYhpcLX-1zVFpzTQ2f9RqI6WLFkgRDIPcOcoF84_aRvBguBk7irYZZ1JiS2E1cNBnDsnIOstU_vK6XLvycugCL1IhbnKzJz-fLTkz6QhCaV-y_KO9C16p44eQiyuLbEivv5QqyFJD-E0HAPj9c5wFdh5bkatThFVC-k4ILpoiPp8RAASPNPR96m2UFpt1hS9ezlW7Bk7xsZ91WzZx5VLtdcdmZ8u40YNd-yqF-z6opKg5AcJMES',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAY3L3DSoYaaVwPYFhZe184vpyqtHbv-y0RH5nQ27qkj53kP92LHZV4kWEqyJ263riHnUuMHHPd1ItpOpLG22640p-pUBdVGslUr4kszCZqo0g5irpQSDNqi-xjh1TYDwZcQtmNnhdLW6yd1XcpnkJkCzEcfBSyz8DxTce8FVPxlimBVP5k6aaNIJwEAuRwTI4njW1_MIuucplmbBXKB-tpV6OPTYRtGVSb-zJ0TcZ4fGhyz47AKAqC',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB8yGgGdlQ2QHBEmqR8mKmxvE2LRpXij4wKmzKwgVH_i8S0_HBeV4tRwY-9xEm4F6l-EgSsouEeCcIJVXKMbpIndSeXmQ6WUm1y4fYwWCkfuBvUnaV8yZkNtsvgz0Dm1AAbn-dWZRoe5-TTVLOcMwsG9ca4TigYszsEXmrelhFON9wj9mxUBt6u_bkgO2-8Vy75uSwyLmBb_v-p58e_BgsEMuJrdjlc-CngHXGTjdRP6F46o-J9nPTW',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCY_-bauQpsREvIdsmHPaY__JNMLZYO11u_ipAaEHiEaLU4nPDjNIXlPaHzXDS93Nd3uMOpDMpgk9anPkqqBVfYeTxNX9dsnAiuy42P_wqLucl6JLJdi4PBNPy4Pb0XR2bzdDMGhxos573w5NMsDkrgHhvB3To3AYih1M1UYyFD7FbPzeOWZjLY3TZVnDSi7FfPDdljXly5GVJCN4pGkwlbeSRSUZ_DQy3Vt1q1zd52wPrTzBei5XKQ',
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
