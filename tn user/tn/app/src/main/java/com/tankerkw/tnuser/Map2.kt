package com.tankerkw.tnuser
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions
import android.Manifest
import android.content.Context
import android.content.Intent
import android.os.Looper
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.google.android.gms.location.*
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_my_trips.*
import kotlinx.android.synthetic.main.activity_update.*


class Map2 : FragmentActivity(), OnMapReadyCallback, LocationListener,
    GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener ,
    GoogleMap.OnMarkerClickListener {

    private var mMap: GoogleMap? = null
    internal lateinit var mLastLocation: Location
    internal lateinit var mLocationResult: LocationRequest
    private lateinit var mLocationCallback: LocationCallback
    internal var mCurrLocationMarker: Marker? = null
    internal var mGoogleApiClient: GoogleApiClient? = null
    internal lateinit var mLocationRequest: LocationRequest
    internal var fusedLocationClient: FusedLocationProviderClient? = null
    var type = ""
    var qty = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_map_activity)
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
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
                    if(!task.getResult()!!.isEmpty()){

                        var phonep = task.result?.first()?.data!!["phonep"].toString()
                        db.collection("provider")
                            .whereEqualTo("phone", phonep)
                            .get()
                            .addOnCompleteListener { task ->
                                if (task.isSuccessful()) {
                                    if(!task.getResult()!!.isEmpty()){
                                        var id = task.result?.first()?.id.toString()
                                        val docRef = db.collection("provider").document(id)
                                        docRef.addSnapshotListener { snapshot, e ->
                                            if (e != null) {
                                                return@addSnapshotListener
                                            }

                                            if (snapshot != null && snapshot.exists()) {
                                                var lat= snapshot.data!!["lat"].toString().toDouble()
                                                var long= snapshot.data!!["long"].toString().toDouble()
                                                val latLng = LatLng(lat, long)
                                                val markerOptions = MarkerOptions()
                                                markerOptions.position(latLng)
                                                markerOptions.title("Current Position")
                                                markerOptions.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN))
                                                mCurrLocationMarker = mMap!!.addMarker(markerOptions)

                                                //move map camera
                                                mMap!!.moveCamera(CameraUpdateFactory.newLatLng(latLng))
                                                mMap!!.animateCamera(CameraUpdateFactory.zoomTo(11f))
                                            } else {
                                            }
                                        }
                                    }
                                    }
                            }
                    }
                }
            }




    }

    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                buildGoogleApiClient()
                mMap!!.isMyLocationEnabled = true
            }
        } else {
            buildGoogleApiClient()
            mMap!!.isMyLocationEnabled = true
        }

    }

    @Synchronized
    protected fun buildGoogleApiClient() {
        mGoogleApiClient = GoogleApiClient.Builder(this)
            .addConnectionCallbacks(this)
            .addOnConnectionFailedListener(this)
            .addApi(LocationServices.API).build()
        mGoogleApiClient!!.connect()
    }

    override fun onConnected(bundle: Bundle?) {

    }

    override fun onMarkerClick(p0: Marker?): Boolean {

        val intent = Intent(this, Reserve::class.java)
        intent.putExtra("pphone",p0!!.tag.toString())
        intent.putExtra("type",type)
        intent.putExtra("qty",qty)
        startActivity(intent)

        return true
    }

    override fun onLocationChanged(location: Location) {


    }

    override fun onConnectionFailed(connectionResult: ConnectionResult) {
        Toast.makeText(applicationContext,"connection failed", Toast.LENGTH_SHORT).show()
    }

    override fun onConnectionSuspended(p0: Int) {
        Toast.makeText(applicationContext,"connection suspended", Toast.LENGTH_SHORT).show()
    }

}