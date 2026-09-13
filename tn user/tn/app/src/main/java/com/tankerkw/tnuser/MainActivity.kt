package com.tankerkw.tnuser

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import io.reactivex.disposables.Disposable
import kotlinx.android.synthetic.main.activity_main.*
import retrofit2.Call
import retrofit2.Response
import com.google.firebase.firestore.FirebaseFirestore
import retrofit2.Callback


class MainActivity : AppCompatActivity() {
    lateinit var auth: FirebaseAuth
    public var verify: String = ""
    var disposable: Disposable? = null
    val randomInteger = (10000..99999).shuffled().first()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val db = FirebaseFirestore.getInstance()
        auth = FirebaseAuth.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        val phone = sharedPreferences.getString("phone", null)
        if (phone != null) {
            val intent = Intent(this, HomePAge::class.java)
            startActivity(intent)

        }
        getcode.setOnClickListener {
            db.collection("user")
                .whereEqualTo("phone", Mob.text.toString())
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        if (task.result?.documents?.count()!! > 0) {

                            val cities = ArrayList<user?>()
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            cities.add(city)
                            var id = task.result?.first()?.id.toString()
                            val data: HashMap<String, Any> = hashMapOf(
                                "authtoken" to randomInteger,
                                "fname" to fname.text.toString(),
                                "lname" to lname.text.toString(),
                                "phone" to Mob.text.toString()


                            )
                            db.collection("user").document(id).update(data)

                            var message = "your activation code is " + randomInteger
                            ServiceBuilder.instance.sms("+965"+Mob.text.toString(), message)
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
                                        Toast.makeText(
                                            applicationContext,
                                            response.body()?.result,
                                            Toast.LENGTH_LONG
                                        ).show()

                                    }

                                })
                        }
                        else {
                            val data: HashMap<String, Any> = hashMapOf(
                                "authtoken" to randomInteger,
                                "fname" to fname.text.toString(),
                                "lname" to lname.text.toString(),
                                "online" to "online",
                                "phone" to Mob.text.toString()


                            )
                            var message = "your activation code is " + randomInteger
                            ServiceBuilder.instance.sms("+965"+Mob.text.toString(), message)
                                .enqueue(object : Callback<result> {
                                    override fun onFailure(call: Call<result>, t: Throwable) {
                                        Toast.makeText(applicationContext, t.message, Toast.LENGTH_LONG)
                                            .show()
                                    }

                                    override fun onResponse(
                                        call: Call<result>,
                                        response: Response<result>
                                    ) {
                                        Toast.makeText(
                                            applicationContext,
                                            response.body()?.result,
                                            Toast.LENGTH_LONG
                                        ).show()

                                    }

                                })
                            db.collection("user").add(data)
                        }
                    }
                }
        }

        submit.setOnClickListener {
            db.collection("user")
                .whereEqualTo("phone", Mob.text.toString())
                .whereEqualTo("authtoken", code.text.toString().toInt())
                .get()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful()) {
                        val cities = ArrayList<user?>()
                        if(!task.getResult()!!.isEmpty()){
                            val city: user? = task.result?.first()?.toObject(user::class.java)
                            var token = code.text.toString().toLong()
                            if (city?.authtoken == token) {
                                val intent = Intent(this, HomePAge::class.java)
                                val sharedPreference = getSharedPreferences(
                                    "PREFERENCE_NAME",
                                    Context.MODE_PRIVATE
                                )
                                var editor = sharedPreference.edit()
                                editor.putString("phone", Mob.text.toString())
                                editor.commit()
                                startActivity(intent)
                            }
                        } else {
                            val snack =
                                Snackbar.make(it, "Invalid Code Number", Snackbar.LENGTH_LONG)
                            snack.show()

                        }
                    }

                }
        }



    }
}



