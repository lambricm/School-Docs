package edu.uc.cicely.finalproject1;

import android.content.Context;
import android.location.Location;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;


import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;


public class ShowMeActivity extends ActionBarActivity implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {

    protected Context appContext = this;

    protected static GoogleApiClient googleApiClient;
    protected static LocationRequest locationRequest;
    protected final Integer FIVE_SECONDS = 5000;
    protected boolean isConnected = false;

    protected Double latitude;
    protected Double longitude;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_me);

        //sets up the googleApiClient and the LocationRequest
        googleApiClient = new GoogleApiClient.Builder(this)
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();

        locationRequest = new LocationRequest();
        locationRequest.setInterval(FIVE_SECONDS);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        latitude = 2.0;
        longitude = 2.0;

        //set up list, distancwes, and bearings
        setUpListDisplayed();
        distanceDisp();
        bearingDisp();

        //set on-click listener for the listview
        ((ListView) findViewById(R.id.tagList)).setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> adapter, View v, int position, long longValue) {
                String toastString = String.format("Longitude:%.2f\nLatitude:%.2f", InitialScreen.longitudes.get(position), InitialScreen.latitudes.get(position));

                Toast.makeText(appContext, toastString, Toast.LENGTH_LONG).show();
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        connect();
    }

    @Override
    protected void onStop() {
        super.onStop();
        disconnect();
    }

    @Override
    protected void onPause() {
        super.onPause();
        unsubscribe();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (googleApiClient.isConnected()) {
            subscribe();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_show_me, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    //for GoogleApiClient.ConnectionCallbacks
    @Override
    public void onConnected(Bundle bundle) {
        subscribe();
    }

    //for GoogleApiClient.ConnectionCallbacks
    @Override
    public void onConnectionSuspended(int i) {
    }

    //for GoogleApiClient.OnConnectionFailedListener
    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Toast.makeText(this, "Connection to GPS failed.\nMake sure GPS is turned on.\nAlso, check that Google Play is up to date.", Toast.LENGTH_LONG).show();
    }

    //for LocationListener
    @Override
    public void onLocationChanged(Location location) {
        //update longitude/latitude values
        latitude = location.getLatitude();
        longitude = location.getLongitude();

        //refresh distance & bearing
        distanceDisp();
        bearingDisp();
    }

    public static void connect() {

        googleApiClient.connect();
    }

    public static void disconnect() {

        googleApiClient.disconnect();
    }

    public PendingResult<Status> subscribe() {
        isConnected = true;
        return LocationServices.FusedLocationApi.requestLocationUpdates(googleApiClient, locationRequest, this);
    }

    public void unsubscribe() {
        if (isConnected) {
            LocationServices.FusedLocationApi.removeLocationUpdates(googleApiClient, this);
        }
    }

    /**
     * sets the initial list of locations to be displayed
     */
    protected void setUpListDisplayed() {

        ListView listView = (ListView) findViewById(R.id.tagList);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, InitialScreen.tagList);

        // Assign adapter to ListView
        listView.setAdapter(adapter);
    }

    /**
     * calculates the distance between gps locations & displays them
     * displays the distance between the next point and the total distance in mi and km
     */
    protected void distanceDisp() {
        //get distance between points in km (distance to next point and total distance
        Double nextPointKM = distance(longitude, latitude, InitialScreen.longitudes.get(InitialScreen.longitudes.size() - 1), InitialScreen.latitudes.get(InitialScreen.latitudes.size() - 1));
        Double totalKM = nextPointKM;
        for (int i = 0; i < InitialScreen.longitudes.size() - 1; i++) {
            totalKM = totalKM + distance(InitialScreen.longitudes.get(i), InitialScreen.latitudes.get(i), InitialScreen.longitudes.get(i + 1), InitialScreen.latitudes.get(i + 1));
        }

        //get distances in miles
        Double nextPointMI = kmToMi(nextPointKM);
        Double totalMI = kmToMi(totalKM);

        //display
        TextView dist = (TextView) findViewById(R.id.lblDistance);
        String txtDist = String.format("Next Point: %.2fkm(%.2fmi)\nTotal: %.2fkm(%.2fmi)", nextPointKM, nextPointMI, totalKM, totalMI);
        dist.setText(txtDist);
    }

    /**
     * displays the bearings for the next point and the total bearing (to the final destination)
     */
    protected void bearingDisp() {
        TextView bearing = (TextView) findViewById(R.id.lblDir);

        String bearingNext = bearing(longitude, latitude, InitialScreen.longitudes.get(InitialScreen.longitudes.size() - 1), InitialScreen.latitudes.get(InitialScreen.latitudes.size() - 1));
        String bearingTotal = bearing(longitude, latitude, InitialScreen.longitudes.get(0), InitialScreen.latitudes.get(0));

        bearing.setText("Next Point: " + bearingNext + "\nTotal: " + bearingTotal);
    }

    /**
     * calculates distances between any latitudes & longitudes
     *
     * @param long1 =  first longitude
     * @param lat1  = first latitude
     * @param long2 = second longitude
     * @param lat2  = second latitude
     * @return = returns the distance between points
     */
    protected Double distance(Double long1, Double lat1, Double long2, Double lat2) {
        lat1 *= Math.PI / 180;
        lat2 *= Math.PI / 180;
        long1 *= Math.PI / 180;
        long2 *= Math.PI / 180;

        Double dlong = (long2 - long1);
        Double dlat = (lat2 - lat1);

        // Haversine formula:
        Double r = 6371.0;
        Double a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlong / 2) * Math.sin(dlong / 2);
        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        Double d = r * c;

        return d;
    }

    /**
     * convertos miles to kilometers
     *
     * @param distKM = distance in kilometers
     * @return = distance in miles
     */
    protected Double kmToMi(Double distKM) {
        Double conversion = 0.62137;
        return (distKM * conversion);
    }

    /**
     * calculat es bearing one needs to go to get to the next point
     *
     * @param lon1 =  first longitude
     * @param lat1 = first latitude
     * @param lon2 = second longitude
     * @param lat2 = second latitude
     * @return = string that is the bearing needed
     */
    protected String bearing(Double lon1, Double lat1, Double lon2, Double lat2) {

        lat1 = Math.toRadians(lat1);
        lat2 = Math.toRadians(lat2);
        double longDiff = Math.toRadians(lon2 - lon1);
        double y = Math.sin(longDiff) * Math.cos(lat2);
        double x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(longDiff);
        double resultDegree = (Math.toDegrees(Math.atan2(y, x)) + 360) % 360;

        double directionid = Math.round(resultDegree / 22.5);
        if (directionid < 0) {
            directionid = directionid + 16;
        }

        String coordNames[] = {"N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"};
        String compassLoc = coordNames[(int) directionid];

        return compassLoc;
    }
}
