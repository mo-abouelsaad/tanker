package com.tankerkw.tnadmin

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_reservation.*
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.location.Location
import android.net.Uri
import android.widget.Toast
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import kotlinx.android.synthetic.main.activity_update.*
import kotlinx.android.synthetic.main.custom_list.view.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import kotlin.math.round


class Reservation : AppCompatActivity() {
    var long = 0.toDouble()
    var lat = 0.toDouble()
    var long2 = 0.toDouble()
    var lat2 = 0.toDouble()
    internal lateinit var mLastLocation: Location
    internal lateinit var mLocationResult: LocationRequest
    private lateinit var mLocationCallback: LocationCallback
    internal lateinit var mLocationRequest: LocationRequest
    internal var fusedLocationClient: FusedLocationProviderClient? = null

    internal var mCurrLocationMarker: Marker? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_reservation)
        val db = FirebaseFirestore.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        val phone = sharedPreferences.getString("phone", null)
        db.collection("trips")
            .whereEqualTo("phonep", phone)
            .whereEqualTo("ip", "true")

            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful()) {
                    if (task.result?.documents?.count()!! > 0) {


                        if (task.result?.first()?.id.toString() != null) {
                            lat = task.result?.first()?.data!!["latu"].toString().toDouble()
                            long = task.result?.first()?.data!!["longu"].toString().toDouble()

                        }
                    }
                }
            }


        mLocationRequest = LocationRequest()
        mLocationRequest.interval = 1000
        mLocationRequest.fastestInterval = 1000
        mLocationRequest.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
            fusedLocationClient!!.lastLocation
                .addOnSuccessListener { location: Location? ->
                    mLastLocation = location!!
                    if (mCurrLocationMarker != null) {
                        mCurrLocationMarker!!.remove()
                    }
                    //Place current location marker
                    val latLng = LatLng(location.latitude, location.longitude)
                    lat2=location.latitude
                    long2 = location.longitude
                    val db = FirebaseFirestore.getInstance()
                    val sharedPreferences = getSharedPreferences(
                        "PREFERENCE_NAME",
                        Context.MODE_PRIVATE
                    )
                    val phone = sharedPreferences.getString("phone", null)
                    db.collection("trips")
                        .whereEqualTo("phonep", phone)
                        .whereEqualTo("ip", "true")
                        .get()
                        .addOnCompleteListener { task ->
                            if (task.isSuccessful()) {
                                if (task.result?.documents?.count()!! > 0) {

                                    if (task.result?.first()?.id.toString() != null) {
                                        lat = task.result?.first()?.data!!["latu"].toString()
                                            .toDouble()
                                        long = task.result?.first()?.data!!["longu"].toString()
                                            .toDouble()
                                    }
                                }
                            }
                        }
                }
        }
        var  loc1 = Location("m")
        loc1.latitude = lat
        loc1.longitude = long

        var loc2 = Location("m")
        loc2.latitude = lat2
        loc2.longitude = long2
        var  distanceInMeters = loc2.distanceTo(loc1)
        if(distanceInMeters<1000){
            EndTrip.alpha = 1.toFloat()
        }

        directions.setOnClickListener{
            val uri =
                "http://maps.google.com/maps?saddr=" + lat2 + "," + long2 + "&daddr=" + lat.toString() + "," + long.toString()
            val intent = Intent(android.content.Intent.ACTION_VIEW, Uri.parse(uri))
            intent.setClassName(
                "com.google.android.apps.maps",
                "com.google.android.maps.MapsActivity"
            )
            startActivity(intent)
        }
        EndTrip.setOnClickListener{
            db.collection("trips")
                .whereEqualTo("ip", "true")
                .whereEqualTo("phonep", phone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if (task.result?.documents?.count()!!> 0) {
                            var id = task.result?.first()?.id.toString()
                            var phoneu = task.result?.first()?.data!!["phoneu"].toString()
                            val data: HashMap<String, Any> = hashMapOf(
                                "ip" to "false"
                            )
                            db.collection("trips").document(id).update(data)
                            db.collection("user")
                                .whereEqualTo("phone", phoneu)
                                .get()
                                .addOnCompleteListener { task ->
                                    if (task.isSuccessful()) {
                                        ServiceBuilder.instance.noti(task.result?.first()?.data!!["token"].toString())
                                            .enqueue(object : Callback<result> {
                                                override fun onFailure(call: Call<result>, t: Throwable) {
                                                    Toast.makeText(
                                                        applicationContext,
                                                        t.message,
                                                        Toast.LENGTH_LONG
                                                    )
                                                        .show()
                                                }

                                                override fun onResponse(
                                                    call: Call<result>,
                                                    response: Response<result>
                                                ) {
                                                    Toast.makeText(applicationContext,"Order Ended Successfully",
                                                        Toast.LENGTH_LONG).show()
                                                    val intent = Intent(applicationContext, HomePAge::class.java)
                                                    startActivity(intent)

                                                }

                                            })

                                    }
                        }
                    }
                }
        }

        }
    }
}
