package com.tankerkw.tnuser

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.*
import java.text.SimpleDateFormat
import java.util.*

class tankeradapter(private val context: Activity, private val arr: Array<tankers?>)
    : ArrayAdapter<tankers>(context, R.layout.tanker_layout, arr) {


    override fun getView(position: Int, view: View?, parent: ViewGroup): View {
        val inflater = context.layoutInflater
        val rowView = inflater.inflate(R.layout.tanker_layout, null, true)

        val name = rowView.findViewById(R.id.name) as TextView
        val img = rowView.findViewById(R.id.img) as ImageView
        name.text = arr[position]?.name
        img.setImageResource(arr[position]?.img!!)

        return rowView
    }
}