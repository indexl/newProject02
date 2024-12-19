<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>주소로 장소 및 로드뷰 표시하기</title>
</head>
<body>

<!-- 지도 표시 영역 -->
<div id="map" style="width:100%;height:400px;"></div>

<!-- 텍스트 박스와 버튼을 하단에 배치 -->
<div style="text-align: center; margin-top: 20px;">
    <input type="text" id="address" placeholder="목적지를 입력하세요" onkeypress="checkEnter(event)" />
    <button onclick="searchAddress()">목적지 검색</button>
</div>

<!-- 로드뷰 표시 영역 -->
<div id="roadview" style="width:100%;height:400px; margin-top: 20px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c&libraries=services"></script>
<script>

var mapContainer = document.getElementById('map'),
    mapOption = {
        center: new kakao.maps.LatLng(36.35123316214455, 127.38050183390544),
        level: 2
    };  
var map = new kakao.maps.Map(mapContainer, mapOption); 
var geocoder = new kakao.maps.services.Geocoder();


var roadviewContainer = document.getElementById('roadview');
var roadview = new kakao.maps.Roadview(roadviewContainer);
var roadviewClient = new kakao.maps.RoadviewClient();

var defaultPosition = new kakao.maps.LatLng(36.35120839795718, 127.38049614316073);
initializeMapAndRoadview(defaultPosition);

function initializeMapAndRoadview(position) {
   
    map.setCenter(position);

  
    var marker = new kakao.maps.Marker({
        map: map,
        position: position
    });

    roadviewClient.getNearestPanoId(position, 50, function(panoId) {
        if (panoId) {
            roadview.setPanoId(panoId, position);
        } else {
            alert("로드뷰를 찾을 수 없습니다.");
        }
    });
}

function searchAddress() {
    var address = document.getElementById('address').value;

    if (!address) {
        alert("주소를 입력해주세요.");
        return;
    }

    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

           
            initializeMapAndRoadview(coords);
        } else {
            alert("주소를 찾을 수 없습니다.");
        }
    });
}

function checkEnter(event) {
    if (event.keyCode === 13) { 
        searchAddress();
    }
}
</script>
</body>
</html>