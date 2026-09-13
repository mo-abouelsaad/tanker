package com.tankerkw.tnuser

import android.location.Location

data class User(
    var phone: String? = "",
    var name: String? = "",
    var email: String? = "",
    var address: String? = "",
    var location: Location? = null
)