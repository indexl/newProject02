<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>수정</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .modify-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

    <script>
        const modifyForm_onSubmit = function(form) {
            form.title.value = form.title.value.trim();
            form.body.value = form.body.value.trim();

            if (form.title.value.length === 0) {
                alert('제목을 입력해주세요');
                form.title.focus();
                return false;
            }

            if (form.body.value.length === 0) {
                alert('내용을 입력해주세요');
                form.body.focus();
                return false;
            }

            return true;
        }
    </script>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 modify-container">
                <form action="doModify" method="post" onsubmit="return modifyForm_onSubmit(this);">
                    <input type="hidden" name="id" value="${article.getId() }"/>
                    
                    <table class="table table-bordered">
                        <tr>
                            <th class="bg-light">번호</th>
                            <td>${article.getId() }</td>
                        </tr>
                        <tr>
                            <th class="bg-light">작성일</th>
                            <td>${article.getRegDate().substring(2, 16) }</td>
                        </tr>
                        <tr>
                            <th class="bg-light">수정일</th>
                            <td>${article.getUpdateDate().substring(2, 16) }</td>
                        </tr>
                        <tr>
                            <th class="bg-light">작성자</th>
                            <td>${article.getLoginId() }</td>
                        </tr>
                        <tr>
                            <th class="bg-light">제목</th>
                            <td>
                                <input type="text" class="form-control" name="title" 
                                       placeholder="제목을 입력해주세요" 
                                       value="${article.getTitle() }" required>
                            </td>
                        </tr>
                        <tr>
                            <th class="bg-light">내용</th>
                            <td>
                                <textarea class="form-control" name="body" 
                                          placeholder="내용을 입력해주세요" 
                                          rows="5" required>${article.getBody() }</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="text-center">
                                <button type="submit" class="btn btn-primary btn-lg">수정</button>
                            </td>
                        </tr>
                    </table>
                </form>

                <div class="d-flex justify-content-between mt-3">
                    <button class="btn btn-secondary" onclick="history.back();">뒤로가기</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>