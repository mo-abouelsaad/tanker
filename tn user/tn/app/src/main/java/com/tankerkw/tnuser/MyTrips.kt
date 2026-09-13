package com.tankerkw.tnuser

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_my_trips.*
import java.sql.Timestamp

class MyTrips : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_my_trips)
        val db = FirebaseFirestore.getInstance()
        val sharedPreferences = getSharedPreferences(
            "PREFERENCE_NAME",
            Context.MODE_PRIVATE
        )
        val phone = sharedPreferences.getString("phone", null)
        db.collection("trips")
            .whereEqualTo("phoneu", phone)
            .get()
            .addOnSuccessListener { documents ->
                var x = 0
                var arr = arrayOfNulls<trips>(documents.count())

                for (document in documents) {

                    arr[x] = trips(
                        document.data["day"] as com.google.firebase.Timestamp,
                        document.id.toString(),
                        document.data["phoneu"].toString(),
                        document.data["price"].toString()
                    )
                    x++

                }
                val myListAdapter = adapter(this, arr)
                listView.adapter = myListAdapter
                if (arr.count() < 1) {
                    val dialogBuilder = AlertDialog.Builder(this)

                    // set message of alert dialog
                    dialogBuilder.setMessage("you didnt Booked a Trip till now ")
                        // if the dialog is cancelable
                        .setCancelable(false)
                        // positive button text and action
                        .setPositiveButton(
                            "Proceed",
                            DialogInterface.OnClickListener { dialog, id ->
                                null
                            })
                        // negative button text and action
                        .setNegativeButton("Cancel", DialogInterface.OnClickListener { dialog, id ->
                            dialog.cancel()
                        })

                    // create dialog box
                    val alert = dialogBuilder.create()
                    // set title for alert dialog box
                    alert.setTitle("Error")
                    // show alert dialog
                    alert.show()
                }


                listView.setOnItemClickListener() { adapterView, view, position, id ->
                    val itemAtPos = adapterView.getItemAtPosition(position)
                    val itemIdAtPos = adapterView.getItemIdAtPosition(position)
                    Toast.makeText(
                        this,
                        "Click on item at $itemAtPos its item id $itemIdAtPos",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
    }
}

