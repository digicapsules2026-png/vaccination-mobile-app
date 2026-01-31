import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../data/models/document_model.dart';

class DocumentLockerPage extends ConsumerStatefulWidget {
  final int childId;

  const DocumentLockerPage({
    super.key,
    required this.childId,
  });

  @override
  ConsumerState<DocumentLockerPage> createState() => _DocumentLockerPageState();
}

class _DocumentLockerPageState extends ConsumerState<DocumentLockerPage> {
  List<DocumentModel> _documents = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      final service = ref.read(documentsServiceProvider);
      final documents = await service.getChildDocuments(widget.childId);
      setState(() {
        _documents = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load documents: $e')),
        );
      }
    }
  }

  List<DocumentModel> get _filteredDocuments {
    if (_selectedCategory == 'All') {
      return _documents;
    }
    return _documents.where((doc) => doc.documentType == _selectedCategory).toList();
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType) {
      case 'BIRTH_CERTIFICATE':
        return Icons.baby_changing_station;
      case 'VACCINATION_CARD':
        return Icons.vaccines;
      case 'DISCHARGE_SUMMARY':
        return Icons.medical_services;
      case 'VACCINE_PROOF':
        return Icons.verified;
      default:
        return Icons.description;
    }
  }

  Color _getDocumentColor(String documentType) {
    switch (documentType) {
      case 'BIRTH_CERTIFICATE':
        return Colors.blue;
      case 'VACCINATION_CARD':
        return AppTheme.successColor;
      case 'DISCHARGE_SUMMARY':
        return Colors.purple;
      case 'VACCINE_PROOF':
        return AppTheme.warningColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = ['All', 'BIRTH_CERTIFICATE', 'VACCINATION_CARD', 'DISCHARGE_SUMMARY', 'VACCINE_PROOF', 'OTHER'];
    final filteredDocs = _filteredDocuments;

    return Column(
      children: [
        // Category Filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.replaceAll('_', ' ')),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                ),
              );
            },
          ),
        ),

        // Documents List
        Expanded(
          child: filteredDocs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No documents found',
                        style: AppTextStyles.body2.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final iconColor = _getDocumentColor(doc.documentType);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_getDocumentIcon(doc.documentType), color: iconColor),
                        ),
                        title: Text(doc.title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.documentType.replaceAll('_', ' ')),
                            if (doc.description != null)
                              Text(doc.description!, style: AppTextStyles.caption),
                            Text(
                              'Uploaded: ${doc.createdAt.toString().split(' ')[0]}',
                              style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(Icons.download),
                                  SizedBox(width: 8),
                                  Text('Download'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'download') {
                              // Download logic
                            } else if (value == 'delete') {
                              // Delete logic
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}







