//package  com.unihealth.android
//import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//
//object FirebaseCloudMessagingPluginRegistrant {
//    fun registerWith(registry: PluginRegistry?) {
//        if (alreadyRegisteredWith(registry)) {
//            return
//        }
//        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
//    }
//
//    private fun alreadyRegisteredWith(registry: PluginRegistry?): Boolean {
//        val key: String? = FirebaseCloudMessagingPluginRegistrant::class.java.canonicalName
//        if (registry?.hasPlugin(key)!!) {
//            return true
//        }
//        registry.registrarFor(key)
//        return false
//    }
//}
////import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
////import io.flutter.Log
////import io.flutter.plugin.common.PluginRegistry
////
////class FlutterLocalNotificationPluginRegistrant {
////
////    companion object {
////        fun registerWith(registry: PluginRegistry) {
////            if (alreadyRegisteredWith(registry)) {
////                Log.d("Local Plugin", "Already Registered");
////                return
////            }
////            FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
////            Log.d("Local Plugin", "Registered");
////        }
////
////        private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
////            val key = FlutterLocalNotificationPluginRegistrant::class.java.canonicalName
////            if (registry.hasPlugin(key)) {
////                return true
////            }
////            registry.registrarFor(key)
////            return false
////        }
////    }}