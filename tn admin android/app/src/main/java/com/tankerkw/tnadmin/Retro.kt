package com.tankerkw.tnadmin

import retrofit2.Call
import retrofit2.http.*

interface Retro {
    @FormUrlEncoded
    @POST("/sms")
    fun sms(
        @Field("phone") drid:String,
        @Field("message") msg:String

        ): Call<result>
    @FormUrlEncoded
    @POST("/firebase/notificationuser")
    fun noti(
        @Field("token") token:String

    ): Call<result>


}