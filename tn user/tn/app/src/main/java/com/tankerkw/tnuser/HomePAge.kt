package com.tankerkw.tnuser

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.iid.FirebaseInstanceId
import kotlinx.android.synthetic.main.activity_home_page2.*
import kotlinx.android.synthetic.main.activity_home_page2.listView
import kotlinx.android.synthetic.main.activity_my_trips.*
import kotlinx.android.synthetic.main.activity_update.*
import java.io.IOException

class HomePAge : AppCompatActivity() {
    var arr = arrayOfNulls<tankers>(3)
    var type = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home_page2)
        arr[0]= tankers(getString(R.string.water),R.drawable.water)
        arr[1]= tankers(getString(R.string.weser),R.drawable.sarf)
        arr[2]= tankers(getString(R.string.diesel),R.drawable.diesel)
        val myListAdapter = tankeradapter(this,arr)
        listView.adapter = myListAdapter
        initView()
        val db = FirebaseFirestore.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        val phone = sharedPreferences.getString("phone", null)
        db.collection("trips")
            .whereEqualTo("phoneu", phone)
            .whereEqualTo("ip", "true")
            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful()) {
                    if(task.result?.documents?.count()!! > 0){
                        val intent = Intent(this, Map2::class.java)
                        startActivity(intent)


                    }
                }
            }
                    update.setOnClickListener {
                        val intent = Intent(this, Update::class.java)
                        startActivity(intent)


                    }


                    listView.setOnItemClickListener() { adapterView, _, position, _ ->
                        val itemAtPos = adapterView.getItemIdAtPosition(position)
                        if (itemAtPos.toString() == "0") {
                            type = "water"
                            val intent = Intent(this, QTY::class.java)
                            intent.putExtra("type", type)
                            startActivity(intent)
                        } else if (itemAtPos.toString() == "2") {
                            type = "diesel"
                            val intent = Intent(this, QTY::class.java)
                            intent.putExtra("type", type)
                            startActivity(intent)
                        } else {
                            type = "sarf"
                            val intent = Intent(this, Map::class.java)
                            intent.putExtra("type", type)
                            startActivity(intent)
                        }

                    }
                    orders.setOnClickListener {
                        val intent = Intent(this, MyTrips::class.java)
                        startActivity(intent)
                    }
                    about.setOnClickListener {
                        val intent = Intent(this, About::class.java)
                        startActivity(intent)
                    }
                    support.setOnClickListener {
                        val intent = Intent(this, Support::class.java)
                        startActivity(intent)
                    }
                    Logout.setOnClickListener {
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

                    db.collection("user")
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
                                    db.collection("user").document(id).update(data)
                                }
                            }
                        }
        })
        }).start()
    }
}
