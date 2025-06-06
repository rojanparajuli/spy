// class LocationService : Service() {

//     private lateinit var locationManager: LocationManager
//     private var userId: String? = null

//     override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//         userId = intent?.getStringExtra("userId")
//         startForeground(1, createNotification())

//         locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

//         startLocationUpdates()

//         return START_STICKY
//     }

//     private fun startLocationUpdates() {
//         val handler = Handler(Looper.getMainLooper())
//         val runnable = object : Runnable {
//             override fun run() {
//                 sendLocation()
//                 handler.postDelayed(this, 60 * 1000)
//             }
//         }
//         handler.post(runnable)
//     }

//     private fun sendLocation() {
//         if (userId == null) return

//         try {
//             val location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
//                 ?: return

//             val latitude = location.latitude
//             val longitude = location.longitude
//             Log.d("LocationService", "User ID: $userId, Latitude: $latitude, Longitude: $longitude")

//         } catch (e: SecurityException) {
//             Log.e("LocationService", "Permission denied for location access", e)
//         }
//     }

//     private fun createNotification(): Notification {
//         val channelId = "location_channel"
//         val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//             val channel = NotificationChannel(channelId, "Location Service", NotificationManager.IMPORTANCE_LOW)
//             manager.createNotificationChannel(channel)
//         }

//         return NotificationCompat.Builder(this, channelId)
//             .setContentTitle("Location Tracking")
//             .setContentText("Sending location in background...")
//             .setSmallIcon(R.drawable.ic_launcher_foreground)
//             .build()
//     }

//     override fun onBind(intent: Intent?): IBinder? = null
// }
