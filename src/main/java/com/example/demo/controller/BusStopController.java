package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.BusStopDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/usr/api/map2")
@Slf4j
public class BusStopController {

   @Value("${bus.api.key}")
   private String apiKey;

   private final String API_URL = "http://apis.data.go.kr/6300000/busStationService/getBusStationList";

   @GetMapping("")
   public String map2() {
       return "usr/api/map2";
   }

   @GetMapping("/nearest")
   @ResponseBody
   public ResponseEntity<Map<String, Object>> findNearestStop(
           @RequestParam double lat,
           @RequestParam double lng) {
       log.info("현재 위치 - 위도: {}, 경도: {}", lat, lng);
       try {
           List<BusStopDTO> busStops = getBusStops();
           log.info("버스정류장 개수: {}", busStops.size());
           
           if (busStops.isEmpty()) {
               log.warn("버스정류장 정보를 찾을 수 없습니다.");
               return ResponseEntity.status(HttpStatus.NOT_FOUND)
                   .body(Collections.singletonMap("error", "버스정류장 정보를 찾을 수 없습니다."));
           }

           BusStopDTO nearest = findNearest(lat, lng, busStops);
           log.info("가장 가까운 정류장: {}", nearest.getStationName());
           
           Map<String, Object> response = new HashMap<>();
           response.put("latitude", nearest.getLat());
           response.put("longitude", nearest.getLng());
           response.put("stationName", nearest.getStationName());
           response.put("stationId", nearest.getStationId());
           
           return ResponseEntity.ok(response);

       } catch (Exception e) {
           log.error("가장 가까운 버스정류장 검색 중 오류 발생: {}", e.getMessage());
           return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
               .body(Collections.singletonMap("error", "버스정류장 검색 중 오류가 발생했습니다."));
       }
   }

   private List<BusStopDTO> getBusStops() {
       try {
           StringBuilder urlBuilder = new StringBuilder(API_URL);
           urlBuilder.append("?serviceKey=").append(apiKey);
           urlBuilder.append("&format=json");
           
           log.info("API 호출 URL: {}", urlBuilder.toString());

           URL url = new URL(urlBuilder.toString());
           HttpURLConnection conn = (HttpURLConnection) url.openConnection();
           conn.setRequestMethod("GET");
           conn.setRequestProperty("Content-type", "application/json");

           BufferedReader rd;
           if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
               rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
           } else {
               rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
               log.error("API 호출 실패. 응답 코드: {}", conn.getResponseCode());
               return new ArrayList<>();
           }

           StringBuilder sb = new StringBuilder();
           String line;
           while ((line = rd.readLine()) != null) {
               sb.append(line);
           }
           rd.close();
           conn.disconnect();

           String response = sb.toString();
           log.info("API 응답: {}", response);

           JSONObject jsonResponse = new JSONObject(response);
           JSONArray items = jsonResponse.getJSONObject("response")
                                      .getJSONObject("body")
                                      .getJSONArray("items");

           List<BusStopDTO> busStops = new ArrayList<>();
           for (int i = 0; i < items.length(); i++) {
               JSONObject item = items.getJSONObject(i);
               busStops.add(new BusStopDTO(
                   Double.parseDouble(item.getString("centerYpos")),
                   Double.parseDouble(item.getString("centerXpos")),
                   item.getString("stationName"),
                   item.getString("stationId")
               ));
           }

           return busStops;

       } catch (Exception e) {
           log.error("버스정류장 정보 조회 중 오류 발생: {}", e.getMessage());
           return new ArrayList<>();
       }
   }

   private BusStopDTO findNearest(double lat, double lng, List<BusStopDTO> stops) {
       return stops.stream()
               .min(Comparator.comparingDouble(stop -> 
                   calculateDistance(lat, lng, stop.getLat(), stop.getLng())))
               .orElseThrow(() -> new RuntimeException("버스정류장을 찾을 수 없습니다."));
   }

   private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
       final int R = 6371;
       
       double latDistance = Math.toRadians(lat2 - lat1);
       double lonDistance = Math.toRadians(lon2 - lon1);
       
       double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
               + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
               * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
       
       double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
       
       return R * c;
   }
}