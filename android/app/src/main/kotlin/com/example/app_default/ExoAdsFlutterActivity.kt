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

        val defaultLayoutResId = R.layout.ad_native_default
        val rawLayout = (customOptions?.get("layout_name") as? String)?.trim()?.lowercase()
        val layoutName = when (rawLayout) {
            // Small & Banner
            "small_down", "smalldown", "sd", "h", "small" -> "ad_native_small_down"
            "small_up", "smallup", "su", "i" -> "ad_native_small_up"
            "banner", "small_banner", "small_inline", "sb", "si", "j" -> "ad_native_banner"

            // Large Vertical
            "large_down", "largedown", "large_standard", "ld", "c", "large" -> "ad_native_large_down"
            "large_up", "largeup", "lu", "a" -> "ad_native_large_up"
            "large_center", "large_info_top", "lc", "lit", "d" -> "ad_native_large_center"
            "large_media_bottom", "large_media_btm", "lmb", "b" -> "ad_native_large_media_bottom"

            // Large Special / Split / Horizontal
            "large_split", "large_btn_right", "ls", "lbr", "e" -> "ad_native_large_split"
            "large_horizontal", "large_card", "lh", "f" -> "ad_native_large_horizontal"
            "large_side_by_side", "large_grid", "lsbs", "lg", "g" -> "ad_native_large_side_by_side"

            // Fullscreen
            "fullscreen_a", "full_a", "fullscreen", "full", "fa" -> "ad_native_fullscreen_a"
            "fullscreen_card", "fullscreen_overlay", "fullscreen_b", "full_b", "fb" -> "ad_native_fullscreen_card"
            "fullscreen_v2", "fullscreen_c", "full_c", "fc" -> "ad_native_fullscreen_v2"

            // Custom & Default
            "custom" -> "ad_native_custom"
            "default" -> "ad_native_default"
            "native_collap", "collapse", "k" -> "ad_native_collapse_layout"

            // Legacy full layout names mapping
            "ad_native_a_1_button_2_media_3_info_layout" -> "ad_native_large_up"
            "ad_native_b_1_button_2_info_3_media_layout" -> "ad_native_large_media_bottom"
            "ad_native_c_1_media_2_info_3_button_layout" -> "ad_native_large_down"
            "ad_native_d_1_info_2_media_3_button_layout" -> "ad_native_large_center"
            "ad_native_e_1_media_2xxxinfovsbutton_layout" -> "ad_native_large_split"
            "ad_native_f_1_xxxmediavsyyyinfovsbutton_layout" -> "ad_native_large_horizontal"
            "ad_native_g_1_xxxinfovsmedia_2_button_layout" -> "ad_native_large_side_by_side"
            "ad_native_h_1_info_2_button_layout" -> "ad_native_small_down"
            "ad_native_i_1_button_2_info_layout" -> "ad_native_small_up"
            "ad_native_j_1_xxxinfovsbutton_layout" -> "ad_native_banner"
            "ad_native_fa_fullscreen_layout" -> "ad_native_fullscreen_a"
            "ad_native_fb_fullscreen_layout" -> "ad_native_fullscreen_card"
            "ad_native_fc_fullscreen_layout" -> "ad_native_fullscreen_v2"
            "ad_native_custom_layout" -> "ad_native_custom"
            "ad_native_default_layout" -> "ad_native_default"

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

        val parseColor: (Any?) -> Int? = { raw ->
            when (raw) {
                is String -> try {
                    android.graphics.Color.parseColor(if (raw.startsWith("#")) raw else "#" + raw)
                } catch (_: Exception) { null }
                else -> null
            }
        }
        val parseRadius: (Any?) -> Float? = { raw ->
            when (raw) {
                is Number -> raw.toFloat()
                is String -> raw.replace(Regex("[^0-9.]"), "").toFloatOrNull()
                else -> null
            }
        }
        parseColor(customOptions?.get("bg_color"))?.let { color ->
            adView.setBackgroundColor(color)
            adView.findViewById<android.view.View>(R.id.ad_unit_content)?.setBackgroundColor(color)
        }
        val ctaColor = parseColor(customOptions?.get("cta_btn_color"))
        val ctaTextColor = parseColor(customOptions?.get("cta_btn_text_color"))
        val ctaRadius = parseRadius(
            customOptions?.get("cta_btn_radius")
                ?: customOptions?.get("cta_btn_border_radius")
                ?: customOptions?.get("cta_border_radius")
                ?: customOptions?.get("cta_radius")
        )
        val headlineTextColor = parseColor(customOptions?.get("headline_text_color") ?: customOptions?.get("text_color"))
        val bodyTextColor = parseColor(customOptions?.get("body_text_color") ?: customOptions?.get("text_color"))
        val adBadgeColor = parseColor(customOptions?.get("ad_badge_color") ?: customOptions?.get("ad_icon_bg_color") ?: customOptions?.get("ad_icon_color"))
        val adBadgeTextColor = parseColor(customOptions?.get("ad_badge_text_color") ?: customOptions?.get("ad_icon_text_color"))

        // Badge / Attribution
        val tvIcon = adView.findViewById<android.widget.TextView>(R.id.tv_icon)
        tvIcon?.let { badge ->
            adBadgeColor?.let { color ->
                badge.background?.mutate()?.setTint(color)
            }
            adBadgeTextColor?.let { color ->
                badge.setTextColor(color)
            }
        }

        // Headline
        val headlineView = adView.findViewById<android.widget.TextView>(R.id.ad_headline)
        headlineView?.let {
            it.text = nativeAd.headline
            headlineTextColor?.let { color -> it.setTextColor(color) }
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
                bodyTextColor?.let { color -> it.setTextColor(color) }
            }
            adView.bodyView = it
        }

        // Call to Action
        val callToActionView = adView.findViewById<android.widget.Button>(R.id.ad_call_to_action)
        callToActionView?.let { button ->
            if (nativeAd.callToAction.isNullOrEmpty()) {
                button.visibility = android.view.View.INVISIBLE
            } else {
                button.visibility = android.view.View.VISIBLE
                button.text = nativeAd.callToAction
                if (ctaColor != null || ctaRadius != null) {
                    val density = inflater.context.resources.displayMetrics.density
                    val drawable = (button.background?.mutate() as? android.graphics.drawable.GradientDrawable)
                        ?: android.graphics.drawable.GradientDrawable().apply {
                            shape = android.graphics.drawable.GradientDrawable.RECTANGLE
                        }
                    ctaColor?.let { color -> drawable.setColor(color) }
                    ctaRadius?.let { radiusDp -> drawable.cornerRadius = radiusDp * density }
                    button.background = drawable
                }
                ctaTextColor?.let { color -> button.setTextColor(color) }
            }
            adView.callToActionView = button
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
