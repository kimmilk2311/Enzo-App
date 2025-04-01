import 'package:get/get.dart';

import '../controller/base_controller.dart';
import 'base_widgets.dart';


abstract class BasePage<Controller extends BaseController> extends GetView<Controller> with BaseCustomWidgets {
  const BasePage({super.key});
}
