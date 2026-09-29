package com.example.app_default

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.NativeAdFactory
import android.view.LayoutInflater

open class ExoAdsFlutterActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MobileAds.initialize(this) {}

        val factory = SDefaultNativeAdFactory(layoutInflater)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "s_default_native_ad_factory", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "fullscreen", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "largeDown", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "largeUp", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "smallDown", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "smallUp", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "large", factory)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "small", factory)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "s_default_native_ad_factory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "fullscreen")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "largeDown")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "largeUp")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallDown")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallUp")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "large")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "small")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}

class SDefaultNativeAdFactory(
    private val inflater: LayoutInflater
) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any>?
    ): NativeAdView {

        val defaultLayoutResId = R.layout.ad_native_default_layout
        val rawLayout = (customOptions?.get("layout_name") as? String)?.trim()?.lowercase()
        val layoutName = when (rawLayout) {
            "a" -> "ad_native_a_1_button_2_media_3_info_layout"
            "b" -> "ad_native_b_1_button_2_info_3_media_layout"
            "c" -> "ad_native_c_1_media_2_info_3_button_layout"
            "d" -> "ad_native_d_1_info_2_media_3_button_layout"
            "e" -> "ad_native_e_1_media_2xxxinfovsbutton_layout"
            "f" -> "ad_native_f_1_xxxmediavsyyyinfovsbutton_layout"
            "g" -> "ad_native_g_1_xxxinfovsmedia_2_button_layout"
            "h" -> "ad_native_h_1_info_2_button_layout"
            "i" -> "ad_native_i_1_button_2_info_layout"
            "j" -> "ad_native_j_1_xxxinfovsbutton_layout"
            "fa" -> "ad_native_fa_fullscreen_layout"
            "fb" -> "ad_native_fb_fullscreen_layout"
            "fc" -> "ad_native_fc_fullscreen_layout"
            "k", "collapse", "native_collap" -> "ad_native_collapse_layout"
            "custom" -> "ad_native_custom_layout"
            "default" -> "ad_native_default_layout"
            "largedown" -> "ad_native_a_1_button_2_media_3_info_layout"
            "largeup" -> "ad_native_b_1_button_2_info_3_media_layout"
            "large" -> "ad_native_a_1_button_2_media_3_info_layout"
            "smalldown" -> "ad_native_h_1_info_2_button_layout"
            "smallup" -> "ad_native_i_1_button_2_info_layout"
            "small" -> "ad_native_h_1_info_2_button_layout"
            "fullscreen", "full" -> "ad_native_fa_fullscreen_layout"
            else -> rawLayout
        }

        val layoutResId = layoutName?.let {
            inflater.context.resources.getIdentifier(
                it,
                "layout",
                inflater.context.packageName
            )
        }?.takeIf { it != 0 } ?: defaultLayoutResId

        val adView = inflater.inflate(layoutResId, null) as NativeAdView

        // Headline
        val headlineView = adView.findViewById<android.widget.TextView>(R.id.ad_headline)
        headlineView?.let {
            it.text = nativeAd.headline
            adView.headlineView = it
        }

        // Body
        val bodyView = adView.findViewById<android.widget.TextView>(R.id.ad_body)
        bodyView?.let {
            if (nativeAd.body.isNullOrEmpty()) {
                it.visibility = android.view.View.INVISIBLE
            } else {
                it.visibility = android.view.View.VISIBLE
                it.text = nativeAd.body
            }
            adView.bodyView = it
        }

        // Call to Action
        val callToActionView = adView.findViewById<android.widget.Button>(R.id.ad_call_to_action)
        callToActionView?.let {
            if (nativeAd.callToAction.isNullOrEmpty()) {
                it.visibility = android.view.View.INVISIBLE
            } else {
                it.visibility = android.view.View.VISIBLE
                it.text = nativeAd.callToAction
            }
            adView.callToActionView = it
        }

        // Icon
        val iconView = adView.findViewById<android.widget.ImageView>(R.id.ad_app_icon)
        iconView?.let {
            if (nativeAd.icon == null) {
                it.visibility = android.view.View.GONE
            } else {
                it.visibility = android.view.View.VISIBLE
                it.setImageDrawable(nativeAd.icon?.drawable)
            }
            adView.iconView = it
        }

        // Media
        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(R.id.ad_media)
        mediaView?.let {
            it.mediaContent = nativeAd.mediaContent
            adView.mediaView = it
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
