import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/profile_controller.dart';
import 'package:linkable/controllers/validation_controller.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final ValidationController validationController = Get.put(ValidationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildUserInfo(),
              const SizedBox(height: 40),
              _buildIntegrationsSection(),
              const SizedBox(height: 40),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 32,
                color: LightColors.mainTextColor,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account',
              style: TextStyle(
                fontSize: 16,
                color: LightColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LightColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LightColors.border),
          ),
          child: InkWell(
            onTap: controller.logout,
            child: Icon(
              Icons.logout,
              color: LightColors.secondaryText,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                color: LightColors.mainTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () => controller.showUpdateBottomSheet(Get.context!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: LightColors.mainTextColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: LightColors.background,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        color: LightColors.background,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildInfoGrid(),
      ],
    ));
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoField(
                'Name', 
                controller.userDetails.value!.name,
                Icons.person_outline,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInfoField(
                'Surname', 
                controller.userDetails.value!.surname,
                Icons.badge_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildInfoField(
          'Email', 
          controller.userDetails.value!.email,
          Icons.mail_outlined,
        ),
        const SizedBox(height: 10),
        _buildInfoField(
          'Phone', 
          controller.userDetails.value!.phoneNumber.combined,
          Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: LightColors.secondaryText,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: LightColors.secondaryText,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: LightColors.mainTextColor,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Integrations',
          style: TextStyle(
            fontSize: 18,
            color: LightColors.mainTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Connect your favorite productivity tools',
          style: TextStyle(
            fontSize: 14,
            color: LightColors.secondaryText,
          ),
        ),
        const SizedBox(height: 16),
        _buildIntegrationItem(
          title: 'Notion',
          subtitle: 'Sync your notes and databases',
          icon: Icons.article_outlined,
          isConnected: false,
          onTap: () {
            // TODO: Implement Notion integration
          },
        ),
        const SizedBox(height: 12),
        _buildIntegrationItem(
          title: 'Raindrop',
          subtitle: 'Save and organize your bookmarks',
          icon: Icons.bookmark_outline,
          isConnected: false,
          onTap: () {
            // TODO: Implement Raindrop integration
          },
        ),
      ],
    );
  }

  Widget _buildIntegrationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isConnected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LightColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LightColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: LightColors.mainTextColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: LightColors.mainTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: LightColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isConnected ? Colors.green.withOpacity(0.1) : LightColors.accent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isConnected ? Colors.green.withOpacity(0.3) : LightColors.border,
                ),
              ),
              child: Text(
                isConnected ? 'Connected' : 'Connect',
                style: TextStyle(
                  fontSize: 12,
                  color: isConnected ? Colors.green.shade700 : LightColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            color: LightColors.mainTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          title: 'Privacy & Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LightColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LightColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: LightColors.secondaryText,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: LightColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: LightColors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
