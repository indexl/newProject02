<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>검색 후 마커 표시하기</title>
    <style>
       
        #search-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }

         
        #map {
            width: calc(100% - 250px); /* 사이드바를 제외한 나머지 너비 */
            height: calc(60vh - 60px); /* 화면 전체 높이에서 여백을 제외 */
            margin-left: 250px; /* 사이드바 너비만큼 밀어줌 */
        }
        #clickLatlng {
            text-align: center;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <!-- 검색창 -->
    <div id="search-container">
        <input type="text" id="searchInput" placeholder="주소를 입력하세요" 
               style="width:300px;" onkeyup="checkEnter(event)">
        <button onclick="searchLocation()">검색</button>
    </div>

    <!-- 지도 영역 -->
    <div id="map"></div>

    <!-- 클릭한 위치 정보 -->
    <div id="clickLatlng"></div>

    <!-- Kakao 지도 API -->
    <script type="text/javascript" 
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c&libraries=services">
    </script>

    <script>
    // 지도 초기 설정
    var mapContainer = document.getElementById('map'),
        mapOption = { 
            center: new kakao.maps.LatLng(36.3510333991808, 127.3797282718),
            level: 1 
        };

    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 마커 설정
    var marker = new kakao.maps.Marker({
        position: map.getCenter()
    });
    marker.setMap(map);

    var geocoder = new kakao.maps.services.Geocoder();

    // 검색 기능
    function searchLocation() {
        var address = document.getElementById('searchInput').value;

        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                marker.setPosition(coords);
                map.setCenter(coords);

                var message = '검색한 위치의 위도는 ' + coords.getLat() + ' 이고, ';
                message += '경도는 ' + coords.getLng() + ' 입니다';
                document.getElementById('clickLatlng').innerHTML = message;
            } else {
                alert("검색 결과가 없습니다. 주소를 확인해주세요.");
            }
        });
    }

    // 엔터 키 이벤트
    function checkEnter(event) {
        if (event.keyCode === 13) {
            searchLocation();
        }
    }

    // 지도 클릭 이벤트
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        var latlng = mouseEvent.latLng;
        marker.setPosition(latlng);

        var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
        message += '경도는 ' + latlng.getLng() + ' 입니다';

        var resultDiv = document.getElementById('clickLatlng');
        resultDiv.innerHTML = message;
    });
    </script>
</body>
</html>