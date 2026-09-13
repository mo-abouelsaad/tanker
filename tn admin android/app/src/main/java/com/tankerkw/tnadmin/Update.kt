package com.tankerkw.tnadmin

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_update.*

class Update : AppCompatActivity() {
    val qty  = arrayOf("3000", "5000","10000")
    val qty2  = arrayOf("تنكر ماء", "تنكر صرف","تنكر ديزل")
    var selected = "3000"
    var selected2 = "تنكر ماء"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update)
        val aa = ArrayAdapter(this,R.layout.spinnerlayout, qty)
        // Set layout to use when the list of choices appear
        aa.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        // Set Adapter to Spinner
        spinner!!.setAdapter(aa)
        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>,
                view: View,
                position: Int,
                id: Long
            ) {
                selected = qty[position].toString()
            }

            override fun onNothingSelected(parent: AdapterView<*>) {
                // Another interface callback
            }
        }
        val bb = ArrayAdapter(this,R.layout.spinnerlayout, qty2)
        // Set layout to use when the list of choices appear
        bb.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        // Set Adapter to Spinner
        spinner2!!.setAdapter(bb)
        spinner2.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>,
                view: View,
                position: Int,
                id: Long
            ) {
                selected2 = qty2[position].toString()
            }

            override fun onNothingSelected(parent: AdapterView<*>) {
                // Another interface callback
            }
        }
        up.setOnClickListener {
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
                                "email" to Email.text.toString(),
                                "qty" to selected.toString(),
                                "cat" to selected2.toString()
                            )
                            db.collection("provider").document(id).update(data)
                            Toast.makeText(this,"Data Updated Successfully",Toast.LENGTH_SHORT).show()
                        }
                    }
                }
        }
    }
}
