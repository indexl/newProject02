<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <title>Screen Capture</title>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <style>
        #shot {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            z-index: 1000;
            transition: background-color 0.3s ease;
        }
        
        #shot:hover {
            background-color: #0056b3;
        }
        
        #shot.clicked {
            background-color: #28a745;
        }
        
        #capture {
            width: 100%;
            min-height: 100vh;
            background: #ffffff;
            padding: 20px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
    <button id="shot">Screen Shot</button>
    <!-- 캡쳐할 영역 -->
    <div id="capture">
        <h4>캡쳐 완료!</h4>
        <!-- 여기에 캡쳐할 콘텐츠가 들어갑니다 -->
    </div>

    <script>
        $(function(){
            $("#shot").on("click", function(){
                const button = $(this);
                button.addClass('clicked');
                
                // 0.3초 후에 클래스 제거
                setTimeout(() => {
                    button.removeClass('clicked');
                }, 300);

                html2canvas(document.querySelector("#capture")).then(canvas => {
                    saveAs(canvas.toDataURL('image/png'),"캡쳐_사진.png");
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