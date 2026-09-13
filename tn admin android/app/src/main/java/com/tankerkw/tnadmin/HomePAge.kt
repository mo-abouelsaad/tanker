package com.tankerkw.tnadmin

import android.content.Context
import android.content.Intent
import android.location.Location
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.iid.FirebaseInstanceId
import kotlinx.android.synthetic.main.activity_home_page2.*
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.activity_update.*

class HomePAge : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home_page2)
        val db = FirebaseFirestore.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        initView()
        val phone = sharedPreferences.getString("phone", null)
        db.collection("trips")
            .whereEqualTo("phonep", phone)
            .whereEqualTo("ip", "true")
            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful()) {
                    if(task.result?.documents?.count()!! > 0){
                    val    intent = Intent(this,Reservation::class.java)
                        startActivity(intent)

                }
            }
    }
        update.setOnClickListener{
            val intent = Intent(this, Update::class.java)
            startActivity(intent)


        }
        orders.setOnClickListener{
            val intent = Intent(this, MyTrips::class.java)
            startActivity(intent)
        }
        about.setOnClickListener{
            val intent = Intent(this, About::class.java)
            startActivity(intent)
        }
        support.setOnClickListener{
            val intent = Intent(this, Support::class.java)
            startActivity(intent)
        }
        Logout.setOnClickListener{
            val sharedPreference = getSharedPreferences(
                "PREFERENCE_NAME",
                Context.MODE_PRIVATE
            )
            var editor = sharedPreference.edit()
            editor.clear();
            editor.commit()
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
        }
        db.collection("provider")
            .whereEqualTo("phone", phone)
            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful()) {
                    val cities = ArrayList<user?>()
                    if (task.result?.first()?.id.toString() != null) {
                        val city: user? = task.result?.first()?.toObject(user::class.java)
                        if(city!!.online=="online"){
                            online.setImageResource(R.drawable.tankeronline)
                        }else{
                            online.setImageResource(R.drawable.tankeroffline)

                        }

                    }
                }

            }
        online.setOnClickListener{
            db.collection("provider")
                .whereEqualTo("phone", phone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        val cities = ArrayList<user?>()
                        if (task.result?.first()?.id.toString() != null) {
                            var id = task.result?.first()?.id.toString()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            if(city!!.online=="online"){
                                val data: HashMap<String, Any> = hashMapOf(
                                    "online" to "offline"
                                )
                                db.collection("provider").document(id).update(data)
                                online.setImageResource(R.drawable.tankeroffline)
                            }else{
                                val data: HashMap<String, Any> = hashMapOf(
                                    "online" to "online"
                                )
                                db.collection("provider").document(id).update(data)
                                online.setImageResource(R.drawable.tankeronline)
                            }

                        }
                    }

                }
        }
        var gps = MyService(this)

        // check if GPS enabled
        if (gps.canGetLocation()) {

            var latitude = gps.getLatitude();
            var longitude = gps.getLongitude();
        } else {
            // can't get location
            // GPS or Network is not enabled
            // Ask user to enable GPS/network in settings
            gps.showSettingsAlert();
        }
        var loc :Location? = gps.getLocation()
        if (phone != null) {

            val db = FirebaseFirestore.getInstance()
            db.collection("provider")
                .whereEqualTo("phone", phone)
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if (task.result?.count()!!>0) {

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)
                            var id = task.result?.first()?.id.toString()
                            val data: HashMap<String, Any> = hashMapOf(
                                "long" to loc!!.longitude,
                                "lat" to loc!!.latitude
                            )
                            db.collection("provider").document(id).update(data)
                        }
                    }
                }
        }
    }
    private fun initView() {
        //This method will use for fetching Token
        Thread(Runnable {
            FirebaseInstanceId.getInstance().instanceId
                .addOnCompleteListener(OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        Toast.makeText(baseContext, task.exception.toString(), Toast.LENGTH_SHORT).show()
                        return@OnCompleteListener
                    }

                    // Get new Instance ID token
                    val token = task.result?.token

                    // Log and toast
                    val msg = token
                    val sharedPreferences = getSharedPreferences(
                        "PREFERENCE_NAME",
                        Context.MODE_PRIVATE
                    )
                    val phone = sharedPreferences.getString("phone", null)

                    val db = FirebaseFirestore.getInstance()

                    db.collection("provider")
                        .whereEqualTo("phone", phone)
                        .get()
                        .addOnCompleteListener { task ->
                            if (task.isSuccessful()) {
                                if (task.result?.first()?.id.toString() != null) {

                                    val cities = ArrayList<user?>()
                                    val city: user? = task.result?.first()?.toObject(user::class.java)
                                    cities.add(city)
                                    var id = task.result?.first()?.id.toString()
                                    val data: HashMap<String, Any> = hashMapOf(
                                        "token" to msg!!
                                    )
                                    db.collection("provider").document(id).update(data)
                                }
                            }
                        }
                })
        }).start()
    }
}
