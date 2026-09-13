package com.tankerkw.tnuser

import retrofit2.Call
import retrofit2.http.*

interface Retro {
    @FormUrlEncoded
    @POST("/sms")
    fun sms(
        @Field("phone") phone:String,
        @Field("message") message:String

        ): Call<result>
    @FormUrlEncoded
    @POST("/firebase/notification")
    fun noti(
        @Field("token") token:String

    ): Call<result>


}