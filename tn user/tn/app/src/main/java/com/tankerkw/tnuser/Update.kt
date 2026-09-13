package com.tankerkw.tnuser

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_update.*

class Update : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update)
        up.setOnClickListener {
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
                        if(!task.getResult()!!.isEmpty()){

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)
                            var id = task.result?.first()?.id.toString()
                            val data: HashMap<String, Any> = hashMapOf(
                                "email" to Email.text.toString()
                            )
                            db.collection("provider").document(id).update(data)
                            Toast.makeText(this,"Data Updated Successfully",
                                Toast.LENGTH_SHORT).show()

                        }
                    }
                }
        }
    }
}
