package fayoum.university.mobi_wall;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class BlockingActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_blocking);

        // Display a message or UI to inform the user that the app is blocked
        TextView message = findViewById(R.id.block_message);
        message.setText("This app is blocked by the parental control app.");

        // Optionally, add a button to go back to the home screen
//        Button homeButton = findViewById(R.id.home_button);
//        homeButton.setOnClickListener(v -> {
//            Intent intent = new Intent(Intent.ACTION_MAIN);
//            intent.addCategory(Intent.CATEGORY_HOME);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            startActivity(intent);
//            finish(); // Close the BlockingActivity
//        });
    }
}