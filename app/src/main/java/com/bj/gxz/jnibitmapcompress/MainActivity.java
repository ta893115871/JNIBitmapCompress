package com.bj.gxz.jnibitmapcompress;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

public class MainActivity extends AppCompatActivity {


    public static final String TAG = "JNI";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }

    public void compress(View view) {
        InputStream input = null;
        try {
            Log.i(TAG, "exists=" + new File("/sdcard/before.JPG").exists());
            input = new FileInputStream("/sdcard/before.JPG");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            Log.e(TAG, "onCreate: FileNotFoundException ", e);
        }
        Log.i(TAG, "start");
        Bitmap bitmap = BitmapFactory.decodeStream(input);

        // 真实使用应该在子线程
        long start = System.currentTimeMillis();
        int ret = CompressUtils.compressBitmap(bitmap, 30,
                "/sdcard/after.JPG", true);
        long end = System.currentTimeMillis();

        Log.e(TAG, "ret=" + ret + ",cost=" + (end - start));
    }
}