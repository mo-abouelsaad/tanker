package com.tankerkw.tnuser
import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.net.Uri
import android.os.Bundle
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import kotlinx.android.synthetic.main.activity_pay_online.*

import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices

import com.google.firebase.firestore.FirebaseFirestore
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


class PayOnline : AppCompatActivity() {
    internal var fusedLocationClient: FusedLocationProviderClient? = null
    internal lateinit var mLocationRequest: LocationRequest
    var prce = 0.toFloat()
    var  loc2 = Location("")
    var price = 0.toFloat()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_pay_online)
        val intent = getIntent()
        price  = intent.getFloatExtra("price",0.toFloat())
        val db = FirebaseFirestore.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        val phone = sharedPreferences.getString("phone", null)
        val pphone = intent.getStringExtra("pphone")

        db.collection("user")
            .whereEqualTo("phone", phone)
            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful()) {
                    val cities = ArrayList<user?>()
                    if (task.result?.first()?.id.toString() != null) {
                        val city: user? = task.result?.first()?.toObject(user::class.java)
                        val webSettings = webview.getSettings()
                        webSettings.setJavaScriptEnabled(true)
                        webview.loadUrl("https://paytn.sky-tech-eg.com/index.php?price="+price+"&name="+city!!.fname+""+city!!.lname+"&phone="+city.phone)
                        }
                    }
                }


        webview.setWebViewClient(object : WebViewClient() {
            override fun onPageFinished(view: WebView, weburl: String) {
                if(weburl.contains("https://paytn.sky-tech-eg.com/success.php")){
                    val sharedPreferences = getSharedPreferences(
                        "PREFERENCE_NAME",
                        Context.MODE_PRIVATE
                    )
                    val phone = sharedPreferences.getString("phone", null)
                    mLocationRequest = LocationRequest()
                    mLocationRequest.interval = 1000
                    mLocationRequest.fastestInterval = 1000
                    mLocationRequest.priority =
                        LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
                    if (ContextCompat.checkSelfPermission(
                            applicationContext,
                            Manifest.permission.ACCESS_FINE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        fusedLocationClient =
                            LocationServices.getFusedLocationProviderClient(applicationContext)
                        fusedLocationClient!!.lastLocation
                            .addOnSuccessListener { location: Location? ->
                                val loc1 = Location("m")
                                loc1.latitude = location!!.latitude
                                loc1.longitude = location!!.longitude

                                loc2 = Location("m")
                                loc2.latitude = location.latitude
                                loc2.longitude = location.longitude
                            }
                    }
                    val data: HashMap<String, Any> = hashMapOf(
                        "date" to Date(),
                        "longu" to  loc2.longitude,
                        "latu" to  loc2.latitude,
                        "phoneu" to phone!!,
                        "phonep" to pphone,
                        "day" to Date(),
                        "ip" to "true",
                        "price" to  price
                    )
                    db.collection("trips")
                        .add(data)
                        .addOnSuccessListener { documentReference ->
                            val intent = Intent(applicationContext, Map2::class.java)
                            startActivity(intent)
                        }
                }
            }
        })
}
}
