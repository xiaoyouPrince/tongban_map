/**
 * Copyright (c) 2016-present, lovebing.org.
 * <p>
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package org.lovebing.reactnative.baidumap.uimanager;

import android.text.TextUtils;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import org.json.JSONObject;
import org.lovebing.reactnative.baidumap.util.LatLngUtil;
import org.lovebing.reactnative.baidumap.view.OverlayMarker;

public class OverlayMarkerManager extends SimpleViewManager<OverlayMarker> {

    @Override
    public String getName() {
        return "BaiduMapOverlayMarker";
    }

    @Override
    protected OverlayMarker createViewInstance(ThemedReactContext themedReactContext) {
        return new OverlayMarker(themedReactContext);
    }

    @ReactProp(name = "title")
    public void setTitle(OverlayMarker overlayMarker, String title) {
        overlayMarker.setTitle(title);
    }

    @ReactProp(name = "content")
    public void setContent(OverlayMarker overlayMarker, String content) {
        overlayMarker.setTitle(content);
    }

    @ReactProp(name = "location")
    public void setLocation(OverlayMarker overlayMarker, ReadableMap position) {
        overlayMarker.setPosition(LatLngUtil.fromReadableMap(position));
    }

    /**
     * 传的参数 title_companyId_address_location
     * @param overlayMarker
     * @param uri
     */
    @ReactProp(name = "icon")
    public void setIcon(OverlayMarker overlayMarker, String uri) {
        overlayMarker.setTitle(uri);
        overlayMarker.setIcon(uri);
    }

    @ReactProp(name = "perspective")
    public void setPerspective(OverlayMarker overlayMarker, boolean perspective) {
        overlayMarker.setPerspective(perspective);
    }

    @ReactProp(name = "alpha")
    public void setAlpha(OverlayMarker overlayMarker, float alpha) {
        overlayMarker.setAlpha(alpha);
    }

    @ReactProp(name = "rotate")
    public void setRotate(OverlayMarker overlayMarker, float rotate) {
        overlayMarker.setRotate(rotate);
    }

    @ReactProp(name = "flat")
    public void setFlat(OverlayMarker overlayMarker, boolean flat) {
        overlayMarker.setFlat(flat);
    }

    static class ContentBean {

        /**
         * companyId : 公司Id
         * isPoint : true
         * address : 公司地址
         */

        private String companyId;
        private boolean isPoint;
        private String address;

        public String getCompanyId() {
            return companyId;
        }

        public void setCompanyId(String companyId) {
            this.companyId = companyId;
        }

        public boolean isIsPoint() {
            return isPoint;
        }

        public void setIsPoint(boolean isPoint) {
            this.isPoint = isPoint;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }
    }
}
