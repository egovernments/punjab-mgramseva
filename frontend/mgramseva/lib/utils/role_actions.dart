import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class RoleActionsFiltering {
  List<HomeItem> getFilteredModules() {
    return Constants.HOME_ITEMS.where((e) => isEligibleRole(e)).toList();
  }

  bool isEligibleRole(HomeItem item) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var isEligible = true;

    getRolesBasedOnModule(item.link).forEach((element) {
      if (commonProvider.userDetails!.selectedtenant != null) {
        var roles = commonProvider.userDetails?.userRequest?.roles
            ?.where((e) =>
                e.code == element &&
                e.tenantId == commonProvider.userDetails!.selectedtenant!.code)
            .toList();
        if (roles?.isEmpty ?? true) {
          isEligible = false;
        }
      }
    });
    return isEligible;
  }

  List<String> getRolesBasedOnModule(String route) {
    switch (route) {

      // GP Admin
      case Routes.HOUSEHOLD:
        return ['GP_ADMIN'];
      case Routes.CONSUMER_CREATE:
        return ['GP_ADMIN'];
      case Routes.CONSUMER_UPDATE:
        return ['GP_ADMIN'];

      // Expense Processing
      case Routes.EXPENSE_SEARCH:
        return ['EXPENSE_PROCESSING'];
      case Routes.EXPENSES_ADD:
        return ['EXPENSE_PROCESSING'];
      case Routes.EXPENSE_UPDATE:
        return ['EXPENSE_PROCESSING'];

      case Routes.HOUSEHOLDRECEIPTS:
        return ['BULK_DEMAND_PROCESSING'];

      case Routes.MANUAL_BILL_GENERATE:
        return ['BULK_DEMAND_PROCESSING'];

      // Collection Operator
      case Routes.CONSUMER_SEARCH:
        return ['COLLECTION_OPERATOR'];
      case Routes.SEARCH_CONSUMER_RESULT:
        return ['COLLECTION_OPERATOR'];
      case Routes.BILL_GENERATE:
        return ['COLLECTION_OPERATOR'];

      case 'dashboard':
        return [
          'EXPENSE_PROCESSING',
          'SUPERUSER',
          'CITIZEN',
          'WS_DOC_VERIFIER',
          'WS_APPROVER',
          'WS_CLERK',
          'EMPLOYEE',
          'WS_CEMP',
          'WS_FIELD_INSPECTOR',
          'WS_JUNIOR_ENGINEER'
        ];
      default:
        return [];
    }
  }
}
