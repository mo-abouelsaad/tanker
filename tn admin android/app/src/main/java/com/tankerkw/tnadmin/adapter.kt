package com.tankerkw.tnadmin

import android.app.Activity
import android.icu.util.UniversalTimeScale.toLong
import android.view.View
import android.view.ViewGroup
import android.widget.*
import kotlinx.android.synthetic.main.custom_list.view.*
import java.text.SimpleDateFormat
import java.util.*

class adapter(private val context: Activity, private val arr: Array<trips?>)
    : ArrayAdapter<trips>(context, R.layout.custom_list, arr) {


    override fun getView(position: Int, view: View?, parent: ViewGroup): View {
        val inflater = context.layoutInflater
        val rowView = inflater.inflate(R.layout.custom_list, null, true)

        val day = rowView.findViewById(R.id.day) as TextView
        val id = rowView.findViewById(R.id.ID) as TextView
        val price = rowView.findViewById(R.id.price) as TextView
        val phoneu = rowView.findViewById(R.id.phoneu) as TextView

        day.text = "Day : "+ arr[position]?.day!!.toDate().toString()
        id.text ="Order ID : "+ arr[position]?.id
        price.text = "Price : "+arr[position]?.price
        phoneu.text = "User Phone : "+arr[position]?.phoneu

        return rowView
    }
}