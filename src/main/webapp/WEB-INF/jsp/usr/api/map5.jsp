<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<title>정류장 뷰</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
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
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	text-align: center;
}

h1 {
	text-align: center;
	margin-bottom: 20px;
}

#roadview {
	width: 80%;
	height: 600px;
	border-radius: 8px;
	margin: 20px auto;
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
	margin: 0 10px;
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

#shot {
	background-color: #007bff;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
	display: inline-block;
	margin: 0 10px;
	transition: background-color 0.3s ease;
}

#shot:hover {
	background-color: #0056b3;
}

#shot.clicked {
	background-color: #28a745;
}

.button-container {
	text-align: center;
	margin-bottom: 20px;
}
</style>
</head>
<body>
	<div class="container" id="capture">
		<h1>정류장 뷰</h1>
		<div class="button-container">
			<a href="javascript:history.back()" class="button">뒤로가기</a>
			<button id="shot" class="button">화면 캡쳐</button>
		</div>
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

		$(function(){
		    $("#shot").on("click", function(){
		        const button = $(this);
		        button.addClass('clicked');
		
		        // 현재 날짜와 시간을 파일명에 포함
		        const now = new Date();
		        const year = now.getFullYear();
		        const month = (now.getMonth() + 1).toString().length === 1 ? "0" + (now.getMonth() + 1) : (now.getMonth() + 1);
		        const day = now.getDate().toString().length === 1 ? "0" + now.getDate() : now.getDate();
		        const hours = now.getHours().toString().length === 1 ? "0" + now.getHours() : now.getHours();
		        const minutes = now.getMinutes().toString().length === 1 ? "0" + now.getMinutes() : now.getMinutes();
		        
		        const filename = `정류장뷰_${year}${month}${day}_${hours}${minutes}.png`;
		
		        // 0.3초 후에 클래스 제거
		        setTimeout(() => {
		            button.removeClass('clicked');
		        }, 300);
		
		        html2canvas(document.querySelector("#capture")).then(canvas => {
		            saveAs(canvas.toDataURL('image/png'), filename);
		        });
		    });
		
		    function saveAs(uri, filename) {
		        var link = document.createElement('a');
		        if (typeof link.download === 'string') {
		            link.href = uri;
		            link.download = filename;
		            document.body.appendChild(link);
		            link.click();
		            document.body.removeChild(link);
		        } else {
		            window.open(uri);
		        }
		    }
		});
    </script>
</body>
</html>