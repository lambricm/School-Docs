package edu.uc.cicely.finalproject1;

import android.content.Intent;
import android.location.Location;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;

public class InitialScreen extends ActionBarActivity implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {

    protected static GoogleApiClient googleApiClient;
    protected static LocationRequest locationRequest;
    protected final Integer ONE_MINUTE = 60000;

    private String genericListValue = "No tags currently in list";

    public static List<String> tagList;
    public static List<Double> longitudes;
    public static List<Double> latitudes;

    protected Double latitude;
    protected Double longitude;
    protected boolean isConnected = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_initial_screen);

        //sets up googleApiClient and LocationRequest
        googleApiClient = new GoogleApiClient.Builder(this)
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();

        locationRequest = new LocationRequest();
        locationRequest.setInterval(ONE_MINUTE);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        tagList = new ArrayList<String>();
        longitudes = new ArrayList<Double>();
        latitudes = new ArrayList<Double>();

        latitude = 1.0;
        longitude = 1.0;

        //currently, no saving is being done, so create a placeholder value
        //to indicate no tags are present in the list
        tagList.add(genericListValue);

        refreshTagList();
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
        getMenuInflater().inflate(R.menu.menu_initial_screen, menu);
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
        //collect the latitude & longitude values
        latitude = location.getLatitude();
        longitude = location.getLongitude();
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

    //onClicked functions

    public void onTagMeClicked(View v) {
        //make sure the tag placholder indicating no tags is gone
        if (tagList.size() == 1 && (longitudes.size() < 1)) {
            tagList.clear();
        }

        //get the user's tag
        String tag = ((EditText) findViewById(R.id.txtPointName)).getText().toString();

        //if tag is empty or a duplicate, rename with number on the end
        if (tag.isEmpty()) {
            boolean added = false;
            int tagNum = 0;
            String newItem = "Tag" + tagNum;
            tagNum++;
            while (!added) {
                newItem = "Tag" + tagNum;
                added = !(tagList.contains(newItem));
                tagNum++;
            }
            tag = newItem;
        } else if (tagList.contains(tag)) {
            boolean added = false;
            int tagNum = 0;
            String newItem = tag + tagNum;
            tagNum++;
            while (!added) {
                newItem = tag + tagNum;
                added = !(tagList.contains(newItem));
                tagNum++;
            }
            tag = newItem;
        }

        //add tag, latitude, and longitude to global arraylists
        tagList.add(tag);
        longitudes.add(longitude);
        latitudes.add(latitude);

        refreshTagList();
    }

    public void onShowMeClicked(View v) {
        //start the show me activity screen unless there are no geotags recorded
        if (longitudes.isEmpty() || latitudes.isEmpty()) {
            Toast.makeText(this, "ERROR:" + genericListValue, Toast.LENGTH_LONG).show();
        } else {
            Intent intent = new Intent(this, ShowMeActivity.class);
            startActivity(intent);
        }
    }

    public void onDeleteClicked(View v) {
        //get chosen spinner index
        int pos = ((Spinner) findViewById(R.id.spDelete)).getSelectedItemPosition();

        //if an invalid position is returned, indicate this. otherwise, remove the chosen tag
        if (pos == Spinner.INVALID_POSITION || pos >= tagList.size()) {
            Toast.makeText(this, "Invalid Position\nCannot Delete", Toast.LENGTH_LONG).show();
        } else {
            tagList.remove(pos);
            longitudes.remove(pos);
            latitudes.remove(pos);

            refreshTagList();
        }
    }

    //otherFunctions

    /**
     * refreshes the list of tags on the spinner that allows deletion
     */
    private void refreshTagList() {
        Spinner spinnerDelete = (Spinner) findViewById(R.id.spDelete);
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, tagList);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerDelete.setAdapter(dataAdapter);
    }
}
