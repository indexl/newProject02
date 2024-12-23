<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>정류장 뷰</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c"></script>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        #roadview {
            width: 100%;
            height: 600px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        .button:hover {
            background-color: #218838;
        }
        .error-message {
            text-align: center;
            padding: 20px;
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>정류장 뷰</h1>
        <a href="javascript:history.back()" class="button">뒤로가기</a>
        <div id="roadview"></div>
    </div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const lat = parseFloat(urlParams.get('lat'));
        const lng = parseFloat(urlParams.get('lng'));

        if (lat && lng) {
            const roadviewContainer = document.getElementById('roadview');
            const roadview = new kakao.maps.Roadview(roadviewContainer);
            const roadviewClient = new kakao.maps.RoadviewClient();
            const position = new kakao.maps.LatLng(lat, lng);

            roadviewClient.getNearestPanoId(position, 50, function(panoId) {
                if (panoId) {
                    // 로드뷰 표시
                    roadview.setPanoId(panoId, position);
                } else {
                    document.getElementById('roadview').innerHTML = 
                        '<div class="error-message">' +
                        '<p>이 위치에서는 로드뷰를 이용할 수 없습니다.</p>' +
                        '<p>주변 도로 위치에서 다시 시도해주세요.</p>' +
                        '</div>';
                }
            });
        } else {
            document.getElementById('roadview').innerHTML = 
                '<div class="error-message">' +
                '<p>위치 정보를 찾을 수 없습니다.</p>' +
                '<p>버스정류장 정보 페이지에서 다시 시도해주세요.</p>' +
                '</div>';
        }
    </script>
</body>
</html>