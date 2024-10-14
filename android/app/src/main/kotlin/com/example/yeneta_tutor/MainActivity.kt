package com.example.your_app_name

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.DefaultRenderersFactory

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize ExoPlayer with fallback
        val renderersFactory = DefaultRenderersFactory(this)
            .setEnableDecoderFallback(true)

        val exoPlayer = ExoPlayer.Builder(this)
            .setRenderersFactory(renderersFactory)
            .build()

        // You can now use the exoPlayer instance in your app
    }
}
