// // dashboard_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:poultry/app/constant/app_color.dart';
// import 'package:poultry/app/constant/style.dart';

// import 'package:poultry/app/model/batch_response_model.dart';
// import 'package:poultry/app/modules/dashboard/dashboard_controller.dart';
// import 'package:poultry/app/modules/laying_stage/laying_stage_card.dart';
// // dashboard_page.dart

// class DashboardPage extends StatelessWidget {
//   final controller = Get.put(DashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'Dashboard',
//           style: AppStyles.heading2.copyWith(color: Colors.white),
//         ),
//         backgroundColor: AppColors.primaryColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => controller.fetchBatches(),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: controller.fetchBatches,
//           child: Obx(() {
//             if (controller.isLoading.value) {
//               return Center(child: CircularProgressIndicator());
//             }

//             if (controller.batches.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No active batches found\nAdd a batch from Activity section',
//                   style: AppStyles.bodyText
//                       .copyWith(color: AppColors.textSecondary),
//                   textAlign: TextAlign.center,
//                 ),
//               );
//             }

//             return ListView.builder(
//               padding: EdgeInsets.symmetric(
//                 vertical: Dimens.verticalPadding,
//               ),
//               itemCount: controller.batches.length,
//               itemBuilder: (context, index) {
//                 final batch = controller.batches[index];
//                 return _buildBatchStageCard(batch);
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildBatchStageCard(BatchResponseModel batch) {
//     // If it's a laying stage batch, use the LayingStageCard
//     if (batch.stage?.toLowerCase() == 'layer') {
//       return LayingStageCard(batch: batch);
//     }

//     // For other stages, show simple card
//     return Container(
//       margin: EdgeInsets.only(bottom: Dimens.verticalPadding),
//       decoration: AppStyles.cardDecoration,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(Dimens.cardRadius),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(
//                 vertical: Dimens.smallPadding / 2,
//               ),
//               color: _getStageColor(batch.stage),
//               width: double.infinity,
//               child: Text(
//                 batch.stage ?? 'Unknown Stage',
//                 style: AppStyles.bodyText.copyWith(
//                   color: Colors.white,
//                   fontSize: Dimens.small,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(Dimens.defaultPadding),
//               child: Text(
//                 batch.batchName ?? 'Unnamed Batch',
//                 style: AppStyles.heading2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStageColor(String? stage) {
//     switch (stage?.toLowerCase()) {
//       case 'starter':
//         return Colors.green;
//       case 'grower':
//         return Colors.orange;
//       case 'layer':
//         return AppColors.primaryColor;
//       default:
//         return Colors.grey;
//     }
//   }
// }
