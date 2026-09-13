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
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.os.Handler
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
import kotlinx.android.synthetic.main.activity_home_page2.*
import kotlinx.android.synthetic.main.activity_my_trips.*
import kotlinx.android.synthetic.main.activity_update.*
import java.util.*


class Map : FragmentActivity(), OnMapReadyCallback, LocationListener,
    GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener ,
    GoogleMap.OnMarkerClickListener {
     var tankercount: Int = 0
    private var mMap: GoogleMap? = null
    private val SPLASH_TIME_OUT:Long=3000 // 3 sec

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
        val intent = getIntent()
        type = intent.getStringExtra("type")

        Handler().postDelayed({
            if (tankercount < 1) {

                val dialogBuilder = AlertDialog.Builder(this@Map)

                // set message of alert dialog
                dialogBuilder.setMessage("no tanker available right now please contact support to arrange a trip")
                    // if the dialog is cancelable
                    .setCancelable(false)
                    // positive button text and action
                    .setPositiveButton(
                        "Proceed",
                        DialogInterface.OnClickListener { dialog, id ->
                            gotosupport()
                        })
                    // negative button text and action
                    .setNegativeButton(
                        "Cancel",
                        DialogInterface.OnClickListener { dialog, id ->
                            dialog.cancel()
                        })

                // create dialog box
                val alert = dialogBuilder.create()
                // set title for alert dialog box
                alert.setTitle("Error")
                // show alert dialog
                alert.show()
            }        }, 5000)




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

        mLocationRequest = LocationRequest()
        mLocationRequest.interval = 1000
        mLocationRequest.fastestInterval = 1000
        mLocationRequest.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
            fusedLocationClient!!.lastLocation
                .addOnSuccessListener { location: Location? ->
                    mLastLocation = location!!
                    if (mCurrLocationMarker != null) {
                        mCurrLocationMarker!!.remove()
                    }
                    //Place current location marker
                    val latLng = LatLng(location.latitude, location.longitude)
                    val markerOptions = MarkerOptions()
                    markerOptions.position(latLng)
                    markerOptions.title("Current Position")
                    markerOptions.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN))
                    mCurrLocationMarker = mMap!!.addMarker(markerOptions)

                    //move map camera
                    mMap!!.moveCamera(CameraUpdateFactory.newLatLng(latLng))
                    mMap!!.animateCamera(CameraUpdateFactory.zoomTo(11f))

                    val db = FirebaseFirestore.getInstance()
                    mMap!!.setOnMarkerClickListener(this);

                    if (type == "water") {
                        qty = intent.getStringExtra("qty")

                         db.collection("provider")
                            .whereEqualTo("cat", "تنكر ماء")
                            .whereEqualTo("online", "online")
                            .get()
                            .addOnSuccessListener { documents ->

                                for (document in documents) {
                                    db.collection("trips")
                                        .whereEqualTo("ip", "true")
                                        .whereEqualTo("phonep", document.data!!["phone"])
                                        .get()
                                        .addOnSuccessListener { docs ->
                                            if (docs.documents.count()!! < 1) {
                                                if (document.data["qty"].toString().toInt() > qty.toInt()) {
                                                    val latLng = LatLng(
                                                        document.data["lat"].toString().toDouble(),
                                                        document.data["long"].toString().toDouble()
                                                    )
                                                    var height = 300;
                                                    var width = 300;
                                                    var bitmapdraw =
                                                        getResources().getDrawable(R.drawable.car) as BitmapDrawable
                                                    var b = bitmapdraw.getBitmap();
                                                    var smallMarker = Bitmap.createScaledBitmap(
                                                        b,
                                                        width,
                                                        height,
                                                        false
                                                    );
                                                    var markerOptions = MarkerOptions()
                                                    markerOptions.position(latLng)
                                                    markerOptions.title("Tanker")
                                                    markerOptions.icon(
                                                        BitmapDescriptorFactory.fromBitmap(
                                                            smallMarker
                                                        )
                                                    )
                                                    mCurrLocationMarker =
                                                        mMap!!.addMarker(markerOptions)
                                                    mCurrLocationMarker!!.tag =
                                                        document.data["phone"]
                                                    this.tankercount += 1


                                                }
                                            }


                                        }
                                }

                            }



                    } else if (type == "diesel") {
                        qty = intent.getStringExtra("qty")

                        db.collection("provider")
                            .whereEqualTo("cat", "تنكر ديزل")
                            .whereEqualTo("online", "online")

                            .get()
                            .addOnSuccessListener { documents ->

                                for (document in documents) {

                                    for (document in documents) {
                                        db.collection("trips")
                                            .whereEqualTo("ip", "true")
                                            .whereEqualTo("phonep", document.data!!["phone"])
                                            .get()
                                            .addOnSuccessListener { docs ->
                                                if (docs.documents.count()!! < 1) {
                                                    if (document.data["qty"].toString().toInt() > qty.toInt()) {

                                                        val latLng = LatLng(
                                                            document.data["lat"].toString().toDouble(),
                                                            document.data["long"].toString().toDouble()
                                                        )
                                                        var height = 300;
                                                        var width = 300;
                                                        var bitmapdraw =
                                                            getResources().getDrawable(R.drawable.car) as BitmapDrawable
                                                        var b = bitmapdraw.getBitmap();
                                                        var smallMarker = Bitmap.createScaledBitmap(
                                                            b,
                                                            width,
                                                            height,
                                                            false
                                                        );
                                                        var markerOptions = MarkerOptions()
                                                        markerOptions.position(latLng)
                                                        markerOptions.title("Tanker")
                                                        markerOptions.icon(
                                                            BitmapDescriptorFactory.fromBitmap(
                                                                smallMarker
                                                            )
                                                        )
                                                        mCurrLocationMarker =
                                                            mMap!!.addMarker(markerOptions)
                                                        mCurrLocationMarker!!.tag =
                                                            document.data["phone"]
                                                        this.tankercount += 1


                                                    }
                                                }

                                            }
                                    }
                                }


                            }

                    } else if (type == "sarf") {
                        db.collection("provider")
                            .whereEqualTo("cat", "تنكر صرف")
                            .whereEqualTo("online", "online")
                            .get()
                            .addOnSuccessListener { documents ->
                                for (document in documents) {
                                    db.collection("provider")
                                        .whereEqualTo("ip", "true")
                                        .whereEqualTo("phonep", document.data!!["phone"])
                                        .get()
                                        .addOnSuccessListener { docs ->
                                            if (docs.documents.count()!! < 1) {
                                                val latLng = LatLng(
                                                    document.data["lat"].toString().toDouble(),
                                                    document.data["long"].toString().toDouble()
                                                )
                                                var height = 300;
                                                var width = 300;
                                                var bitmapdraw =
                                                    getResources().getDrawable(R.drawable.car) as BitmapDrawable
                                                var b = bitmapdraw.getBitmap();
                                                var smallMarker = Bitmap.createScaledBitmap(
                                                    b,
                                                    width,
                                                    height,
                                                    false
                                                );
                                                var markerOptions = MarkerOptions()
                                                markerOptions.position(latLng)
                                                markerOptions.title("Tanker")
                                                markerOptions.icon(
                                                    BitmapDescriptorFactory.fromBitmap(
                                                        smallMarker
                                                    )
                                                )
                                                mCurrLocationMarker =
                                                    mMap!!.addMarker(markerOptions)
                                                mCurrLocationMarker!!.tag = document.data["phone"]
                                                this.tankercount += 1


                                            }
                                        }

                                }


                            }

                    }


                }
        }


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
    fun gotosupport(){
        var intent = Intent(applicationContext,Support::class.java)
        startActivity(intent)
    }

}