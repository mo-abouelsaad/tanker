package com.tankerkw.tnuser

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.model.LatLng
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_reserve.*
import kotlin.math.round
import androidx.annotation.NonNull
import com.google.android.gms.tasks.OnFailureListener
import com.google.firebase.firestore.DocumentReference
import com.google.android.gms.tasks.OnSuccessListener
import android.R.attr.data
import android.R.attr.primaryContentAlpha
import android.content.Context
import android.content.Intent
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.activity_update.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


class Reserve : AppCompatActivity() {
    internal var fusedLocationClient: FusedLocationProviderClient? = null
    internal lateinit var mLocationRequest: LocationRequest
    var prce = 0.toFloat()
    var  loc2 = Location("")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_reserve)
        val intent = getIntent()
        var type = intent.getStringExtra("type")
        var pphone = intent.getStringExtra("pphone")
        val db = FirebaseFirestore.getInstance()

        if(type=="water"){
            var qty = intent.getStringExtra("qty")

            db.collection("provider")
                .whereEqualTo("phone", pphone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if(task.result?.documents?.count()!! > 0){

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)

                            name.text = city!!.fname + " " + city!!.lname
                            mob.text = pphone
                            litre.text = qty
                            mLocationRequest = LocationRequest()
                            mLocationRequest.interval = 1000
                            mLocationRequest.fastestInterval = 1000
                            mLocationRequest.priority =
                                LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
                            if (ContextCompat.checkSelfPermission(
                                    this,
                                    Manifest.permission.ACCESS_FINE_LOCATION
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                fusedLocationClient =
                                    LocationServices.getFusedLocationProviderClient(this)
                                fusedLocationClient!!.lastLocation
                                    .addOnSuccessListener { location: Location? ->
                                        val loc1 = Location("m")
                                        loc1.latitude = location!!.latitude
                                        loc1.longitude = location!!.longitude

                                         loc2 = Location("m")
                                        loc2.latitude = city.lat
                                        loc2.longitude = city.long
                                        var  distanceInMeters = loc2.distanceTo(loc1)
                                        if(distanceInMeters < 1){
                                            distanceInMeters = 1.0.toFloat()
                                        }else{
                                         distanceInMeters = round(distanceInMeters)
                                        }
                                         prce = (qty.toInt()*5 + (distanceInMeters/1000)*250)/1000
                                        price.text = "تكلفة الطلب : " + round(prce) + "KD"


                                    }
                            }
                        }
                    }
                }
        }else if(type=="diesel"){
            var qty = intent.getStringExtra("qty")

            db.collection("provider")
                .whereEqualTo("phone", pphone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if (task.result?.first()?.id.toString() != null) {

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)

                            name.text = city!!.fname + " " + city!!.lname
                            mob.text = pphone
                            litre.text = qty
                            mLocationRequest = LocationRequest()
                            mLocationRequest.interval = 1000
                            mLocationRequest.fastestInterval = 1000
                            mLocationRequest.priority =
                                LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
                            if (ContextCompat.checkSelfPermission(
                                    this,
                                    Manifest.permission.ACCESS_FINE_LOCATION
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                fusedLocationClient =
                                    LocationServices.getFusedLocationProviderClient(this)
                                fusedLocationClient!!.lastLocation
                                    .addOnSuccessListener { location: Location? ->
                                        val loc1 = Location("m")
                                        loc1.latitude = location!!.latitude
                                        loc1.longitude = location!!.longitude

                                         loc2 = Location("m")
                                        loc2.latitude = city.lat
                                        loc2.longitude = city.long
                                        var  distanceInMeters = loc2.distanceTo(loc1)
                                        if(distanceInMeters < 1){
                                            distanceInMeters = 1.0.toFloat()
                                        }else{
                                            distanceInMeters = round(distanceInMeters)
                                        }
                                        Toast.makeText(this,distanceInMeters.toString(),Toast.LENGTH_SHORT).show()
                                         prce = (qty.toInt()*120 + (distanceInMeters/1000)*250)/1000
                                        price.text = "تكلفة الطلب : " + round(prce) + "KD"


                                    }
                            }
                        }
                    }
                }
        }
        else{

            db.collection("provider")
                .whereEqualTo("phone", pphone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if(!task.getResult()!!.isEmpty()){

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)

                            name.text = city!!.fname + " " + city!!.lname
                            mob.text = pphone
                            litre.text = ""
                            mLocationRequest = LocationRequest()
                            mLocationRequest.interval = 1000
                            mLocationRequest.fastestInterval = 1000
                            mLocationRequest.priority =
                                LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
                            if (ContextCompat.checkSelfPermission(
                                    this,
                                    Manifest.permission.ACCESS_FINE_LOCATION
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                fusedLocationClient =
                                    LocationServices.getFusedLocationProviderClient(this)
                                fusedLocationClient!!.lastLocation
                                    .addOnSuccessListener { location: Location? ->
                                        val loc1 = Location("m")
                                        loc1.latitude = location!!.latitude
                                        loc1.longitude = location!!.longitude

                                         loc2 = Location("m")
                                        loc2.latitude = city.lat
                                        loc2.longitude = city.long
                                        var  distanceInMeters = loc2.distanceTo(loc1)
                                        if(distanceInMeters < 1){
                                            distanceInMeters = 1.0.toFloat()
                                        }else{
                                            distanceInMeters = round(distanceInMeters)
                                        }
                                        Toast.makeText(this,distanceInMeters.toString(),Toast.LENGTH_SHORT).show()
                                         prce = (18000 + (distanceInMeters/1000)*250)/1000
                                        price.text = "تكلفة الطلب : " + prce + "KD"


                                    }
                            }
                        }
                    }
                }
        }
        paycash.setOnClickListener{
            val sharedPreferences = getSharedPreferences(
                "PREFERENCE_NAME",
                Context.MODE_PRIVATE
            )
            val phone = sharedPreferences.getString("phone", null)
            val data: HashMap<String, Any> = hashMapOf(
                "date" to Date(),
                "longu" to  loc2.longitude,
            "latu" to  loc2.latitude,
            "phoneu" to phone!!,
            "phonep" to pphone,
            "day" to Date(),
            "ip" to "true",
            "price" to  prce
            )
            db.collection("trips")
                .add(data)
                .addOnSuccessListener { documentReference ->
                    db.collection("provider")
                        .whereEqualTo("phone", pphone)
                        .get()
                        .addOnCompleteListener { task ->
                            if (task.isSuccessful()) {
                                if(!task.getResult()!!.isEmpty()){

                                    val city: user? =
                                        task.result?.first()?.toObject(user::class.java)
                                    ServiceBuilder.instance.noti(city!!.token!!)
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
                                                Toast.makeText(applicationContext,"Order Succeeded",Toast.LENGTH_LONG).show()
                                                val intent = Intent(applicationContext, Map2::class.java)
                                                startActivity(intent)


                                            }

                                        })
                                }
                                }
                            }
                        }

                }
        paykent.setOnClickListener{
            var intent = Intent(this,PayOnline::class.java)
            intent.putExtra("price",round(prce))
            intent.putExtra("pphone",pphone)
            startActivity(intent)
        }
        }
    }

