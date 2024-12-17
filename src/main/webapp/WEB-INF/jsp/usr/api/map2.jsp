<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>가장 가까운 버스정류장 찾기</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c"></script>
    <style>
        .map-container {
            position: relative;
            width: calc(100% - 200px);
            height: 100vh;
            margin-left: 200px;
        }
        
        #result {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            z-index: 2;
        }
    </style>
</head>
<body>
    <div class="map-container">
        <div id="map" style="width:70%;height:70%;"></div>
        <div id="result"></div>
    </div>
    
    <div class="map-container">
	    <div id="map" style="width:100%;height:100%;"></div>
	    <div id="result" style="position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); z-index: 2;"></div>
	</div>

    <script>
        var map;
        var marker;
        
        $(document).ready(function() {
            initMap();
            getCurrentLocation();
        });
        
        function initMap() {
            var defaultPosition = new kakao.maps.LatLng(36.35103339, 127.3797282);
            var mapContainer = document.getElementById('map');
            var mapOption = {
                center: defaultPosition,
                level: 3
            };
            
            map = new kakao.maps.Map(mapContainer, mapOption);
        }
        
        function getCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;
                    
                    // 현재 위치에 마커 표시
                    var currentPos = new kakao.maps.LatLng(lat, lng);
                    map.setCenter(currentPos);
                    
                    if (marker) {
                        marker.setMap(null);
                    }
                    
                    marker = new kakao.maps.Marker({
                        position: currentPos,
                        map: map
                    });
                    
                    // 가장 가까운 정류장 찾기
                    findNearestBusStop(lat, lng);
                    
                }, function() {
                    alert('위치 정보를 가져올 수 없습니다.');
                });
            } else {
                alert('이 브라우저에서는 위치 정보를 지원하지 않습니다.');
            }
        }
        
        function findNearestBusStop(lat, lng) {
            $.ajax({
                url: 'usr/api/map2/nearest',
                type: 'GET',
                data: {
                    lat: lat,
                    lng: lng
                },
                success: function(response) {
                    displayResult(response);
                    markBusStop(response.latitude, response.longitude);
                },
                error: function(error) {
                    alert('가까운 버스정류장을 찾는데 실패했습니다.');
                }
            });
        }
        
        function displayResult(response) {
            $('#result').html(`
                <div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3>가장 가까운 버스정류장</h3>
                    <p>정류장명: ${response.stationName}</p>
                    <p>정류장 ID: ${response.stationId}</p>
                    <p>위도: ${response.latitude}</p>
                    <p>경도: ${response.longitude}</p>
                </div>
            `);
            $('#result').show();  // 결과를 보여줌
        }
        
        function markBusStop(lat, lng) {
            var busStopPosition = new kakao.maps.LatLng(lat, lng);
            
            var busStopMarker = new kakao.maps.Marker({
                position: busStopPosition,
                map: map,
                image: new kakao.maps.MarkerImage(
                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
                    new kakao.maps.Size(24, 35)
                )
            });
        }
    </script>
</body>
</html>