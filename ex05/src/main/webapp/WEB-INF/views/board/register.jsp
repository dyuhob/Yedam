<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>
<style>
	.uploadResult {
		width:100%;
		background-color: gray;	
	}
	
	.uploadResult ul{
		display:flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding : 10px;
		align-content: center;
		text-align: center;
	}
	
	.uploadResult ul li img{
		width: 100px;
	}
	
	.uploadResult ul li span{
		color: white;
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: grey;
		z-index: 100;
		background:rgba(255, 255, 255, 0.5);
	}
	
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
		width: 600px;
	}
	</style>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
	<!-- /.col-lg-12 -->	
</div>
<!-- row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">Board Register</div>
			<!--  /.panel-heading -->
			<div class="panel-body">
			
				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title">
					</div>
					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" row="3" name="content"></textarea>
					</div>
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer">
					</div>
					<button type="submit" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
				
			</div>
			<!-- end panel-body -->
			
		</div>
			<!-- end panel -->
	
		</div>
			<!-- /. row -->	
	</div>
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				
				<div class="panel-heading">File Attach</div>
				<!-- /. panel-heading -->
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple>
					</div>
					
					<div class="uploadResult">
						<ul>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
		$(document).ready(function(){
			var formObj = $('form[role="form"]');
			$('button[type="submit"]').on('click', function(e){
				e.preventDefault();
				console.log('submit click')

				var str = '';
				$('.uploadResult ul li').each(function(i, obj){
					var jobj = $(obj);
					str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data('filename') + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data('uuid') + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data('path') + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data('type') + "'>";
				})
				formObj.append(str).submit();
			})

			// 파일첨부 관련.
			// 파일크기 지정, 확장자 제한.
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5 * 1024 * 1023; 
		
		function checkExtension(fileName,fileSize){
			if(fileSize > maxSize){
				alert('파일 사이즈 초과');
				return false;
			}
			if(regex.test(fileName)){
				alert('해당 종류의 파일은 전송할 수 없습니다.');
				return false;
			}
			return true;
		}
			// 첨부파일을 선택하면 change 이벤트.
			$('input[type="file"]').change(function (){
				var formData = new FormData();
		var inputFile = $('input[name="uploadFile"]');
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		//Ajax 활용 파일전송
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			data: formData, // file전송 : multipart/form-data, key-val&key=val
			type: 'POST',
			dataType: 'json',
			success: function(result){
				console.log(result);
				
				
			showUploadedFile(result);
				
			//	$(".uploadDiv").html(cloneObj.html());
				
			},
			error: function(err){
				console.log(err);
			}
			})
		})

		$('.uploadResult').on('click', 'button', function(e){
			console.log('delete ...');
			var targetFile = $(this).data('file');
			var type = $(this).data('type')

			var targetLi = $(this).closest('li');
			$.ajax({
				url: '/deleteFile',
				data: {
					fileName: targetFile,
					type: type
				},
				type: 'post',
				dataType: 'text',
				success: function(result){
					alert(result);
					targetLi.remove();
				}
			})
		})

		function showUploadedFile(uploadResultArr){
			//upload 결과가 없으면 함수 종료.
			if(!showUploadedFile || showUploadedFile.length == 0){
				return;
			}
			var uploadUL = $('.uploadResult ul');
			var str = '';

			$(uploadResultArr).each(function(i, obj){
				if(obj.image){
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>"
				str += "<div>"
				str += "<span>" + obj.fileName + "</span>";
				str += "<button data-file='" + fileCallPath + "' data-type='image' type='button' class='btn btn-waring btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div></li>";
				}  else {
				//str += "<li>" + obj.fileName + "</li>";
			
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>"
				str += "<div>"
				str += "<span>" + obj.fileName + "</span>";
				str += "<button data-file='" + fileCallPath + "' data-type='file' type='button' class='btn btn-waring btn-circle'><i class='fa fa-times'></i></button><br>"
				str += "<a><img src='/resources/img/attach.png'></a>";
				str += "</div></li>";
				
			}
			})
			uploadUL.append(str);
		}
	})


	</script>	


	<%@ include file="../includes/footer.jsp" %>