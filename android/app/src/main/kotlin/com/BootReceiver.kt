// package com.anjesh.spy

// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.os.Build


// class BootReceiver : BroadcastReceiver() {
//     override fun onReceive(context: Context, intent: Intent) {
//         if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
//             val prefs = context.getSharedPreferences("spy_prefs", Context.MODE_PRIVATE)
//             val userId = prefs.getString("userId", null)

//             if (!userId.isNullOrEmpty()) {
//                 val serviceIntent = Intent(context, LocationService::class.java).apply {
//                     putExtra("userId", userId)
//                 }
//                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                     context.startForegroundService(serviceIntent)
//                 } else {
//                     context.startService(serviceIntent)
//                 }
//             }
//         }
//     }
// }
