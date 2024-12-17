<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<script>
   $(document).ready(function(){
      $('#testBtn').click(function(){
         $.ajax({
            url : '/usr/home/test',
            type : 'GET',
            data : {
               key1 : 'value1',
               key2 : 'value2'
            },
            dataType : 'json',
            success : function(test) {
               console.log(test);
               $('#testDiv').append('<div>' + test.data.key1 + '</div>');
            },
            error : function(xhr, status, error) {
               console.log(error);
            }
         })
      })
   })
</script> 