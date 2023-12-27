import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/auth_update_password_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/reauthentication_page.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/modals/mighty_snack_bar.dart';
import 'package:my_time/foundation/core/modals/modal_bottom_sheet_ui.dart';

/// A page widget representing the profile page.
class ProfilePage extends ConsumerWidget {
  /// Constructs a [ProfilePage].
  const ProfilePage({super.key});

  Future<bool?> _showAuthenticationSheet(BuildContext context) async {
    return ModalBottomSheetUI.showPage<bool>(
      context: context,
      widget: ReauthenticationPage(),
    );
  }

  Future<void> _showUpdatePasswordSheet(BuildContext context) async {
    final isSuccess = await ModalBottomSheetUI.showPage<bool>(
          context: context,
          widget: const AuthUpdatePasswordPage(),
        ) ??
        false;

    if (!isSuccess) return;
    if (!context.mounted) return;

    SnackBarPopUp.show(
      context,
      context.loc.profilePasswordChangedSnackbarMessage,
    );
  }

  Future<bool?> _showDeleteConfirmationSheet(BuildContext context) async {
    return ModalBottomSheetUI.showConfirmationSheet(
      context: context,
      title: context.loc.profileDeleteAccountDialogHeader,
      message: context.loc.profileDeleteAccountDialogContent,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.profilePageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
          child: CustomScrollView(
            physics: const RangeMaintainingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(context.loc.profileChangePasswordBtnLabel),
                      leading: const Icon(Icons.password),
                      onTap: () async {
                        final isReauthenticated =
                            await _showAuthenticationSheet(context);

                        if (!context.mounted) return;

                        if (isReauthenticated ?? false) {
                          await _showUpdatePasswordSheet(context);
                        }
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.profileSingOutBtnLabel),
                      leading: const Icon(Icons.logout),
                      onTap: () {
                        ref.read(authRepositoryProvider).signOut();
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    ListTile(
                      title: Text(context.loc.profileDeleteAccountBtnLabel),
                      leading: const Icon(Icons.no_accounts_outlined),
                      onTap: () async {
                        final isReauthenticated =
                            await _showAuthenticationSheet(context) ?? false;
                        if (!isReauthenticated) return;
                        if (!context.mounted) return;

                        final confirmed =
                            await _showDeleteConfirmationSheet(context);
                        if (!context.mounted) return;
                        if (confirmed ?? false) {
                          await ref.read(authRepositoryProvider).deleteUser();
                        }
                      },
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
